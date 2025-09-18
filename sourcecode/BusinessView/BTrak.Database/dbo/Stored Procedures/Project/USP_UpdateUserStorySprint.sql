CREATE PROCEDURE [dbo].[USP_UpdateUserStorySprint]
(
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@SprintId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		        DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))

				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

				DECLARE @UserStoryStatusId UNIQUEIDENTIFIER

				
				DECLARE @NewProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Sprints] WHERE Id = @SprintId)

				DECLARE @OldSprintId UNIQUEIDENTIFIER = (SELECT SprintId FROM [dbo].[UserStory] WHERE Id = @UserStoryId )

				DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM [dbo].[UserStory] WHERE Id = @UserStoryId)

				DECLARE @CurrentDate DATETIME = GETDATE()

				DECLARE @IsBacklog BIT = (SELECT IsBacklog FROM [dbo].[UserStory] WHERE Id = @UserStoryId)

				DECLARE @OldUserStoryStatusId UNIQUEIDENTIFIER = (SELECT UserStoryStatusId FROM [dbo].[UserStory] WHERE Id = @UserStoryId)

				DECLARE @MaxOrderId INT = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE SprintId = @SprintId)
                DECLARE @ParentUserStoryId UNIQUEIDENTIFIER = (SELECT ParentUserStoryId FROM UserStory WHERE Id = @UserStoryId AND InActiveDateTime IS NULL AND ParkedDateTime IS NULL)
			    DECLARE @ParentSprintId UNIQUEIDENTIFIER = (SELECT SprintId FROM [dbo].[UserStory] WHERE Id = @ParentUserStoryId)

				IF (@HavePermission = '1')
				BEGIN

				  DECLARE @TaskStatusId UNIQUEIDENTIFIER = (SELECT USS.TaskStatusId FROM [dbo].[UserStory]US
			                                           INNER JOIN [dbo].[UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
													   WHERE US.Id = @UserStoryId)

				   DECLARE @WorkflowId UNIQUEIDENTIFIER = (SELECT BTW.WorkFlowId FROM [dbo].[BoardTypeWorkFlow]BTW
				                                           INNER JOIN [dbo].[Sprints] S ON S.BoardTypeId = BTW.WorkFlowId
														   WHERE S.Id = @SprintId)
				   SET @UserStoryStatusId = (SELECT TOP(1) WS.UserStoryStatusId 
											                          FROM WorkflowStatus WS 
											                               INNER JOIN BoardTypeWorkFlow BTW ON BTW.WorkFlowId = WS.WorkflowId
											                               INNER JOIN Sprints S ON S.BoardTypeId = BTW.BoardTypeId
																		   INNER JOIN UserStoryStatus USS ON USS.Id = WS.UserStoryStatusId
																	       INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
											                          WHERE S.Id = @SprintId AND USS.TaskStatusId = @TaskStatusId Order by WS.OrderId ASC)

					CREATE TABLE #UserStory 
                    (
                                UserStoryId UNIQUEIDENTIFIER
                    )

				    INSERT INTO #UserStory(UserStoryId)
				    SELECT @UserStoryId
			        
					INSERT INTO #UserStory(UserStoryId)
					SELECT US1.Id FROM UserStory US INNER JOIN UserStory US1 ON US.Id = US1.ParentUserStoryId 
							                           AND US.InActiveDateTime IS NULL  AND US1.InActiveDateTime IS NULL
							                            WHERE US.Id = @UserStoryId AND US1.GoalId = US.GoalId
					 
					                Update [dbo].[UserStory] 
									SET  [SprintId] = @SprintId,
										 [UserStoryStatusId] = CASE WHEN @IsBacklog = 1 THEN @OldUserStoryStatusId
										                        ELSE @UserStoryStatusId
																END,
										 [WorkFlowId] = @WorkflowId,
										 [UpdatedDateTime] = @CurrentDate,
										 [UpdatedByUserId] = @OperationsPerformedBy,
										 [Order] = @MaxOrderId + 1,
										 [IsBacklog] = NULL,
										 ProjectId = @NewProjectId
									WHERE Id = @UserStoryId OR ParentUserStoryId = @UserStoryId
					
				   IF(@ParentUserStoryId IS NOT NULL AND @SprintId <> @ParentSprintId AND @SprintId IS NOT NULL AND @ParentSprintId IS NOT NULL)
				   BEGIN
				     UPDATE UserStory SET ParentUserStoryId = NULL WHERE Id = @UserStoryId
				   END

									INSERT INTO [UserStoryHistory] ([Id],
													[UserStoryId],
													[FieldName],
													[OldValue],
													[NewValue],
													[Description],
													CreatedByUserId,
													CreatedDateTime
												   )
										    SELECT  NEWID(),
											        UserStoryId,
													'SprintId',
													CASE WHEN @OldSprintId <> @SprintId THEN (SELECT SprintName FROM Sprints WHERE Id = @OldSprintId)
													   ELSE (SELECT GoalName FROM Goal WHERE Id = @GoalId) END,
													(SELECT SprintName FROM Sprints WHERE Id = @SprintId),
													'MovedToSprint',
													@OperationsPerformedBy,
													GETDATE()
											FROM #UserStory 

						SELECT Id FROM [Userstory] WHERE Id = @UserStoryId
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