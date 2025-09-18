CREATE PROCEDURE [dbo].[USP_UpsertUserstoryLogTimeBasedOnPunchCard]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@BreakStarted BIT
)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			 IF(@HavePermission = '1')
			   BEGIN
				IF(@BreakStarted = 1 OR @BreakStarted IS NULL)
				BEGIN
					IF EXISTS(SELECT 1 FROM UserStorySpentTime WHERE StartTime IS NOT NULL AND EndTime IS NULL AND CreatedByUserId = @OperationsPerformedBy)
					BEGIN
					DECLARE @Id UNIQUEIDENTIFIER = (SELECT Id FROM UserStorySpentTime WHERE StartTime IS NOT NULL AND EndTime IS NULL AND CreatedByUserId = @OperationsPerformedBy)
					DECLARE @UserStoryId UNIQUEIDENTIFIER = (SELECT UserStoryId FROM UserStorySpentTime WHERE StartTime IS NOT NULL AND EndTime IS NULL AND CreatedByUserId = @OperationsPerformedBy)
						UPDATE UserStorySpentTime SET EndTime = GETUTCDATE(), BreakType = @BreakStarted, UpdatedByUserId = @OperationsPerformedBy, UpdatedDateTime = GETUTCDATE() WHERE Id = @Id
							SELECT 
							CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN 0
										     WHEN US.GoalId IS NOT NULL THEN 0
											 WHEN US.SprintId IS NOT NULL THEN 1 END AS IsFromSprints,
							CASE WHEN G.GoalName = 'Adhoc Goal' AND P.ProjectName = 'Adhoc project' THEN 1
								ELSE 0 END AS IsFromAdhoc,
							--CASE WHEN US.ParentUserStoryId IS NOT NULL THEN US.ParentUserStoryId 
							--ELSE US.Id END AS UserStoryId
							US.Id AS UserStoryId
							 FROM UserStory US
							INNER JOIN Goal G ON G.Id = US.GoalId
							INNER JOIN Project P ON P.Id = US.ProjectId
							WHERE P.CompanyId = @CompanyId AND Us.Id = @UserStoryId
					END
				END
			   ELSE IF(@BreakStarted = 0)
			   BEGIN
				IF EXISTS(SELECT Top 1 [TimeStamp] FROM UserStorySpentTime WHERE StartTime IS NOT NULL AND EndTime IS NOT NULL AND UpdatedByUserId = @OperationsPerformedBy AND BreakType = 1 ORDER BY [TimeStamp] DESC)
				BEGIN
					DECLARE @LogId UNIQUEIDENTIFIER = (SELECT Id FROM UserStorySpentTime WHERE StartTime IS NOT NULL AND EndTime IS NOT NULL AND UpdatedByUserId = @OperationsPerformedBy AND BreakType = 1)
					DECLARE @RestartUserStoryId UNIQUEIDENTIFIER = (SELECT UserStoryId FROM UserStorySpentTime WHERE StartTime IS NOT NULL AND EndTime IS NOT NULL AND UpdatedByUserId = @OperationsPerformedBy AND BreakType = 1)
					UPDATE UserStorySpentTime SET BreakType = NULL, UpdatedByUserId = @OperationsPerformedBy, UpdatedDateTime = GETUTCDATE() WHERE Id = @LogId
					INSERT INTO [dbo].[UserStorySpentTime] (
													Id,
													UserStoryId,
													UserId,
													CreatedDateTime,
													CreatedByUserId,
													StartTime
												)
												SELECT NEWID(),
														@RestartUserStoryId,
														@OperationsPerformedBy,
														GETUTCDATE(),
														@OperationsPerformedBy,
														GETUTCDATE()
					SELECT 
							CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN 0
										     WHEN US.GoalId IS NOT NULL THEN 0
											 WHEN US.SprintId IS NOT NULL THEN 1 END AS IsFromSprints,
							CASE WHEN G.GoalName = 'Adhoc Goal' AND P.ProjectName = 'Adhoc project' THEN 1
								ELSE 0 END AS IsFromAdhoc,
							--CASE WHEN US.ParentUserStoryId IS NOT NULL THEN US.ParentUserStoryId 
							--ELSE US.Id END AS UserStoryId
							US.Id AS UserStoryId
							 FROM UserStory US
							INNER JOIN Goal G ON G.Id = US.GoalId
							INNER JOIN Project P ON P.Id = US.ProjectId
							WHERE P.CompanyId = @CompanyId AND Us.Id = @RestartUserStoryId
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