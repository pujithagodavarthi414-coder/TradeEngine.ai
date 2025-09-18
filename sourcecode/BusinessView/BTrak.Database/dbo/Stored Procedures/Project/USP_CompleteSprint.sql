CREATE PROCEDURE [dbo].[USP_CompleteSprint]
	@SprintId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

            DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Sprints] WHERE Id = @SprintId)

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

		    IF (@HavePermission = '1')
            BEGIN
			   DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM [Sprints] WHERE Id = @SprintId) = @TimeStamp
                                         THEN 1 ELSE 0 END)
			   IF(@IsLatest = 1)
               BEGIN
			       
			        DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET()

			        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					INSERT INTO SprintHistory
                        (
                            Id,
                            SprintId,
                            FieldName,
                            OldValue,
                            NewValue,
                            [Description],
                            CreatedByUserId,
                            CreatedDateTime
                        )
                        SELECT NEWID(),
                               @SprintId,
                               'SprintCompleted',
                               'No',
                               'Yes',
                               'SprintCompleted',
                               @OperationsPerformedBy,
                               GETDATE()

					 UPDATE [Sprints]
			         SET IsComplete = 1,
					     SprintCompletedDate = GETDATE()
					 WHERE Id = @SprintId

					 CREATE TABLE #UserStory 
                                (
                                UserStoryId UNIQUEIDENTIFIER
                                )

				    INSERT INTO #UserStory(UserStoryId)
				   
					    SELECT US.Id FROM [dbo].[UserStory]US 
					                                    INNER JOIN [dbo].[UserStoryStatus]USS ON USS.Id = US.UserStoryStatusId
														JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id 
														WHERE US.SprintId = @SprintId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
														AND (TS.[Order] NOT IN (4,6))
					DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT Id FROM [Goal] WHERE ProjectId = @ProjectId AND GoalName = 'Backlog' AND GoalShortName = 'Backlog')
									
					         UPDATE [dbo].[UserStory]
							     SET 
								     [SprintId] = NULL,
									 [GoalId] = @GoalId,
								     [UpdatedDateTime] = @CurrentDate,
									 [UpdatedByUserId] = @OperationsPerformedBy

							 FROM [Userstory] US INNER JOIN #UserStory USS ON USS.UserStoryId = US.Id 
					
					   SELECT Id FROM [dbo].[Sprints] WHERE Id = @SprintId
			   END
			 ELSE

               RAISERROR (50015,11, 1)
       END

       ELSE

           RAISERROR (@HavePermission,11, 1)

   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO