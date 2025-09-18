-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Save or Update UserStoryReplan
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryReplan] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@UserStoryId='DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5',@UserStoryReplanTypeId='F31341B2-7F08-4BDD-AD1B-7DC6B3824593',
--@UserStoryReplanJson='{"UserStoryId":"D06D0B85-BA72-47D7-AE0E-01EC75E11373","NewUserStory" : "Test Replan AND Userstory","OldDeadLine":"2018-09-18T00:00:00","NewDeadLine":"2018-09-24T00:00:00"}'
-------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertUserStoryReplan]
(
  @UserStoryReplanId UNIQUEIDENTIFIER = NULL,
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @UserStoryReplanTypeId UNIQUEIDENTIFIER = NULL,
  @UserStoryReplanJson NVARCHAR(MAX) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
   	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	    --DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))
		     
	    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
		BEGIN

	      DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @GoalReplanId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM GoalReplan WHERE GoalId = (SELECT GoalId FROM UserStory WHERE Id = @UserStoryId) ORDER BY CreatedDateTime DESC)

		  IF(@GoalReplanId IS NULL)
		  BEGIN

			RAISERROR ('GoalReplanIdNotFound',10, 1)

		  END

		  ELSE
		  BEGIN
				
			 DECLARE @IsLatest BIT = (CASE WHEN @UserStoryReplanId IS NULL 
			                           THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                    FROM [UserStoryReplan] WHERE Id = @UserStoryReplanId) = @TimeStamp
			 											THEN 1 ELSE 0 END END)
			 
			 IF(@IsLatest = 1)
			 BEGIN
			 	
			 	IF(@UserStoryReplanId IS NULL)
				BEGIN

				SET @UserStoryReplanId  =  NEWID()

			   	  INSERT INTO [dbo].[UserStoryReplan](
			 				  [Id],
			 				  [GoalReplanId],
			 				  [UserStoryId],
			 				  [UserStoryReplanTypeId],
			 				  [UserStoryReplanJson],
			 				  [CreatedDateTime],
			 				  [CreatedByUserId]
							  )
			 	     SELECT   @UserStoryReplanId,
			 		          @GoalReplanId,
			 				  @UserStoryId,
			 				  @UserStoryReplanTypeId,
			 				  @UserStoryReplanJson,
			 				  @Currentdate,
			 				  @OperationsPerformedBy

				  END
				  ELSE
				  BEGIN

				       UPDATE [dbo].[UserStoryReplan]
			 			SET   [GoalReplanId] = @GoalReplanId,
			 				  [UserStoryId] = @UserStoryId,
			 				  [UserStoryReplanTypeId] = @UserStoryReplanTypeId,
			 				  [UserStoryReplanJson] = @UserStoryReplanJson
							  WHERE Id = @UserStoryReplanId

				  END
			 	
			 	SELECT Id FROM [dbo].UserStoryReplan WHERE Id = @UserStoryReplanId
			 
			 END	
			 ELSE
			  
			 	RAISERROR (50008,11, 1)
			 
			 IF (@HavePermission = '1')
			 BEGIN

				 UPDATE [dbo].[Userstory]
				 SET    UserStoryName     = CASE WHEN @UserStoryReplanTypeId = (SELECT Id FROM UserStoryReplanType WHERE IsUserStoryChange = 1) THEN JSON_VALUE(@UserStoryReplanJson,'$.NewUserStory') ELSE UserStoryName END,
					   EstimatedTime	 = CASE WHEN @UserStoryReplanTypeId = (SELECT Id FROM UserStoryReplanType WHERE IsEstimatedTimeChange = 1 ) THEN JSON_VALUE(@UserStoryReplanJson,'$.NewEstimatedTime') ELSE EstimatedTime END,
					   DeadLineDate		 = CASE WHEN @UserStoryReplanTypeId = (SELECT Id FROM UserStoryReplanType WHERE IsDeadLineChange = 1 ) THEN JSON_VALUE(@UserStoryReplanJson,'$.NewDeadLine') ELSE DeadLineDate END,
					   OwnerUserId		 = CASE WHEN @UserStoryReplanTypeId = (SELECT Id FROM UserStoryReplanType WHERE IsOwnerChange = 1) THEN JSON_VALUE(@UserStoryReplanJson,'$.NewOwner') ELSE OwnerUserId END,
					   DependencyUserId	 = CASE WHEN @UserStoryReplanTypeId = (SELECT Id FROM UserStoryReplanType WHERE IsDependencyChange = 1 ) THEN JSON_VALUE(@UserStoryReplanJson,'$.NewDependency') ELSE DependencyUserId END,
				        UpdatedDateTime  = @Currentdate,
					   UpdatedByUserId = @OperationsPerformedBy
					   WHERE Id = @UserStoryId
			 
			 END

			 ELSE
			 BEGIN
			 
			 	    RAISERROR (@HavePermission,11, 1)
			 
			 END

			END

	   END

	   ELSE
	   BEGIN
	   
	   	    RAISERROR (@HavePermission,11, 1)
	   
	   END

    END TRY  

	BEGIN CATCH 
		
		THROW

	END CATCH
END
GO