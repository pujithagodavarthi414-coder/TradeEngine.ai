CREATE PROCEDURE [dbo].[USP_ProduceProductivityIndex]
(
   @StartDate DATE = NULL,
   @EndDate DATE = NULL,
   @CompanyIds NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @PreviousDate DATETIME = DATEADD(DAY,-1,GETDATE())

	IF(@StartDate IS NULL AND @EndDate IS NULL) SELECT @StartDate = DATEADD(DAY,-30,@PreviousDate), @EndDate = @PreviousDate

	DECLARE @DateFrom DATE, @DateTo DATE

	CREATE TABLE #CompanyIds
	(
		Id INT IDENTITY(1,1),
		CompanyId UNIQUEIDENTIFIER
	)

	INSERT INTO #CompanyIds
	SELECT Id FROM Company WHERE InActiveDateTime IS NULL AND (@CompanyIds IS NULL OR (Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@CompanyIds))))

	CREATE TABLE #ProductiveHours 
	(
		UserId UNIQUEIDENTIFIER,
		UserStoryId UNIQUEIDENTIFIER,
		EstimatedTime NUMERIC(10,2),
		GoalId UNIQUEIDENTIFIER,
		ProjectId UNIQUEIDENTIFIER,
		IsEsimatedHours BIT,
		IsLoggedHours BIT,
		UserStoryReplanCount NUMERIC(10,2),
		GRPIndex FLOAT,
		ReopenedCount INT,
		CompletedUserStoresCountByUserId INT,
		QAApprovedUserStoriesCountByUserId INT,
		ReopenedUserStoresCountByUserId INT,
		UserStoriesBouncedBackOnceCountByUserId INT,
		UserStoriesBouncedBackMoreThanOnceCountByUserId INT,
		ISForQA INT
	)
	
	CREATE TABLE #ActvityTrackerProductivity
	(
		UserId UNIQUEIDENTIFIER,
		ProductiveTime FLOAT
	)

	CREATE TABLE #SpentTime
	(
		UserId UNIQUEIDENTIFIER,
		SpenTime FLOAT
	)
	
	CREATE TABLE #FinalProductHours
	(
		UserId UNIQUEIDENTIFIER,
		ProjectId UNIQUEIDENTIFIER,
		UserProjectKey NVARCHAR(100),
		ProductivityIndex FLOAT,
		AvgActivityTrackerProductivity FLOAT,
		AvgSpentTime FLOAT,
		GRPIndex FLOAT,
		ReopenedUserStoresCount INT,
		PercentageOfBouncedUserStories FLOAT,
		UserStoriesBouncedBackOnceCount INT,
		UserStoriesBouncedBackMoreThanOnceCount INT,
		AvgReplan FLOAT,
		PercentageOfQAApprovedUserStories FLOAT,
		CompletedUserStoriesCount INT,
		UserStoryId UNIQUEIDENTIFIER
	)

	DECLARE @CompanyIdsCount INT, @CompanyIdsCounter INT = 1, @CompanyId UNIQUEIDENTIFIER

	SELECT @CompanyIdsCount = COUNT(1) FROM #CompanyIds

	WHILE(@CompanyIdsCounter <= @CompanyIdsCount)
	BEGIN

		SELECT @CompanyId = CompanyId FROM #CompanyIds WHERE Id = @CompanyIdsCounter

		SELECT @DateFrom = @StartDate, @DateTo = @StartDate

		WHILE(@DateFrom <= @EndDate)
		BEGIN

			TRUNCATE TABLE #ProductiveHours
			TRUNCATE TABLE #ActvityTrackerProductivity
			TRUNCATE TABLE #SPentTime

			INSERT INTO #ProductiveHours(UserStoryId,UserId,GoalId,ProjectId,IsLoggedHours,IsEsimatedHours,ISForQA)
			SELECT US.Id,US.OwnerUserId,GoalId,G.ProjectId,CH.IsLoggedHours,CH.IsEsimatedHours,CASE WHEN ISForQA IS NULL OR ISForQA = 0 THEN 1 ELSE 0 END 
			FROM Goal G 
			     INNER JOIN UserStory US ON US.GoalId = G.Id
			     INNER JOIN (SELECT US.Id,MAX(USWFT.TransitionDateTime) AS DeadLine
			                 FROM UserStory US 
			                      INNER JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
			                      INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
								  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
								  INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
			                      INNER JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
			                      INNER JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
							 GROUP BY US.Id) UW ON US.Id = UW.Id
			     INNER JOIN [User] U ON U.Id = US.OwnerUserId
			     INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
			     INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
			     INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
			     INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
			     LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
			WHERE (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
				   AND (TS.TaskStatusName IN (N'Done',N'Verification completed'))
				   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,@DateFrom) 
			       AND CONVERT(DATE,UW.DeadLine) <= CONVERT(DATE,@DateTo) 
			       AND U.IsActive = 1 
				   AND U.CompanyId = @CompanyId
			       AND IsProductiveBoard = 1  
			       AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
			GROUP BY US.Id,US.OwnerUserId,GoalId,G.ProjectId,CH.IsLoggedHours,CH.IsEsimatedHours,ISForQA
			
			INSERT INTO #ProductiveHours(UserStoryId,UserId,GoalId,ProjectId,IsEsimatedHours,ISForQA)
			SELECT US.Id,US.OwnerUserId,NULL,S.ProjectId,1,CASE WHEN ISForQA IS NULL OR ISForQA = 0 THEN 1 ELSE 0 END
			FROM Sprints S 
			     INNER JOIN UserStory US ON US.SprintId = S.Id
			     INNER JOIN (SELECT US.Id,MAX(USWFT.TransitionDateTime) AS DeadLine
			                 FROM UserStory US 
			                      INNER JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
			                      INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
								  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
								  INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
			                      INNER JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
			                      INNER JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
							 GROUP BY US.Id) UW ON US.Id = UW.Id
			     INNER JOIN [User] U ON U.Id = US.OwnerUserId
			     INNER JOIN [BoardType] BT ON BT.Id = S.BoardTypeId
			     INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
			     INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
			     LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
			WHERE  (TS.TaskStatusName IN (N'Done',N'Verification completed')) 
				   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,@DateFrom) 
			       AND CONVERT(DATE,UW.DeadLine) <= CONVERT(DATE,@DateTo) 
			       AND U.IsActive = 1 
				   AND U.CompanyId = @CompanyId
				   AND (US.Id NOT IN (SELECT P.UserStoryId FROM #ProductiveHours P))
			GROUP BY US.Id,US.OwnerUserId,ISForQA,S.ProjectId
			
			UPDATE #ProductiveHours SET EstimatedTime = US.EstimatedTime
			FROM UserStory US INNER JOIN #ProductiveHours PUS ON US.Id = PUS.UserStoryId WHERE IsEsimatedHours = 1
			      
			UPDATE #ProductiveHours SET EstimatedTime = LUSInner.LoggedTime
			FROM #ProductiveHours PUS
			     INNER JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.0) LoggedTime
			                 FROM UserStorySpentTime UST 
			                      INNER JOIN #ProductiveHours PUS ON PUS.UserStoryId = UST.UserStoryId AND UST.CreatedbyUserId = PUS.UserId
			                 WHERE IsLoggedHours = 1
			                 GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId
			
			UPDATE #ProductiveHours SET ReopenedCount = PHInner.ReopenedCount
			FROM #ProductiveHours PH
			     LEFT JOIN (SELECT COUNT(UW.UserStoryId) ReopenedCount,UW.UserStoryId FROM #ProductiveHours PH 
			     INNER JOIN UserStoryWorkflowStatusTransition UW ON PH.UserStoryId = UW.UserStoryId 
			     INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
			     INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
			                AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
			     INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
			                AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
			GROUP BY UW.UserStoryId) PHInner ON PH.UserStoryId = PHInner.UserStoryId 
			
			UPDATE #ProductiveHours SET CompletedUserStoresCountByUserId = CompletedUserStorycount,
			                            QAApprovedUserStoriesCountByUserId = QAApprovedUserStories,
			                            ReopenedUserStoresCountByUserId = ISNULL(ReopenedUserStoresCount,0),
			                            UserStoriesBouncedBackOnceCountByUserId = UserStoriesBouncedBackOnceCount,
			                            UserStoriesBouncedBackMoreThanOnceCountByUserId = ISNULL(ReopenedUserStoresCount,0) - UserStoriesBouncedBackOnceCount
			FROM #ProductiveHours PH
			     INNER JOIN (SELECT UserId,ProjectId,
			                        COUNT(UserId) CompletedUserStorycount,
			                        SUM(ISForQA) AS QAApprovedUserStories,
								    COUNT(CASE WHEN ReopenedCount > 0 THEN 1 ELSE NULL END) AS ReopenedUserStoresCount,
								    COUNT(CASE WHEN ReopenedCount = 1 THEN 1 ELSE NULL END) AS UserStoriesBouncedBackOnceCount
			                 FROM #ProductiveHours
			                 GROUP BY UserId,ProjectId) PHInner ON PHInner.UserId = PH.UserId AND PHInner.ProjectId = PH.ProjectId
				  
			UPDATE #ProductiveHours SET UserStoryReplanCount = ISNULL(ReplanCount,0)
			FROM #ProductiveHours PH
			     INNER JOIN (SELECT COUNT(USR.UserStoryId) AS ReplanCount,USR.UserStoryId
			                 FROM #ProductiveHours PH
			                      LEFT JOIN UserStoryReplan USR ON USR.UserStoryId = PH.UserStoryId
			                 GROUP BY USR.UserStoryId) PHInner ON PHInner.UserStoryId = PH.UserStoryId 
							  
			INSERT INTO #ProductiveHours(UserId)
			SELECT U.Id 
			FROM [User] U  
			WHERE U.InactiveDateTime IS NULL AND U.IsActive = 1 AND NOT EXISTS(SELECT 1 FROM #ProductiveHours WHERE UserId = U.Id)
			      AND CompanyId = @CompanyId

			UPDATE #ProductiveHours SET GRPIndex = ISNULL(PIDInner.GRPIndex,0)
			FROM #ProductiveHours PID
			     LEFT JOIN (SELECT GoalResponsibleUserId, SUM(PUS.EstimatedTime) GRPIndex
			                FROM #ProductiveHours PUS
			                     INNER JOIN Goal G ON G.Id = PUS.GoalId AND G.GoalResponsibleUserId <> PUS.UserId
			                GROUP BY GoalResponsibleUserId) PIDInner ON PIDInner.GoalResponsibleUserId = PID.UserId
			
			INSERT INTO #ActvityTrackerProductivity
			SELECT UserId, AVG(DATEPART(HOUR,TotalTime) + ROUND((DATEPART(MINUTE,TotalTime)/60.0),1)) ProductiveTime
			FROM (
				SELECT UM.Id UserId, CAST( UA.CreatedDateTime AS date)[Date],
				       Productive AS TotalTime 
				FROM [User] AS UM WITH (NOLOCK) 
					 INNER JOIN UserActivityTimeSummary AS UA WITH (NOLOCK) ON  UM.Id = UA.UserId 
					 		   AND ( UA.CreatedDateTime BETWEEN @DateFrom AND @DateTo )
				WHERE UA.CreatedDateTime BETWEEN @DateFrom AND @DateTo 
					  AND UM.CompanyId = @CompanyId
				
			) T
			GROUP BY UserId

			INSERT INTO #SpentTime
			SELECT UserId, ROUND(AVG(TotalTimeSpent)/60.0,2) SpenTime
			FROM (
			SELECT TS.[UserId],
			       TS.[Date], 
			       (ISNULL(DATEDIFF(MINUTE,InTime, OutTime),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(UB.BreakTime,0)) TotalTimeSpent
			FROM [User] U WITH (NOLOCK) 
			      INNER JOIN [Employee] E ON E.UserId = U.Id
			      INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
			                 AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
			      JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id AND U.InactiveDateTime IS NULL AND TS.UserId NOT IN (SELECT UserId FROM LeaveApplication LA
			      JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId 
				  JOIN LeaveStatus LST ON LST.IsApproved = 1 AND LA.OverallLeaveStatusId = LST.Id 
			      WHERE TS.[Date] BETWEEN LeaveDateFrom AND LeaveDateTo AND IsOnSite = 0 AND IsWorkFromHome = 0 AND LA.InActiveDateTime IS NULL) 
			            AND Ts.InActiveDateTime IS NULL
			      LEFT JOIN (SELECT U.Id
			                        ,UB.[Date]
			                        ,ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn, UB.BreakOut)),0) AS BreakTime 
			                        FROM [User] U 
			                        LEFT JOIN UserBreak UB ON UB.UserId = U.Id AND U.InActiveDateTime IS NULL 
			                                              AND U.CompanyId = @CompanyId AND CONVERT(DATE,UB.[Date]) BETWEEN @DateFrom AND @DateTo
			                        GROUP BY U.Id,UB.[Date]) UB ON UB.Id = TS.UserId AND (UB.[Date] = TS.[Date]) 
			 WHERE ((CONVERT(DATE,TS.[Date]) BETWEEN @DateFrom AND @DateTo)
			        OR (CONVERT(DATE,UB.[Date]) BETWEEN @DateFrom AND @DateTo))
			        AND (CompanyId = @CompanyId)

			)T
			GROUP BY UserId

			TRUNCATE TABLE #FinalProductHours

			INSERT INTO #FinalProductHours
			SELECT UserId
			       ,ProjectId
				   ,NULL UserProjectKey
				   --,CAST(UserId AS NVARCHAR(50)) + '-' + CAST(ProjectId AS NVARCHAR(50)) UserProjectKey
				   ,ProductivityIndex
				   ,AvgActivityTrackerProductivity
				   ,AvgSpentTime
				   ,GRPIndex
				   ,ReopenedUserStoresCount
				   ,PercentageOfBouncedUserStories
				   ,UserStoriesBouncedBackOnceCount
				   ,UserStoriesBouncedBackMoreThanOnceCount
				   ,AvgReplan
				   ,PercentageOfQAApprovedUserStories
				   ,CompletedUserStoriesCount
				   ,UserStoryId
			FROM (
			SELECT PID.UserId,
			       PID.ProjectId,
			       SUM(PID.EstimatedTime) ProductivityIndex,
				   ATP.ProductiveTime AvgActivityTrackerProductivity,
				   ST.SpenTime AvgSpentTime,
			       PID.GRPIndex,
			       PID.CompletedUserStoresCountByUserId AS CompletedUserStoriesCount,
			       PID.ReopenedUserStoresCountByUserId AS ReopenedUserStoresCount,
			       CAST((CASE WHEN CompletedUserStoresCountByUserId = 0 THEN 0 ELSE (PID.ReopenedUserStoresCountByUserId*1.0/CompletedUserStoresCountByUserId*1.0)*100  END) AS NUMERIC(10,2)) PercentageOfBouncedUserStories,
			       UserStoriesBouncedBackOnceCountByUserId UserStoriesBouncedBackOnceCount,
			       UserStoriesBouncedBackMoreThanOnceCountByUserId UserStoriesBouncedBackMoreThanOnceCount,
			       CAST((SUM(UserStoryReplanCount))*1.00 AS NUMERIC(10,2)) AvgReplan,
			       CAST((CASE WHEN CompletedUserStoresCountByUserId = 0 THEN 0 ELSE (PID.QAApprovedUserStoriesCountByUserId*1.0/CompletedUserStoresCountByUserId*1.0)*100 END) AS NUMERIC(10,2)) PercentageOfQAApprovedUserStories
				   ,PID.UserStoryId
			FROM  [dbo].#ProductiveHours PID
				 INNER JOIN [Employee] E ON E.UserId = PID.UserId
				 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
				 	        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 LEFT JOIN #ActvityTrackerProductivity ATP ON ATP.UserId = PID.UserId
				 LEFT JOIN #SpentTime ST ON ST.UserId = PID.UserId 
			GROUP BY PID.UserId,PID.ProjectId,GRPIndex,CompletedUserStoresCountByUserId,UserStoriesBouncedBackOnceCountByUserId,PID.ReopenedUserStoresCountByUserId,
			         UserStoriesBouncedBackMoreThanOnceCountByUserId,QAApprovedUserStoriesCountByUserId,ATP.ProductiveTime,ST.SpenTime
					 ,PID.UserStoryId
			  ) T

			SELECT @DateFrom = DATEADD(DAY,1,@DateFrom), @DateTo = DATEADD(DAY,1,@DateTo)

			DELETE FROM ProductivityIndex WHERE CompanyId = @CompanyId AND [Date] = @DateFrom

			INSERT INTO ProductivityIndex(UserId,[CompanyId],ProjectId,UserStoryId,UserProjectKey,ProductivityIndex,AvgActivityTrackerProductivity,
                                          AvgSpentTime,GRPIndex,ReopenedUserStoresCount,PercentageOfBouncedUserStories,UserStoriesBouncedBackOnceCount,
                                          UserStoriesBouncedBackMoreThanOnceCount,AvgReplan,PercentageOfQAApprovedUserStories,
                                          CompletedUserStoriesCount,[Date],CreatedDateTime)
			SELECT UserId,@CompanyId,ProjectId,UserStoryId,UserProjectKey,ProductivityIndex,AvgActivityTrackerProductivity,
                   AvgSpentTime,GRPIndex,ReopenedUserStoresCount,PercentageOfBouncedUserStories,UserStoriesBouncedBackOnceCount,
                   UserStoriesBouncedBackMoreThanOnceCount,AvgReplan,PercentageOfQAApprovedUserStories,
                   CompletedUserStoriesCount,@DateFrom,GETDATE()
			FROM #FinalProductHours

		END

		SELECT @CompanyIdsCounter = @CompanyIdsCounter + 1
			 
	END

	END TRY 
	BEGIN CATCH 
	
		 THROW

	END CATCH

END
