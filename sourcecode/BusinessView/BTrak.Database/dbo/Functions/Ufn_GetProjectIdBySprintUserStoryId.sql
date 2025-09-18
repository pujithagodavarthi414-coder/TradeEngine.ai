CREATE FUNCTION [dbo].[Ufn_GetProjectIdBySprintUserStoryId]
(
   @UserStoryId UNIQUEIDENTIFIER 
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
      DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT P.Id FROM [Project] P
                                        JOIN [Sprints] S WITH (NOLOCK) ON S.ProjectId = P.Id
                                        JOIN UserStory US WITH (NOLOCK) ON US.SprintId = S.Id
                            WHERE US.Id = @UserStoryId)
      RETURN @ProjectId
END
