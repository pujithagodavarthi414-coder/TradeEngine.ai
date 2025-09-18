-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-06 00:00:00.000'
-- Purpose      To Save or Update the UserStoryStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@StatusName='Test',@TaskStatusId=N'F2B40370-D558-438A-8982-55C052226581'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStoryStatus]
(
  @UserStoryStatusId  UNIQUEIDENTIFIER = NULL,
  @TaskStatusId  UNIQUEIDENTIFIER = NULL,
  @StatusName  NVARCHAR(250) = NULL,
  @StatusColor NVARCHAR(30) = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
		SET NOCOUNT ON
	    BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		    
			 IF(@IsArchived = 1 AND @UserStoryStatusId IS NOT NULL)
		     BEGIN
​
		       DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    		   
               IF(EXISTS(SELECT Id FROM [UserStory] WHERE UserStoryStatusId = @UserStoryStatusId))
               BEGIN
	           
               SET @IsEligibleToArchive = 'ThisUserStoryStatusUsedInUserStoryDeleteTheDependenciesAndTryAgain'
               
               END
			   ELSE IF(EXISTS(SELECT Id FROM [WorkflowStatus] WHERE UserStoryStatusId = @UserStoryStatusId))
               BEGIN
	           
               SET @IsEligibleToArchive = 'ThisUserStoryStatusUsedInWorkFlowStatusDeleteTheDependenciesAndTryAgain'
               
               END
			   ELSE IF(EXISTS(SELECT Id FROM [UserStoryStatusConfiguration] WHERE UserStoryStatusId = @UserStoryStatusId))
               BEGIN
	           
               SET @IsEligibleToArchive = 'ThisUserStoryStatusUsedInUserStoryStatusConfigurationDeleteTheDependenciesAndTryAgain'
               
               END
			   ELSE IF(EXISTS(SELECT Id FROM [WorkflowEligibleStatusTransition] WHERE FromWorkflowUserStoryStatusId = @UserStoryStatusId))
               BEGIN
	           
               SET @IsEligibleToArchive = 'ThisUserStoryStatusUsedInWorkFlowEligibleStatusTransitionDeleteTheDependenciesAndTryAgain'
               
               END
			   
			   IF(@IsEligibleToArchive <> '1')
               BEGIN
         	   
                RAISERROR (@isEligibleToArchive,11, 1)
         	   
               END
            END
​
		    --DECLARE @Currentdate DATETIME = GETDATE()
​
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	        SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

             DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)

​
			DECLARE @UserstoryStatusIdCount INT = (SELECT COUNT(1) FROM UserStoryStatus WHERE Id = @UserStoryStatusId AND CompanyId = @CompanyId)
​
			DECLARE @UserStoryStatusCount INT = (SELECT COUNT(1) FROM UserStoryStatus WHERE [Status] = @StatusName AND CompanyId = @CompanyId AND (@UserStoryStatusId IS NULL OR Id <> @UserStoryStatusId))
​
			IF(@UserstoryStatusIdCount = 0 AND @UserStoryStatusId IS NOT NULL)
			BEGIN
​
				RAISERROR(50002,16, 1,'UserStoryStatus')
​
			END
​
			ELSE IF(@UserStoryStatusCount > 0)
			BEGIN
​
				RAISERROR(50001,16,1,'UserStoryStatus')
​
			END
​
			ELSE IF(@TaskStatusId IS NULL)
			BEGIN
​
				RAISERROR(50025,16,1)
​
			END
​
			ELSE
			BEGIN
​
				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
​
				IF (@HavePermission = '1')
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @UserStoryStatusId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM UserStoryStatus  WHERE Id = @UserStoryStatusId
																	   ) = @TimeStamp
																THEN 1 ELSE 0 END END)
					IF(@IsLatest = 1)
					BEGIN
​
					IF(@UserStoryStatusId IS NULL)
					BEGIN

						SET @UserStoryStatusId = NEWID()
					 INSERT INTO [dbo].[UserStoryStatus](
						             [Id],
									  [Status],
									  [TaskStatusId],
									  [StatusHexValue],
									  --[IsArchived],
									  --[ArchivedDateTime],
									  [CompanyId],
									  [CreatedDateTime],
									  [CreatedDateTimeZoneId],
									  [CreatedByUserId],
									  [InActiveDateTime])
						       SELECT @UserStoryStatusId,
								       @StatusName,
									   @TaskStatusId,
									   @StatusColor,
									   --@IsArchived,
									   --CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									   @CompanyId,
									   @Currentdate,
									   @TimeZoneId,
									   @OperationsPerformedBy,
									   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					END
					ELSE
					BEGIN

						UPDATE [dbo].[UserStoryStatus]
							SET  [Status]					  =   		@StatusName,
									  [TaskStatusId]		  =   		@TaskStatusId,
									  [StatusHexValue]		  =   		@StatusColor,
									  --[IsArchived]		  =   		--@IsArchived,
									  --[ArchivedDateTime]	  =   		--CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  [CompanyId]			  =   		@CompanyId,
									  [UpdatedDateTime]		  =   		@Currentdate,
									  [UpdatedDateTimeZoneId] =         @TimeZoneId,
									  [UpdatedByUserId]		  =   		@OperationsPerformedBy,
									  [InActiveDateTime]	  =   		CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  [InActiveDateTimeZoneId]	  =   	CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END
							WHERE Id = @UserStoryStatusId

					END
​
						SELECT Id FROM [dbo].[UserStoryStatus] where Id = @UserStoryStatusId
​
					END
					ELSE
​
			  		RAISERROR (50008,11, 1)
				END
				ELSE
				BEGIN
​
						RAISERROR (@HavePermission,11, 1)
						
				END
			END
​
	   END TRY  
	   BEGIN CATCH 
		
		   THROW
​
	  END CATCH
​
END
GO