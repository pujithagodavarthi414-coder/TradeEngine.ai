-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-09 00:00:00.000'
-- Purpose      To Save or Update UserStoryReplanType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertUserStoryReplanType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ReplanTypeName='GoalPost'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStoryReplanType]
(
  @UserStoryReplanTypeId UNIQUEIDENTIFIER = NULL,
  @ReplanTypeName NVARCHAR(100) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT =0,
  @TimeStamp TIMESTAMP = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @UserstoryReplanTypeIdCount INT = (SELECT COUNT(1) FROM UserStoryReplanType WHERE Id = @UserStoryReplanTypeId )

		DECLARE @UpdateUserstoryReplantypeCount INT = (SELECT COUNT(1) FROM UserStoryReplanType WHERE ReplanTypeName = @ReplanTypeName AND (@UserStoryReplanTypeId IS NULL OR Id <> @UserStoryReplanTypeId))

		IF(@IsArchived IS NULL) SET @IsArchived = 0

		IF(@IsArchived = 1 AND @UserStoryReplanTypeId IS NOT NULL)
		BEGIN

		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
            IF(EXISTS(SELECT Id FROM [UserStoryReplan] WHERE UserStoryReplanTypeId = @UserStoryReplanTypeId))
            BEGIN
	        
            SET @IsEligibleToArchive = 'ThisUserStoryReplanTypeUsedInUserStoryReplanDeleteTheDependenciesAndTryAgain'
            
            END

			IF(@IsEligibleToArchive <> '1')
            BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
             END
		END

		IF(@UserstoryReplanTypeIdCount = 0 AND @UserStoryReplanTypeId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'UserstoryReplanType')
		END

		ELSE IF(@UpdateUserstoryReplantypeCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'UserstoryReplanType')

		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			    
			IF (@HavePermission = '1')
			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @UserStoryReplanTypeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM UserStoryReplanType WHERE Id = @UserStoryReplanTypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					IF(@UserStoryReplanTypeId IS NULL)
					BEGIN

						SET @UserStoryReplanTypeId = NEWID()
					INSERT INTO [dbo].[UserStoryReplanType](
									Id,
									ReplanTypeName,
									InActiveDateTime,
									CreatedDateTime,
									CreatedByUserId
                              )
                       SELECT @UserStoryReplanTypeId,
                              @ReplanTypeName,
							  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							  @Currentdate,
							  @OperationsPerformedBy
                         FROM UserStoryReplanType WHERE Id = @UserStoryReplanTypeId

					END
					ELSE
					BEGIN

						UPDATE [dbo].[UserStoryReplanType]
								SET ReplanTypeName				=  			   @ReplanTypeName,
								--	CompanyId					=  			   @CompanyId,
									InActiveDateTime			=  			   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									UpdatedDateTime				=  			   @Currentdate,
									UpdatedByUserId				=  			   @OperationsPerformedBy,
									[IsEstimatedTimeChange]		=  			   IsEstimatedTimeChange,
									[IsDeadLineChange]			=  			   IsDeadLineChange,
									[IsUserStoryChange]			=  			   IsUserStoryChange,
									[IsDependencyChange]		=  			   IsDependencyChange,
									[IsOwnerChange] 			=  			   IsOwnerChange 
								WHERE Id = @UserStoryReplanTypeId

					END

			        SELECT Id FROM [dbo].UserStoryReplanType WHERE Id = @UserStoryReplanTypeId

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