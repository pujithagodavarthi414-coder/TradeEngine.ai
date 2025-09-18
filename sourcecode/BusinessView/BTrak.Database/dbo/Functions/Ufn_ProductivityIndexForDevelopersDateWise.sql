CREATE FUNCTION [dbo].[Ufn_ProductivityIndexForDevelopersDateWise]
(
    @DateFrom DATETIME,
    @DateTo DATETIME,
    @UserId  UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @ProductiveIndexForDeveloper TABLE
(
    UserId UNIQUEIDENTIFIER INDEX IX1_ProductiveIndex_UserId Clustered,
    UserName NVARCHAR(800),
    ProductivityIndex FLOAT,
	BoardTypeId UNIQUEIDENTIFIER,
	GoalId UNIQUEIDENTIFIER,
    UserStoryId UNIQUEIDENTIFIER,
	UserStoryReplanCount NUMERIC(10,2),
    GRPIndex FLOAT,
    ReopenCount INT,
    CompletedUserStoresCount INT,
	QAApprovedUserStoriesCount INT,
	ReopenedUserStoresCount INT,
    UserStoriesBouncedBackOnceCount INT,
    UserStoriesBouncedBackMoreThanOnceCount INT,
    UserStoryBouncedBackOnceCount INT,
    UserStoryBouncedBackMoreThanOnceCount INT,
	[Date] DATE
)
BEGIN
 DECLARE @ProductiveHoursUserStories TABLE
      (
          UserId UNIQUEIDENTIFIER INDEX IX1 CLUSTERED,
          UserStoryId UNIQUEIDENTIFIER,
          EstimatedTime NUMERIC(10,2),
          TransitionDateTime DATETIME
      )

      INSERT INTO @ProductiveHoursUserStories(UserStoryId,UserId,TransitionDateTime)
      SELECT USWST.UserStoryId,@UserId,InnerUW.TransitionDateTime 
      FROM UserStoryWorkflowStatusTransition USWST
      JOIN(SELECT US.Id UserStoryId,US.OwnerUserId,MAX(TransitionDateTime) TransitionDateTime
      FROM Goal G 
	       INNER JOIN UserStory US ON US.GoalId = G.Id AND US.DeadLineDate IS NOT NULL 
					  AND IsProductiveBoard = 1                                                                                                                                                    
	       INNER JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId --AND CONVERT(DATE,UW.TransitionDateTime) BETWEEN '2020-06-02' AND '2020-06-02'    
	       INNER JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL  AND U.IsActive = 1 AND U.CompanyId = @CompanyId
		   INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId --AND BT.IsSuperAgile = 1 
		   INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId AND USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'--(USS.IsQAApproved = 1 OR USS.IsSignedOff = 1)
		   INNER JOIN [GoalStatus] GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId AND (CH.IsEsimatedHours = 1 OR CH.IsLoggedHours = 1)
       GROUP BY US.Id,US.OwnerUserId) AS InnerUW ON InnerUW.UserStoryId = USWST.UserStoryId AND  CONVERT(DATE,InnerUW.TransitionDateTime) = @DateFrom
	   GROUP BY USWST.UserStoryId,InnerUW.TransitionDateTime

	  UPDATE @ProductiveHoursUserStories 
	  SET EstimatedTime = US.EstimatedTime
      FROM UserStory US 
	       JOIN @ProductiveHoursUserStories PUS ON US.Id = PUS.UserStoryId
	       JOIN Goal G ON G.Id = US.GoalId
		   JOIN Project P ON P.Id = G.ProjectId
           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
	  WHERE CH.IsEsimatedHours = 1

	  UPDATE @ProductiveHoursUserStories 
	  SET EstimatedTime = LUSInner.LoggedTime
      FROM @ProductiveHoursUserStories PUS
           JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.00) LoggedTime
                 FROM UserStorySpentTime UST 
				      JOIN @ProductiveHoursUserStories PUS ON PUS.UserStoryId = UST.UserStoryId 
				      JOIN UserStory US ON US.Id = PUS.UserStoryId 
				      JOIN Goal G ON G.Id = US.GoalId 
                      INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId 
	             WHERE CH.IsLoggedHours = 1
					   AND UST.UserId = US.OwnerUserId
                 GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId


	  DECLARE @ProductiveIndex TABLE
      (
          UserId UNIQUEIDENTIFIER INDEX IX1_ProductiveIndex CLUSTERED,
          UserStoryId UNIQUEIDENTIFIER,
          ProductivityIndex NUMERIC(10,2)
      )
	  INSERT INTO @ProductiveIndex(UserId,UserStoryId,ProductivityIndex)
      SELECT UserId,UserStoryId,SUM(EstimatedTime)
      FROM @ProductiveHoursUserStories
      GROUP BY UserId,UserStoryId

      INSERT INTO @ProductiveIndexForDeveloper(UserId,UserStoryId,UserName,ProductivityIndex,BoardTypeId,GoalId,[Date])
      SELECT U.Id,UserStoryId,U.FirstName + ' ' + ISNULL(U.Surname,''),ISNULL(SUM(ProductivityIndex),0),BoardTypeId,GoalId,@DateFrom
      FROM [User] U  
           LEFT JOIN @ProductiveIndex PIX ON PIX.UserId = U.Id AND U.InActiveDateTime IS NULL
	       LEFT JOIN UserStory US ON US.Id = PIX.UserStoryId 
	       LEFT JOIN Goal G ON G.Id = US.GoalId 
      WHERE IsActive = 1  
            AND (@UserId IS NULL OR U.Id = @UserId) 
	        AND U.CompanyId = @CompanyId
      GROUP BY U.Id,UserStoryId,U.FirstName,U.Surname,BoardTypeId,GoalId

	  UPDATE @ProductiveIndexForDeveloper 
	  SET UserStoryReplanCount = ISNULL(CAST((PIDInner.UserStoryReplanCount)*1.00 AS NUMERIC(10,2)),0)
	  FROM @ProductiveIndexForDeveloper PID
	  LEFT JOIN (SELECT PID.UserStoryId,(COUNT(USR.Id))*1.00 UserStoryReplanCount
					  FROM @ProductiveIndexForDeveloper PID 
					       JOIN GoalReplan GR ON GR.GoalId = PID.GoalId 
					       JOIN UserStoryReplan USR ON USR.GoalReplanId = GR.Id 
					       AND USR.UserStoryId = PID.UserStoryId 
						   JOIN GoalReplanType GRT ON GRT.Id = GR.GoalReplanTypeId 
					  WHERE GRT.IsDeveloper = 1
					       AND CONVERT(DATE,GR.CreatedDateTime) BETWEEN @DateFrom AND @DateTo
					  GROUP BY PID.UserStoryId) PIDInner ON PIDInner.UserStoryId = PID.UserStoryId

      UPDATE @ProductiveIndexForDeveloper 
      SET CompletedUserStoresCount = ISNULL(PIDInner.CompletedUserStoresCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (	SELECT	UserId,COUNT(UserStoryId) CompletedUserStoresCount
					FROM	@ProductiveIndex
					WHERE	UserId =ISNULL(@UserId,UserId)
					GROUP BY UserId
				) PIDInner ON PIDInner.UserId = PID.UserId
      
      UPDATE @ProductiveIndexForDeveloper 
      SET QAApprovedUserStoriesCount = ISNULL(PIDInner.QAApprovedUserStoriesCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (SELECT UserId,COUNT(UserStoryId) QAApprovedUserStoriesCount
                       FROM @ProductiveIndexForDeveloper PID
					   JOIN [BoardType] BT ON BT.Id = PID.BoardTypeId
      				   GROUP BY UserId) PIDInner ON PIDInner.UserId = PID.UserId
	  
      DECLARE @BouncedUserStories TABLE
      (
         UserId UNIQUEIDENTIFIER INDEX IX1_ProductiveIndex CLUSTERED,
         UserStoryId UNIQUEIDENTIFIER,
         ReopenCount INT
      )

      INSERT INTO @BouncedUserStories(UserId,UserStoryId,ReopenCount)
      SELECT US.OwnerUserId,USST.UserStoryId, COUNT(1) 
      FROM UserStoryWorkflowStatusTransition USST 
	       JOIN UserStory US ON US.Id = USST.UserStoryId
	       JOIN Goal G ON G.Id = US.GoalId
		   JOIN Project P ON P.Id = G.ProjectId
	       JOIN @ProductiveHoursUserStories PUS ON PUS.UserStoryId = USST.UserStoryId
		   JOIN [BoardType] BT ON BT.Id = G.BoardTypeId --AND BT.IsSuperAgile = 1 
		   JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
		   JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USST.WorkflowEligibleStatusTransitionId
		   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId
		              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
		   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
		              AND TUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
      WHERE CONVERT(DATE,USST.TransitionDateTime) BETWEEN @DateFrom AND @DateTo 
           AND (US.OwnerUserId = @UserId OR @UserId IS NULL)
      GROUP BY US.OwnerUserId,USST.UserStoryId

	  UPDATE @ProductiveIndexForDeveloper SET ReopenedUserStoresCount = ISNULL(PIDInner.ReopenedUserStoresCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (SELECT UserId, COUNT(DISTINCT UserStoryId) ReopenedUserStoresCount
                     FROM @BouncedUserStories
                     WHERE (UserId = @UserId OR @UserId IS NULL) 
					 AND ReopenCount >= 1
                     GROUP BY UserId) PIDInner ON PIDInner.UserId = PID.UserId

      UPDATE @ProductiveIndexForDeveloper SET UserStoriesBouncedBackOnceCount = ISNULL(PIDInner.UserStoriesBouncedBackOnceCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (SELECT UserId, COUNT(1) UserStoriesBouncedBackOnceCount
                      FROM @BouncedUserStories
                      WHERE (UserId = @UserId OR @UserId IS NULL)
                      AND ReopenCount = 1
                      GROUP BY UserId) PIDInner ON PIDInner.UserId = PID.UserId

      UPDATE @ProductiveIndexForDeveloper SET UserStoriesBouncedBackMoreThanOnceCount = ISNULL(PIDInner.UserStoriesBouncedBackMoreThanOnceCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (SELECT UserId, COUNT(1) UserStoriesBouncedBackMoreThanOnceCount
                      FROM @BouncedUserStories
                      WHERE (@UserId IS NULL OR UserId = @UserId)
                      AND ReopenCount > 1
                      GROUP BY UserId) PIDInner ON PIDInner.UserId = PID.UserId
	  
      UPDATE @ProductiveIndexForDeveloper SET UserStoryBouncedBackOnceCount = ISNULL(PIDInner.UserStoryBouncedBackOnceCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (SELECT UserId,UserStoryId, COUNT(1) UserStoryBouncedBackOnceCount
                      FROM @BouncedUserStories
                      WHERE (UserId = @UserId OR @UserId IS NULL)
                            AND ReopenCount = 1
                      GROUP BY UserId,UserStoryId) PIDInner ON PIDInner.UserId = PID.UserId AND PIDInner.UserStoryId = PID.UserStoryId
	  
      UPDATE @ProductiveIndexForDeveloper SET UserStoryBouncedBackMoreThanOnceCount = ISNULL(PIDInner.UserStoryBouncedBackMoreThanOnceCount,0)
      FROM @ProductiveIndexForDeveloper PID
      LEFT JOIN (SELECT UserId,UserStoryId, COUNT(1) UserStoryBouncedBackMoreThanOnceCount
				FROM @BouncedUserStories
				WHERE (@UserId IS NULL OR UserId = @UserId)
					AND ReopenCount > 1
				GROUP BY UserId,UserStoryId) PIDInner ON PIDInner.UserId = PID.UserId AND PIDInner.UserStoryId = PID.UserStoryId

UPDATE @ProductiveIndexForDeveloper
      SET GRPIndex = ISNULL(PIDInner.GRPIndex,0)
     FROM @ProductiveIndexForDeveloper PID
     LEFT JOIN (SELECT GoalResponsibleUserId, SUM(PUS.EstimatedTime) GRPIndex
                 FROM @ProductiveHoursUserStories PUS
                        INNER JOIN UserStory US ON US.Id = PUS.UserStoryId
                        INNER JOIN Goal G ON G.Id = US.GoalId AND G.GoalResponsibleUserId <> US.OwnerUserId
                        INNER JOIN Project P ON P.Id = G.ProjectId
					   INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
                      INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
                  WHERE ((CH.IsEsimatedHours = 1 OR CH.IsLoggedHours = 1))
                       AND (G.GoalResponsibleUserId = @UserId OR @UserId IS NULL)
                 GROUP BY GoalResponsibleUserId) PIDInner ON PIDInner.GoalResponsibleUserId = PID.UserId
				 
RETURN

END