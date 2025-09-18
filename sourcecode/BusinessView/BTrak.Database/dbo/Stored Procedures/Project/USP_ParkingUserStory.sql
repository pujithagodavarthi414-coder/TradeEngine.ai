-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-23 00:00:00.000'
-- Purpose      To Park The UserStory
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--declare @TimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM [Userstory] WHERE Id = '9A201000-B260-444E-82BC-1765812598B3')
-- EXEC [dbo].[USP_ParkingUserStory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @UserStoryId='9A201000-B260-444E-82BC-1765812598B3',@IsParked=1,@TimeStamp = @TimeStamp
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ParkingUserStory]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @IsParked  BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @TimeZone NVARCHAR(250) = NULL ,
  @TimeStamp TIMESTAMP = NULL,
  @IsFromSprint BIT = NULL
)
AS
BEGIN
       SET NOCOUNT ON
	   BEGIN TRY

	      DECLARE @ProjectId UNIQUEIDENTIFIER 

	      DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

		  IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		  IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL

		   IF (@IsFromSprint = 1)
			BEGIN
			  SET @ProjectId =
              (
                SELECT [dbo].[Ufn_GetProjectIdBySprintUserStoryId](@UserStoryId)
              )
			END
			ELSE
			BEGIN
              SET @ProjectId =
              (
                SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId)
              )
			END

		  IF(@UserStoryId IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'User Story')
		  
		  END
		  ELSE
		  BEGIN

				IF (@HavePermission = '1')
				BEGIN

				        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

						DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	                    SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
		                	
                        DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())

						DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM UserStory WHERE Id = @UserStoryId)						

						DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
			                                                           FROM UserStory WHERE Id = @UserStoryId) = @TimeStamp
																THEN 1 ELSE 0 END)

						IF(@IsLatest = 1)
					    BEGIN
						     
							 CREATE TABLE #UserStory 
                                (
                                UserStoryId UNIQUEIDENTIFIER,
                                ParkedDateTime DATETIME
                                )
                             INSERT INTO #UserStory(UserStoryId,ParkedDateTime)
                             SELECT US.Id,US.ParkedDateTime 
							 FROM UserStory US WHERE (US.Id = @UserStoryId OR US.ParentUserStoryId = @UserStoryId)

							    DECLARE @ParkedDateTime DATETIME = (SELECT ParkedDateTime FROM UserStory WHERE Id = @UserStoryId)
		
		                        DECLARE @FieldName NVARCHAR(200),@HistoryDescription NVARCHAR(800)
		                        
                                IF((@IsParked = 1 AND @ParkedDateTime IS NULL) OR (@IsParked = 0 AND @ParkedDateTime IS NOT NULL))
		                        BEGIN
		                        
		                        	 DECLARE @OldParkedDateTime NVARCHAR(250) = CASE WHEN @IsParked = 1 THEN NULL WHEN @IsParked = 0 THEN @ParkedDateTime END
		                             DECLARE @NewParkedDateTime NVARCHAR(250) = CASE WHEN @IsParked = 1 THEN GETDATE() WHEN @IsParked = 0 THEN NULL END
		                        
		                             SET @FieldName = 'ParkedDateTime'	
		                             SET @HistoryDescription = CASE WHEN @IsParked = 1 THEN 'UserstoryParked' WHEN @IsParked = 0 THEN 'UserstoryUnparked' END	
		                             
		                              INSERT INTO [dbo].[UserStoryHistory](
                                                            [Id],
                                                            [UserStoryId],
                                                            [OldValue],
                                                            [NewValue],
                                                            [FieldName],
                                                            [Description],
                                                            CreatedDateTime,
															CreatedDateTimeZoneId,
                                                            CreatedByUserId)
                                                     SELECT NEWID(),
                                                            TUST.UserStoryId,
                                                            TUST.ParkedDateTime,
                                                            CASE WHEN @IsParked = 1 THEN @Currentdate ELSE Null END,
                                                            @FieldName,
                                                            @HistoryDescription,
                                                            @Currentdate,
															@TimeZoneId,
                                                            @OperationsPerformedBy
                                                       FROM #UserStory TUST 
		                        
		                        END

							 UPDATE [dbo].[Userstory]
							      SET ParkedDateTime = CASE WHEN @IsParked = 1 THEN @Currentdate ELSE NULL END,
							           ParkedDateTimeZoneId = CASE WHEN @IsParked = 1 THEN @TimeZoneId ELSE NULL END
                                      ,[UpdatedByUserId] = @OperationsPerformedBy
									  ,[UpdatedDateTimeZoneId] = @TimeZoneId
									  ,[UpdatedDateTime] = @Currentdate
							 FROM [dbo].[Userstory] US INNER JOIN #UserStory TUS ON TUS.UserStoryId = US.Id


							   UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId 
							    
							 SELECT Id FROM [dbo].[UserStory] where Id = @UserStoryId

					    END

						ELSE

			  				RAISERROR (50008,11, 1)

				END
				ELSE 
				BEGIN
				
				   RAISERROR (@HavePermission,11, 1)
				
				END
		  END
				
		END TRY  
	    BEGIN CATCH 
		
		   THROW

	   END CATCH

END
GO