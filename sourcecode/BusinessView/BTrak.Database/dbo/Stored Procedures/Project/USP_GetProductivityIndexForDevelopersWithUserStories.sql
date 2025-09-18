CREATE PROCEDURE [dbo].[USP_GetProductivityIndexForDevelopersWithUserStories]
(
 @Date DATETIME,
 @UserId UNIQUEIDENTIFIER,
 @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
DECLARE @DateFrom DATETIME
DECLARE @DateTo DATETIME

     SELECT @DateFrom = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)
     SELECT @DateTo = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))

 IF(@UserId = '00000000-0000-0000-0000-000000000000')
 BEGIN
     SET @UserId = NULL
 END

 IF(@DateTo >= CONVERT(DATE,GETUTCDATE()))
 BEGIN
   SELECT @DateTo = CONVERT(DATE,GETUTCDATE())
 END

 SELECT UserId,PIFD.UserName,ProjectName,GoalName,(ISNULL(U.FirstName,'') + ISNULL(U.SurName,'')) GoalResponsiblePersonName,UserStoryName,G.BoardTypeId,B.BoardTypeName
        ,ProductivityIndex,US.DeadLineDate,CompletedUserStoresCount CompletedUserStoriesCount,UserStoryBouncedBackOnceCount,UserStoryBouncedBackMoreThanOnceCount
 FROM dbo.[Ufn_ProductivityIndexForDevelopers](@DateFrom,@DateTo,@UserId,@CompanyId) PIFD JOIN UserStory US ON US.Id = PIFD.UserStoryId
      JOIN Goal G WITH (NOLOCK) ON G.Id = US.GoalId JOIN Project P WITH (NOLOCK) ON P.Id = G.ProjectId JOIN [User] U WITH (NOLOCK) ON U.Id = G.GoalResponsibleUserId JOIN BoardType B ON B.Id = G.BoardTypeId
 WHERE P.CompanyId = @CompanyId
 ORDER BY US.DeadLineDate DESC

END