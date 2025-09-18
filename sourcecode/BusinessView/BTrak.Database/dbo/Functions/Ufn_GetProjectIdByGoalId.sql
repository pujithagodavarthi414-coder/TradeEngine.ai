CREATE FUNCTION [dbo].[Ufn_GetProjectIdByGoalId]
(
   @GoalId UNIQUEIDENTIFIER
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
      DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT P.Id FROM [Project] P
                                        JOIN [Goal] G WITH (NOLOCK) ON G.ProjectId = P.Id
                            WHERE G.Id = @GoalId)
      RETURN @ProjectId
END
