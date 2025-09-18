
CREATE FUNCTION [dbo].[Ufn_GetEmployeeIndexOfAnEmployee]
(
	@DateFrom DATETIME,
	@DateTo DATETIME,
	@UserId  UNIQUEIDENTIFIER
)
RETURNS FLOAT
BEGIN
	  DECLARE @ProductiveIndexForDeveloper TABLE
	  (
	      UserId UNIQUEIDENTIFIER,
	      ProductivityIndex FLOAT,
	  	  UserStoryId UNIQUEIDENTIFIER,
	  	  GoalId UNIQUEIDENTIFIER,
	  	  GoalResponsibleUserId UNIQUEIDENTIFIER,
	      UserStoryReopenCount INT,
	  	  EmployeeIndex FLOAT
	  )

	  DECLARE @EstimatedHoursUserStories TABLE
      (
          UserId UNIQUEIDENTIFIER,
		  GoalResponsibleUserId UNIQUEIDENTIFIER,
          UserStoryId UNIQUEIDENTIFIER,
		  GoalId UNIQUEIDENTIFIER,
          EstimatedTime NUMERIC(10,2),
          TransitionDateTime DATETIME
      )
      
      INSERT INTO @EstimatedHoursUserStories(UserStoryId,UserId,TransitionDateTime,GoalResponsibleUserId,GoalId)
      SELECT US.Id,US.OwnerUserId,MAX(TransitionDateTime),GoalResponsibleUserId,GoalId
      FROM Goal G JOIN UserStory US ON US.GoalId = G.Id JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
	       JOIN [User] U ON U.Id = US.OwnerUserId
           --JOIN [Role] R ON R.Id = U.RoleId 
      WHERE BoardTypeId = '28009E1D-EB84-41F0-9541-E10F054FE6C1' AND G.GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE' AND UW.WorkflowEligibleStatusTransitionId = '3C252585-C15C-4812-A31C-AF2A1B306074' AND US.UserStoryStatusId = 'B3B17186-6D07-4416-878D-F78A73A753FC'
            AND CONVERT(DATE,TransitionDateTime) >= @DateFrom AND CONVERT(DATE,TransitionDateTime) <= @DateTo AND IsActive = 1  AND IsProductiveBoard = 1  AND ConsiderEstimatedHours = 1
      GROUP BY US.Id,US.OwnerUserId,EstimatedTime,GoalResponsibleUserId,GoalId

      UPDATE @EstimatedHoursUserStories SET EstimatedTime = US.EstimatedTime
      FROM UserStory US JOIN @EstimatedHoursUserStories EUS ON US.Id = EUS.UserStoryId

	  DECLARE @LoggedHoursUserStories TABLE
      (
          UserId UNIQUEIDENTIFIER,
		  GoalResponsibleUserId UNIQUEIDENTIFIER,
          UserStoryId UNIQUEIDENTIFIER,
		  GoalId UNIQUEIDENTIFIER,
          LoggedTime NUMERIC(10,2),
          TransitionDateTime DATETIME
      )

      INSERT INTO @LoggedHoursUserStories(UserStoryId,UserId,TransitionDateTime,GoalResponsibleUserId,GoalId)
      SELECT UserStoryId,US.OwnerUserId,MAX(TransitionDateTime),GoalResponsibleUserId,GoalId
      FROM UserStoryWorkflowStatusTransition UWT JOIN UserStory US ON US.Id = UWT.UserStoryId JOIN Goal G ON G.Id = US.GoalId JOIN [User] U ON U.Id = US.OwnerUserId
           --JOIN [Role] R ON R.Id = U.RoleId 
      WHERE  BoardTypeId = 'B2683875-8FF4-4826-877D-3119B776441E' AND G.GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE' AND UWT.WorkflowEligibleStatusTransitionId = 'DD9DB945-A190-43CB-AD43-0D01D0776884' AND US.UserStoryStatusId = '7503DACE-D75A-4DF1-B687-64334263B908'
            AND CONVERT(DATE,DeadLineDate) >= @DateFrom AND CONVERT(DATE,DeadLineDate) <= @DateTo AND IsActive = 1 AND IsProductiveBoard = 1  AND ConsiderEstimatedHours = 0
      GROUP BY UserStoryId,US.OwnerUserId,GoalResponsibleUserId,GoalId

      UPDATE @LoggedHoursUserStories SET LoggedTime = LUSInner.LoggedTime
      FROM @LoggedHoursUserStories LUS
           JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin) LoggedTime
                 FROM UserStorySpentTime UST JOIN @LoggedHoursUserStories LUS ON LUS.UserStoryId = UST.UserStoryId
                 GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = LUS.UserStoryId

	DECLARE @EstimatedHoursUserStoriesWithKanban TABLE
      (
          UserId UNIQUEIDENTIFIER,
		  GoalResponsibleUserId UNIQUEIDENTIFIER,
          UserStoryId UNIQUEIDENTIFIER,
		  GoalId UNIQUEIDENTIFIER,
          EstimatedTime NUMERIC(10,2),
          TransitionDateTime DATETIME
      )

      INSERT INTO @EstimatedHoursUserStoriesWithKanban(UserStoryId,UserId,TransitionDateTime,GoalResponsibleUserId,GoalId)
      SELECT UserStoryId,US.OwnerUserId,MAX(TransitionDateTime),GoalResponsibleUserId,GoalId
      FROM UserStoryWorkflowStatusTransition UWT JOIN UserStory US ON US.Id = UWT.UserStoryId JOIN Goal G ON G.Id = US.GoalId JOIN [User] U ON U.Id = US.OwnerUserId
           --JOIN [Role] R ON R.Id = U.RoleId 
      WHERE  BoardTypeId = 'B2683875-8FF4-4826-877D-3119B776441E' AND G.GoalStatusId = '7A79AB9F-D6F0-40A0-A191-CED6C06656DE' AND UWT.WorkflowEligibleStatusTransitionId = 'DD9DB945-A190-43CB-AD43-0D01D0776884' AND US.UserStoryStatusId = '7503DACE-D75A-4DF1-B687-64334263B908'
            AND CONVERT(DATE,DeadLineDate) >= @DateFrom AND CONVERT(DATE,DeadLineDate) <= @DateTo AND IsActive = 1 AND IsProductiveBoard = 1  AND ConsiderEstimatedHours = 1
      GROUP BY UserStoryId,US.OwnerUserId,GoalResponsibleUserId,GoalId

	  UPDATE @EstimatedHoursUserStoriesWithKanban SET EstimatedTime = US.EstimatedTime
      FROM UserStory US JOIN @EstimatedHoursUserStoriesWithKanban EUSK ON US.Id = EUSK.UserStoryId

    DECLARE @ProductiveIndex TABLE
      (
          UserId UNIQUEIDENTIFIER,
		  GoalResponsibleUserId UNIQUEIDENTIFIER,
		  GoalId UNIQUEIDENTIFIER,
          UserStoryId UNIQUEIDENTIFIER,
          ProductivityIndex NUMERIC(10,2)
      )

      INSERT INTO @ProductiveIndex(UserId,UserStoryId,ProductivityIndex,GoalResponsibleUserId,GoalId)
      SELECT UserId,UserStoryId,SUM(EstimatedTime),GoalResponsibleUserId,GoalId
      FROM @EstimatedHoursUserStories
      GROUP BY UserId,UserStoryId,GoalResponsibleUserId,GoalId
      UNION ALL
      SELECT UserId,UserStoryId,SUM(LoggedTime),GoalResponsibleUserId,GoalId
      FROM @LoggedHoursUserStories
      GROUP BY UserId,UserStoryId,GoalResponsibleUserId,GoalId
	  UNION ALL
      SELECT UserId,UserStoryId,SUM(EstimatedTime),GoalResponsibleUserId,GoalId
      FROM @EstimatedHoursUserStoriesWithKanban
      GROUP BY UserId,UserStoryId,GoalResponsibleUserId,GoalId
      
      INSERT INTO @ProductiveIndexForDeveloper(UserId,GoalId,UserStoryId,ProductivityIndex,EmployeeIndex,GoalResponsibleUserId)
      SELECT U.Id,US.GoalId,UserStoryId,ISNULL(SUM(ProductivityIndex),0),ISNULL(SUM(ProductivityIndex),0),GoalResponsibleUserId
      FROM [User] U 
	       --LEFT JOIN [Role] R ON R.Id = U.RoleId
           LEFT JOIN @ProductiveIndex PIX ON PIX.UserId = U.Id
		   JOIN UserStory US ON US.Id = PIX.UserStoryId
      WHERE IsActive = 1
        AND (@UserId IS NULL OR U.Id = @UserId)
      GROUP BY U.Id,US.GoalId,UserStoryId,GoalResponsibleUserId

    DECLARE @BouncedUserStories TABLE
      (
         UserId UNIQUEIDENTIFIER,
         UserStoryId UNIQUEIDENTIFIER,
         ReopenCount INT
      )

      INSERT INTO @BouncedUserStories(UserId,UserStoryId,ReopenCount)
      SELECT US.OwnerUserId,USST.UserStoryId, COUNT(1) ReopenCount
      FROM UserStoryWorkflowStatusTransition USST JOIN UserStory US ON US.Id = USST.UserStoryId JOIN @EstimatedHoursUserStories EUS ON EUS.UserStoryId = USST.UserStoryId
      WHERE CONVERT(DATE,USST.TransitionDateTime) >= @DateFrom AND CONVERT(DATE,USST.TransitionDateTime) <= @DateTo AND (US.OwnerUserId = @UserId OR @UserId IS NULL)
            AND WorkflowEligibleStatusTransitionId = 'B278B9E6-7214-4239-81D8-9D5CB048DE34'
            AND (US.OwnerUserId = @UserId OR @UserId IS NULL)
      GROUP BY US.OwnerUserId,USST.UserStoryId

      UPDATE @ProductiveIndexForDeveloper SET UserStoryReopenCount = ISNULL(BU.ReopenCount,0)
      FROM @ProductiveIndexForDeveloper PID LEFT JOIN @BouncedUserStories BU ON BU.UserStoryId = PID.UserStoryId

	  UPDATE @ProductiveIndexForDeveloper SET EmployeeIndex = CASE WHEN UserStoryReopenCount = 3 THEN 0.05 * EmployeeIndex
	                                                               WHEN UserStoryReopenCount BETWEEN 4 AND 6 THEN 0.5 * EmployeeIndex
																   WHEN UserStoryReopenCount > 6 THEN 0
																   ELSE EmployeeIndex END

	DECLARE @ProductivityIndex FLOAT

	SELECT @ProductivityIndex = SUM(EmployeeIndex) FROM @ProductiveIndexForDeveloper

	RETURN @ProductivityIndex

END