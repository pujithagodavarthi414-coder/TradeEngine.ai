--select * from [Ufn_GetEmployeeRemainingUserStories] ('A6081D59-FE66-418F-8ED9-677DC0491DC9','4AFEB444-E826-4F95-AC41-2175E36A0C16')

CREATE FUNCTION [dbo].[Ufn_GetEmployeeRemainingUserStories]
(
    @UserId UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @Result TABLE
(
   UserId UNIQUEIDENTIFIER,
   UserName VARCHAR(500),
   UserStoryId UNIQUEIDENTIFIER,
   UserStoryName VARCHAR(800),
   [Status] VARCHAR(500),
   DeadLineDate DATETIME,
   EstimatedTime DECIMAL(8,2),
   BoardTypeName VARCHAR(500),
   UserStoryStatusId UNIQUEIDENTIFIER
)
AS
BEGIN

   IF(@UserId = '00000000-0000-0000-0000-000000000000')
       BEGIN
           SET @UserId = NULL
       END
   
   INSERT INTO  @Result
   SELECT U.Id UserId,
          U.FirstName+' '+ISNULL(U.SurName,'') UserName,
          US.Id UserStoryId,
		  US.UserStoryName,
		  USS.[Status],
		  Us.DeadLineDate,
		  US.EstimatedTime,
		  BT.BoardTypeName,
          US.UserStoryStatusId
   FROM UserStory US JOIN Project P ON P.Id = US.ProjectId 
        JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id 
        JOIN [User] U ON U.Id = US.OwnerUserId 
        LEFT JOIN Goal G ON G.Id = US.GoalId AND (G.InActiveDateTime IS NULL) 
		LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
        LEFT JOIN BoardType BT ON ( BT.Id = G.BoardTypeId OR S.BoardTypeId = BT.Id)
   WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND G.Id IS NOT NULL))
         AND US.InActiveDateTime IS NULL
		 AND P.InActiveDateTime IS NULL
         AND (@UserId IS NULL OR U.Id = @UserId)
		 AND (((USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'))-- AND BT.IsSuperAgile = 1)
			OR ((USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') )--AND BT.IsKanban = 1)
			OR ((USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') ))--AND BT.IsKanbanBug = 1))
   --      AND (((USS.IsAnalysisCompleted = 1 OR USS.IsNotStarted = 1 OR USS.IsDevInprogress = 1) AND BT.IsSuperAgile = 1)
			--OR ((USS.IsNotStarted = 1 OR USS.IsInprogress = 1) AND BT.IsKanban = 1)
			--OR ((USS.IsNew = 1 OR USS.IsInprogress = 1) AND BT.IsKanbanBug = 1))
		 AND U.CompanyId = @CompanyId

RETURN
END