CREATE FUNCTION [dbo].[Ufn_GetEmployeeWorkAllocationToADate]
(
    @UserId UNIQUEIDENTIFIER,
    @Date DATETIME,
    @ProjectId UNIQUEIDENTIFIER,
    @GoalId UNIQUEIDENTIFIER,
    @UserStoryId UNIQUEIDENTIFIER
)
RETURNS FLOAT
BEGIN
    DECLARE @WorkAllocation FLOAT
    SELECT @WorkAllocation = SUM(EstimatedTime)
    FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId JOIN [User] U ON U.Id = US.OwnerUserId 
	JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
    WHERE [Status] IN ('Blocked','Inprogress','Analysis Completed','Dev Inprogress','Not Started')
          AND U.Id = @UserId AND P.Id = @ProjectId AND G.Id = @GoalId AND US.Id = @UserStoryId
          AND (G.InActiveDateTime IS NULL)
    RETURN ISNULL(@WorkAllocation,0)
END