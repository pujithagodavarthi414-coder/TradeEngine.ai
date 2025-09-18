-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-10-21 00:00:00.000'
-- Purpose      To Update the link of userstorysubtypes
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpdateUserStoryLink] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @UserStoryId='5DE9E4F6-C7CA-4390-9D68-17DB10155D71',@ParentUserStoryId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpdateUserStoryLink]
(
   @UserStoryId UNIQUEIDENTIFIER = NULL,
   @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
   @IsSprintUserStories BIT = NULL,
   @GoalId NVARCHAR(50) = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		     DECLARE @ProjectId UNIQUEIDENTIFIER
		     IF(@IsSprintUserStories = 1)
			 BEGIN
			    SET @ProjectId  = (SELECT [dbo].[Ufn_GetProjectIdBySprintUserStoryId](@UserStoryId))
			 END
			 ELSE
			 BEGIN
			     SET @ProjectId  = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))
			 END

	         DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
			IF (@HavePermission = '1')
            BEGIN
			 DECLARE @IsLatest BIT = (CASE WHEN @UserStoryId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM UserStory WHERE Id = @UserStoryId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            
              IF(@IsLatest = 1)
              BEGIN

				   DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

				   DECLARE @NewUserStoryId UNIQUEIDENTIFIER = NEWID()

				   DECLARE @OldParentUserStoryId UNIQUEIDENTIFIER = (SELECT ParentUserStoryId FROM UserStory WHERE Id = @UserStoryId  AND InActiveDateTime IS NULL)
			        
				DECLARE @GoalId1  UNIQUEIDENTIFIER = (SELECT GoalId FROM UserStory WHERE ID = @ParentUserStoryId)

				UPDATE UserStory SET UpdatedDateTime = @CurrentDate,ParentUserStoryId = @ParentUserStoryId,UpdatedByUserId = @OperationsPerformedBy,GoalId = @GoalId1
				WHERE Id = @UserStoryId  

				IF (@UserStoryId IS NOT NULL)
				BEGIN
					
					INSERT INTO [UserStoryHistory] (
												    [Id],
													[UserStoryId],
													[FieldName],
													[OldValue],
													[NewValue],
													[Description],
													CreatedByUserId,
													CreatedDateTime
												   )
										    SELECT  NEWID(),
											        @UserStoryId,
													'ParentUserStoryId',
													(SELECT UserStoryName FROM UserStory WHERE Id = @OldParentUserStoryId),
													(SELECT UserStoryName FROM UserStory WHERE Id = @ParentUserStoryId),
													'ParentUserStoryChanged',
													@OperationsPerformedBy,
													GETDATE()

				END
				
				SELECT Id FROM [Userstory] WHERE Id = @UserStoryId 
			END	
			ELSE

              BEGIN
                    
					RAISERROR (50008,11, 1)
                                         
              END
			END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
