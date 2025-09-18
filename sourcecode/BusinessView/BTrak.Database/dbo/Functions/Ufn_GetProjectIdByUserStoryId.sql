CREATE FUNCTION [dbo].[Ufn_GetProjectIdByUserStoryId]
(
   @UserStoryId UNIQUEIDENTIFIER 
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
      DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT P.Id FROM [Project] P
                                        JOIN [Goal] G WITH (NOLOCK) ON G.ProjectId = P.Id
                                        JOIN UserStory US WITH (NOLOCK) ON US.GoalId = G.Id
                            WHERE US.Id = @UserStoryId)
      RETURN @ProjectId
END
