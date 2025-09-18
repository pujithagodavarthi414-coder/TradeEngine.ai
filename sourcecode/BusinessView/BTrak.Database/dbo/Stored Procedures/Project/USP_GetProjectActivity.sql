CREATE PROCEDURE [dbo].[USP_GetProjectActivity]
(
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@GoalId UNIQUEIDENTIFIER = NULL,
	@SprintId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @IsIncludeUserStoryView BIT = NULL,
    @IsIncludeLogTime BIT = NULL,
	@UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            CREATE TABLE #ProjectActivity
            (
                ProjectId UNIQUEIDENTIFIER,
                ProjectName NVARCHAR(MAX),
            	UserStoryOrGoalIdOrSprintId UNIQUEIDENTIFIER,
            	UserStoryOrGoalNameOrSprintName NVARCHAR(800),
            	OldValue NVARCHAR(MAX),
            	NewValue NVARCHAR(MAX),
            	FieldName NVARCHAR(250),
            	[Description] NVARCHAR(MAX),
            	[KeyValue] NVARCHAR(250),
            	UserName NVARCHAR(800),
				ProfileImage NVARCHAR(800),
				UserId UNIQUEIDENTIFIER,
				UniqueName NVARCHAR(800),
				CreatedDateTime DATETIME,
				IsSprintOrGoal BIT
            )

			IF(@GoalId IS NULL)
			BEGIN

			INSERT INTO #ProjectActivity(ProjectId,ProjectName,UserStoryOrGoalIdOrSprintId,UserStoryOrGoalNameOrSprintName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,UniqueName,CreatedDateTime,IsSprintOrGoal)
			EXEC [USP_GetSprintActivityWithUserStories] @ProjectId = @ProjectId,@SprintId = @SprintId,@OperationsPerformedBy = @OperationsPerformedBy,
			                                            @IsIncludeUserStoryView = @IsIncludeUserStoryView,@IsIncludeLogTime = @IsIncludeLogTime,
														@UserId = @UserId

			END
			IF(@SprintId IS NULL)
			BEGIN

			INSERT INTO #ProjectActivity(ProjectId,ProjectName,UserStoryOrGoalIdOrSprintId,UserStoryOrGoalNameOrSprintName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,UniqueName,CreatedDateTime,IsSprintOrGoal)
			EXEC [USP_GetGoalActivityWithUserStories] @ProjectId = @ProjectId,@GoalId = @GoalId,@OperationsPerformedBy = @OperationsPerformedBy,
			                                            @IsIncludeUserStoryView = @IsIncludeUserStoryView,@IsIncludeLogTime = @IsIncludeLogTime,
														@UserId = @UserId

			END

			SELECT T.*,T.UserStoryOrGoalNameOrSprintName as userStoryOrGoalName,T.UserStoryOrGoalNameOrSprintName userStoryOrSprintName FROM #ProjectActivity T ORDER BY CreatedDateTime DESC

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END

