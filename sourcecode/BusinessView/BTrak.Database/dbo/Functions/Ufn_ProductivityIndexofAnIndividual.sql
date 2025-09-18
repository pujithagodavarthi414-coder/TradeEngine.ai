CREATE FUNCTION [dbo].[Ufn_ProductivityIndexofAnIndividual]
(
    @DateFrom DATETIME,
    @DateTo DATETIME,
    @UserId  UNIQUEIDENTIFIER,
    @CompanyId UNIQUEIDENTIFIER
)
RETURNS @ProductiveIndexForDeveloper TABLE
(
    UserId UNIQUEIDENTIFIER,
    UserName NVARCHAR(800),
    ProductivityIndex FLOAT
)
BEGIN
     DECLARE @ProductiveHoursUserStories TABLE
      (
          UserId UNIQUEIDENTIFIER,
          UserStoryId UNIQUEIDENTIFIER,
          EstimatedTime NUMERIC(10,2),
          TransitionDateTime DATETIME
      )
      INSERT INTO @ProductiveHoursUserStories(UserStoryId,UserId,TransitionDateTime)
      SELECT US.Id,US.OwnerUserId,MAX(TransitionDateTime)
      FROM Goal G 
           INNER JOIN UserStory US ON US.GoalId = G.Id
           INNER JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
           INNER JOIN [User] U ON U.Id = US.OwnerUserId
           INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
           INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
           INNER JOIN [GoalStatus] GS ON GS.Id = G.GoalStatusId
           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
      WHERE GS.IsActive = 1
		   AND USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'
           --AND USS.IsQAApproved = 1
           AND CONVERT(DATE,TransitionDateTime) >= CONVERT(DATE,@DateFrom )
           AND CONVERT(DATE,TransitionDateTime) <= CONVERT(DATE,@DateTo) 
           AND U.IsActive = 1 
           AND IsProductiveBoard = 1  
           AND CH.IsEsimatedHours = 1
           AND U.CompanyId = @CompanyId
      GROUP BY US.Id,US.OwnerUserId,EstimatedTime
      UNION ALL
      SELECT UserStoryId,US.OwnerUserId,MAX(TransitionDateTime) 
      FROM UserStoryWorkflowStatusTransition UWT 
           JOIN UserStory US ON US.Id = UWT.UserStoryId
           JOIN Goal G ON G.Id = US.GoalId
           JOIN [User] U ON U.Id = US.OwnerUserId
           JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
           JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
           JOIN [GoalStatus] GS ON GS.Id = G.GoalStatusId
           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
      WHERE GS.IsActive = 1
		   AND USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'
           AND CONVERT(DATE,DeadLineDate) >= CONVERT(DATE,@DateFrom )
           AND CONVERT(DATE,DeadLineDate) <= CONVERT(DATE,@DateTo )
           AND U.IsActive = 1 
           AND IsProductiveBoard = 1  
           AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
           AND U.CompanyId = @CompanyId
      GROUP BY UserStoryId,US.OwnerUserId
      UNION ALL
      SELECT UWT.UserStoryId,US.OwnerUserId,MAX(TransitionDateTime) 
      FROM UserStoryWorkflowStatusTransition UWT 
           JOIN UserStory US ON US.Id = UWT.UserStoryId
           JOIN Goal G ON G.Id = US.GoalId
           JOIN [User] U ON U.Id = US.OwnerUserId
           JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
           JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
           JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
           JOIN [GoalStatus] GS ON GS.Id = G.GoalStatusId
           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
      WHERE BT.IsBugBoard = 1 
           AND GS.IsActive = 1
           AND USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'
		   --AND USS.IsVerified = 1 
           AND CONVERT(DATE,DeadLineDate) >= CONVERT(DATE,@DateFrom) 
           AND CONVERT(DATE,DeadLineDate) <= CONVERT(DATE,@DateTo) 
           AND U.IsActive = 1 
           AND IsProductiveBoard = 1  
           AND CH.IsEsimatedHours = 1
           AND U.CompanyId = @CompanyId
           AND OwnerUserId <> BCU.UserId 
           AND BCU.UserId IS NOT NULL
      GROUP BY UWT.UserStoryId,US.OwnerUserId
      
	  UPDATE @ProductiveHoursUserStories 
      SET EstimatedTime = US.EstimatedTime
      FROM UserStory US 
           JOIN @ProductiveHoursUserStories PUS ON US.Id = PUS.UserStoryId 
           JOIN Goal G ON G.Id = US.GoalId
           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId 
      WHERE CH.IsEsimatedHours = 1
      
	  UPDATE @ProductiveHoursUserStories 
      SET EstimatedTime = LUSInner.LoggedTime
      FROM @ProductiveHoursUserStories PUS
           JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60) LoggedTime
                 FROM UserStorySpentTime UST 
                      JOIN @ProductiveHoursUserStories PUS ON PUS.UserStoryId = UST.UserStoryId
                      JOIN UserStory US ON US.Id = PUS.UserStoryId
                      JOIN Goal G ON G.Id = US.GoalId 
                      INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
                 WHERE CH.IsLoggedHours = 1
                 GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId
      
	  DECLARE @ProductiveIndex TABLE
      (
          UserId UNIQUEIDENTIFIER,
          UserStoryId UNIQUEIDENTIFIER,
          ProductivityIndex NUMERIC(10,2)
      )
      INSERT INTO @ProductiveIndex(UserId,UserStoryId,ProductivityIndex)
      SELECT UserId,UserStoryId,SUM(EstimatedTime)
      FROM @ProductiveHoursUserStories
      GROUP BY UserId,UserStoryId
      
      INSERT INTO @ProductiveIndexForDeveloper(UserId,UserName,ProductivityIndex)
      SELECT U.Id,U.FirstName + ' ' + ISNULL(U.Surname,''),ISNULL(SUM(ProductivityIndex),0)
      FROM [User] U 
           LEFT JOIN @ProductiveIndex PIX ON PIX.UserId = U.Id
           LEFT JOIN UserStory US ON US.Id = PIX.UserStoryId 
           LEFT JOIN Goal G ON G.Id = US.GoalId 
      WHERE IsActive = 1  
            AND (@UserId IS NULL OR U.Id = @UserId) 
            AND U.CompanyId = @CompanyId
      GROUP BY U.Id,UserStoryId,U.FirstName,U.Surname
      
RETURN 
END