CREATE FUNCTION [dbo].[Ufn_GetEmployeeUserStories]
(
    @UserId UNIQUEIDENTIFIER = NULL,
    @Status VARCHAR(500) = NULL,
    @StartDate DATETIME = NULL,
    @ENDDate DATETIME = NULL,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @Result TABLE
(
   UserId UNIQUEIDENTIFIER INDEX IX0_UserId Clustered,
   UserName VARCHAR(500),
   UserStoryId UNIQUEIDENTIFIER INDEX IX0_UserStoryId,
   UserStoryName VARCHAR(800),
   UserStoryUniqueName VARCHAR(800),
   GoalName VARCHAR(800),
   ProjectName VARCHAR(800),
   ProjectId UNIQUEIDENTIFIER,
   [Status] VARCHAR(500),
   DeadLineDate DATETIME,
   EstimatedTime DECIMAL(8,2),
   UserStoryStatusId UNIQUEIDENTIFIER,
   SprintId UNIQUEIDENTIFIER,
   SprintName VARCHAR(MAX)
)
AS
BEGIN

   IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
   
   IF(@Status = '') SET @Status = NULL

   INSERT INTO  @Result
   SELECT U.Id UserId,
          U.FirstName+' '+ ISNULL(U.SurName,'') UserName,
          US.Id UserStoryId,
		  US.UserStoryName,
		  US.UserStoryUniqueName,
		  G.GoalName,
		  P.ProjectName,
		  P.Id AS ProjectId,
		  USS.Status,
		  Us.DeadLineDate,
		  US.EstimatedTime,
          US.UserStoryStatusId,
          US.SprintId,
		  S.SprintName
   FROM UserStory US 
   	    JOIN Project P WITH (NOLOCK) ON P.Id = US.ProjectId
        JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id 
        JOIN [User] U ON U.Id = US.OwnerUserId 
		LEFT JOIN Goal G ON G.Id = US.GoalId  AND (G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL)
		LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
		LEFT JOIN GoalStatus GS WITH (NOLOCK) ON GS.Id=G.GoalStatusId 
   WHERE  (GS.IsActive = 1 OR ((S.IsReplan = 0 OR S.IsReplan IS NULL) AND S.SprintStartDate IS NOT NULL))
		
		 AND (US.ArchivedDateTime IS NULL AND US.InActiveDateTime IS NULL)
		 AND (P.InActiveDateTime IS NULL)
		 AND (US.ParkedDateTime IS NULL)
         AND (@UserId IS NULL OR U.Id = @UserId)
         AND (@Status IS NULL OR USS.[Status] = @Status)
         AND (@StartDate IS NULL OR (US.DeadLineDate >= @StartDate OR S.SprintStartDate >= @StartDate))  
		 AND (@ENDDate IS NULL OR (US.DeadLineDate <= @ENDDate OR S.SprintEndDate <= @ENDDate))
		 AND U.CompanyId = @CompanyId

RETURN
END