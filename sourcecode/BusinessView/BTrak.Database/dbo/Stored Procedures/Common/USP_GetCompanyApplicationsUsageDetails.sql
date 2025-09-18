CREATE PROCEDURE USP_GetCompanyApplicationsUsageDetails
(
	@CompanyId UNIQUEIDENTIFIER = NULl
)
AS
BEGIN

	CREATE TABLE #Companies
	(
		Id INT IDENTITY(1,1),
		CompanyId UNIQUEIDENTIFIER,
		CompanyName NVARCHAR(MAX)
	)

	INSERT INTO #Companies
	SELECT Id, CompanyName FROM Company WHERE Id = @CompanyId OR @CompanyId IS NULL

	--SELECT * FROM #Companies

	CREATE TABLE #CompanyFeatures
	(
		Id INT IDENTITY(1,1),
		CompanyId UNIQUEIDENTIFIER,
		CompanyName NVARCHAR(MAX),
		Feature NVARCHAR(250),
		TodayUsage INT,
		ThisMonthUsage INT,
		OverallUsage INT
	)

	CREATE TABLE #Productivity
	(
		UserStoryId UNIQUEIDENTIFIER,
		Deadline DATETIME,
		IsEsimatedHours BIT,
		IsLoggedHours BIT,
		ProductivityIndex FLOAT
	)

	DECLARE @CompaniesCounter INT = 1, @CompaniesCount INT, @CurrentMonthStartDate DATE, @CurrentDate DATE = CAST(GETDATE() AS DATE),
	        @TodayUsage INT = 0, @ThisMonthUsage INT = 0, @OverallUsage INT = 0, @UsageCompanyId UNIQUEIDENTIFIER, @CompanyName NVARCHAR(MAX)

	SELECT @CompaniesCount = COUNT(1) FROM #Companies

	SELECT @CurrentMonthStartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0)

	WHILE(@CompaniesCounter <= @CompaniesCount)
	BEGIN

		SELECT @UsageCompanyId = CompanyId, @CompanyName = CompanyName FROM #Companies WHERE Id = @CompaniesCounter

		SELECT @TodayUsage = COUNT(1) FROM Employee E INNER JOIN [User] U ON E.UserId = U.Id 
		WHERE /*E.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(E.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM Employee E INNER JOIN [User] U ON E.UserId = U.Id 
		WHERE /*E.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(E.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM Employee E INNER JOIN [User] U ON E.UserId = U.Id 
		WHERE /*E.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Employees',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM EmployeeDetailsHistory EDH INNER JOIN Employee E ON EDH.EmployeeId = E.Id INNER JOIN [User] U ON E.UserId = U.Id 
		WHERE /*E.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(EDH.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM EmployeeDetailsHistory EDH INNER JOIN Employee E ON EDH.EmployeeId = E.Id INNER JOIN [User] U ON E.UserId = U.Id 
		WHERE /*E.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(EDH.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM EmployeeDetailsHistory EDH INNER JOIN Employee E ON EDH.EmployeeId = E.Id INNER JOIN [User] U ON E.UserId = U.Id 
		WHERE /*E.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'HR profile updates',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM PayrollRun
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM PayrollRun
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM PayrollRun
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Payroll runs',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM ActivityScreenShot ASS INNER JOIN [User] U ON U.Id = ASS.UserId
		WHERE /*ASS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(ASS.ScreenShotDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM ActivityScreenShot ASS INNER JOIN [User] U ON U.Id = ASS.UserId
		WHERE /*ASS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(ASS.ScreenShotDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM ActivityScreenShot ASS INNER JOIN [User] U ON U.Id = ASS.UserId
		WHERE /*ASS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Screenshots',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(DISTINCT UserId) FROM [ActivityTrackerStatus] ATS INNER JOIN [User] U ON U.Id = ATS.UserId
		WHERE /*U.InActiveDateTime IS NULL
			  AND*/ ATS.ActivityTrackerStartTime IS NOT NULL
			  AND U.CompanyId = @UsageCompanyId
			  AND CAST(ATS.[Date] AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(DISTINCT UserId) FROM [ActivityTrackerStatus] ATS INNER JOIN [User] U ON U.Id = ATS.UserId
		WHERE /*U.InActiveDateTime IS NULL
			  AND*/ ATS.ActivityTrackerStartTime IS NOT NULL
			  AND U.CompanyId = @UsageCompanyId
			  AND CAST(ATS.[Date] AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(DISTINCT UserId) FROM [ActivityTrackerStatus] ATS INNER JOIN [User] U ON U.Id = ATS.UserId
		WHERE /*U.InActiveDateTime IS NULL
			  AND*/ ATS.ActivityTrackerStartTime IS NOT NULL
			  AND U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of employees tracked',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = ISNULL(SUM(SpentTimeInMin),0) FROM UserStorySpentTime UST INNER JOIN [User] U ON UST.UserId = U.Id 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(UST.DateFrom AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = ISNULL(SUM(SpentTimeInMin),0) FROM UserStorySpentTime UST INNER JOIN [User] U ON UST.UserId = U.Id 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(UST.DateFrom AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = ISNULL(SUM(SpentTimeInMin),0) FROM UserStorySpentTime UST INNER JOIN [User] U ON UST.UserId = U.Id 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Total time logged',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1)
		FROM UserstoryWorkflowStatusTransition UST
		     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
			 INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId 
			 INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UST.WorkflowEligibleStatusTransitionId
			 INNER JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId
			 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		WHERE /*UST.InActiveDateTime IS NULL
			  AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ TS.TaskStatusName IN ('Pending verification','Done')
			  AND P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @TodayUsage = ISNULL(@TodayUsage,0)+ ISNULL(COUNT(1),0)
		FROM UserstoryWorkflowStatusTransition UST
		     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
			 INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId 
			 INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UST.WorkflowEligibleStatusTransitionId
			 INNER JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId
			 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		WHERE /*UST.InActiveDateTime IS NULL
			  AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ TS.TaskStatusName IN ('Pending verification','Done')
			  AND P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE)  = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1)
		FROM UserstoryWorkflowStatusTransition UST
		     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
			 INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId 
			 INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UST.WorkflowEligibleStatusTransitionId
			 INNER JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId
			 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		WHERE /*UST.InActiveDateTime IS NULL
			  AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ TS.TaskStatusName IN ('Pending verification','Done')
			  AND P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @ThisMonthUsage = ISNULL(@ThisMonthUsage,0)+ ISNULL(COUNT(1),0)
		FROM UserstoryWorkflowStatusTransition UST
		     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
			 INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId 
			 INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UST.WorkflowEligibleStatusTransitionId
			 INNER JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId
			 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		WHERE /*UST.InActiveDateTime IS NULL
			  AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ TS.TaskStatusName IN ('Pending verification','Done')
			  AND P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1)
		FROM UserstoryWorkflowStatusTransition UST
		     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
			 INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId 
			 INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UST.WorkflowEligibleStatusTransitionId
			 INNER JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId
			 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		WHERE /*UST.InActiveDateTime IS NULL
			  AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ TS.TaskStatusName IN ('Pending verification','Done')
			  AND P.CompanyId = @UsageCompanyId
		 
		SELECT @OverallUsage = ISNULL(@OverallUsage,0)+ ISNULL(COUNT(1),0)
		FROM UserstoryWorkflowStatusTransition UST
		     INNER JOIN UserStory US ON US.Id = UST.UserStoryId
			 INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId 
			 INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UST.WorkflowEligibleStatusTransitionId
			 INNER JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId
			 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		WHERE /*UST.InActiveDateTime IS NULL
			  AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ TS.TaskStatusName IN ('Pending verification','Done')
			  AND P.CompanyId = @UsageCompanyId
		     
		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of tasks completed',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM UserStory US
		     INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(US.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @TodayUsage = ISNULL(@TodayUsage,0) + ISNULL(COUNT(1) ,0)
		FROM UserStory US
		     INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*US.InActiveDateTime IS NULL
			  AND S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(US.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM UserStory US
		     INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(US.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @ThisMonthUsage = ISNULL(@ThisMonthUsage,0) + ISNULL(COUNT(1) ,0)
		FROM UserStory US
		     INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*US.InActiveDateTime IS NULL
			  AND S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(US.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM UserStory US
		     INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId

		SELECT @OverallUsage = ISNULL(@OverallUsage,0) + ISNULL(COUNT(1) ,0)
		FROM UserStory US
		     INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*US.InActiveDateTime IS NULL
			  AND S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of new tasks created',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM UserstoryWorkflowStatusTransition UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		     INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @TodayUsage = ISNULL(@TodayUsage,0) + ISNULL(COUNT(1),0)
		FROM UserstoryWorkflowStatusTransition UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		     INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND US.InActiveDateTime IS NULL
			  AND S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM UserstoryWorkflowStatusTransition UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		     INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @ThisMonthUsage = ISNULL(@ThisMonthUsage,0) + ISNULL(COUNT(1),0)
		FROM UserstoryWorkflowStatusTransition UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		     INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND US.InActiveDateTime IS NULL
			  AND S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(UST.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM UserstoryWorkflowStatusTransition UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		     INNER JOIN Goal G ON G.Id = US.GoalId INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND US.InActiveDateTime IS NULL
			  AND G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId

		SELECT @OverallUsage = ISNULL(@OverallUsage,0) + ISNULL(COUNT(1),0)
		FROM UserstoryWorkflowStatusTransition UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		     INNER JOIN Sprints S ON S.Id = US.SprintId INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*UST.InActiveDateTime IS NULL
		      AND US.InActiveDateTime IS NULL
			  AND S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of status transtitions',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM Project                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM Project                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM Project                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Projects created',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM Goal G INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(G.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM Goal G INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(G.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM Goal G INNER JOIN Project P ON P.Id = G.ProjectId                 
		WHERE /*G.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Goals created',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM Sprints S INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(S.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM Sprints S INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId
			  AND CAST(S.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM Sprints S INNER JOIN Project P ON P.Id = S.ProjectId                 
		WHERE /*S.InActiveDateTime IS NULL
			  AND P.InActiveDateTime IS NULL
			  AND*/ P.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Sprints created',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM RecentSearch RS INNER JOIN [User] U ON U.Id = RS.CreatedByUserId
		WHERE /*RS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(RS.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM RecentSearch RS INNER JOIN [User] U ON U.Id = RS.CreatedByUserId
		WHERE /*RS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(RS.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM RecentSearch RS INNER JOIN [User] U ON U.Id = RS.CreatedByUserId
		WHERE /*RS.InActiveDateTime IS NULL
		      AND*/ U.InActiveDateTime IS NULL
			  AND U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number apps opened',@TodayUsage,@ThisMonthUsage,@OverallUsage

		--SELECT @TodayUsage = COUNT(1) 
		--FROM [User]                
		--WHERE /*InActiveDateTime IS NULL
		--	  AND*/ CompanyId = @UsageCompanyId
		--	  AND CAST(CreatedDateTime AS DATE) = @CurrentDate

		--SELECT @ThisMonthUsage = COUNT(1) 
		--FROM [User]                
		--WHERE /*InActiveDateTime IS NULL
		--	  AND*/ CompanyId = @UsageCompanyId
		--	  AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		--SELECT @OverallUsage = COUNT(1) 
		--FROM [User]                
		--WHERE /*InActiveDateTime IS NULL
		--	  AND*/ CompanyId = @UsageCompanyId

		--INSERT INTO #CompanyFeatures
		--SELECT @UsageCompanyId,@CompanyName,'Number of new logins',@TodayUsage,@ThisMonthUsage,@OverallUsage

		--SELECT @TodayUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = '2013D9B9-FB24-409B-B9D0-F98E148A9C98'
		--	  AND U.CompanyId = @UsageCompanyId
		--	  AND CAST(UFA.CreatedDateTime AS DATE) = @CurrentDate

		--SELECT @ThisMonthUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = '2013D9B9-FB24-409B-B9D0-F98E148A9C98'
		--	  AND U.CompanyId = @UsageCompanyId
		--	  AND CAST(UFA.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		--SELECT @OverallUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = '2013D9B9-FB24-409B-B9D0-F98E148A9C98'
		--	  AND U.CompanyId = @UsageCompanyId

		--INSERT INTO #CompanyFeatures
		--SELECT @UsageCompanyId,@CompanyName,'Number of google logins',@TodayUsage,@ThisMonthUsage,@OverallUsage

		--SELECT @TodayUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = '79877197-3428-412B-8CBF-F9944AA16DE2'
		--	  AND U.CompanyId = @UsageCompanyId
		--	  AND CAST(UFA.CreatedDateTime AS DATE) = @CurrentDate

		--SELECT @ThisMonthUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = '79877197-3428-412B-8CBF-F9944AA16DE2'
		--	  AND U.CompanyId = @UsageCompanyId
		--	  AND CAST(UFA.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		--SELECT @OverallUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = '79877197-3428-412B-8CBF-F9944AA16DE2'
		--	  AND U.CompanyId = @UsageCompanyId

		--INSERT INTO #CompanyFeatures
		--SELECT @UsageCompanyId,@CompanyName,'Number of change passwords',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM ResetPassword RP INNER JOIN [User] U ON RP.UserId = U.Id 
		WHERE /*U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(RP.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM ResetPassword RP INNER JOIN [User] U ON RP.UserId = U.Id 
		WHERE /*U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(RP.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM ResetPassword RP INNER JOIN [User] U ON RP.UserId = U.Id 
		WHERE /*U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of reset passwords',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM GenericForm GF INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                 
		WHERE /*GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(GF.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM GenericForm GF INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                 
		WHERE /*GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(GF.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM GenericForm GF INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                 
		WHERE /*GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of forms created',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(DISTINCT CA.Id) 
		FROM CustomApplication CA INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id 
		     INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                
		WHERE /*CA.InActiveDateTime IS NULL
			  AND CAF.InActiveDateTime IS NULL
			  AND GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(CA.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(DISTINCT CA.Id) 
		FROM CustomApplication CA INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id 
		     INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                
		WHERE /*CA.InActiveDateTime IS NULL
			  AND CAF.InActiveDateTime IS NULL
			  AND GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(CA.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(DISTINCT CA.Id) 
		FROM CustomApplication CA INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id 
		     INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                
		WHERE /*CA.InActiveDateTime IS NULL
			  AND CAF.InActiveDateTime IS NULL
			  AND GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of custom applications created',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM GenericForm GF INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                 
		WHERE /*GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(GF.UpdatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM GenericForm GF INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                 
		WHERE /*GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(GF.UpdatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM GenericForm GF INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                 
		WHERE /*GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND GF.UpdatedDateTime IS NOT NULL

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of forms updated',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(DISTINCT CA.Id) 
		FROM CustomApplication CA INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id 
		     INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                
		WHERE /*CA.InActiveDateTime IS NULL
			  AND CAF.InActiveDateTime IS NULL
			  AND GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(CA.UpdatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(DISTINCT CA.Id) 
		FROM CustomApplication CA INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id 
		     INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                
		WHERE /*CA.InActiveDateTime IS NULL
			  AND CAF.InActiveDateTime IS NULL
			  AND GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CAST(CA.UpdatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(DISTINCT CA.Id) 
		FROM CustomApplication CA INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id 
		     INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId INNER JOIN FormType FT ON FT.Id = GF.FormTypeId                
		WHERE /*CA.InActiveDateTime IS NULL
			  AND CAF.InActiveDateTime IS NULL
			  AND GF.InActiveDateTime IS NULL
			  AND FT.InActiveDateTime IS NULL
			  AND*/ FT.CompanyId = @UsageCompanyId
			  AND CA.UpdatedDateTime IS NOT NULL

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of custom applicaitons updated',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM [Message] M INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ ChannelId IS NULL
			  AND MT.CompanyId = @UsageCompanyId
			  AND CAST(M.OriginalCreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM [Message] M INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ ChannelId IS NULL
			  AND MT.CompanyId = @UsageCompanyId
			  AND CAST(M.OriginalCreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM [Message] M INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ ChannelId IS NULL
			  AND MT.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of individual messages sent',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM [Message] M INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ ChannelId IS NOT NULL
			  AND MT.CompanyId = @UsageCompanyId
			  AND CAST(M.OriginalCreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM [Message] M INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ ChannelId IS NOT NULL
			  AND MT.CompanyId = @UsageCompanyId
			  AND CAST(M.OriginalCreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM [Message] M INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ ChannelId IS NOT NULL
			  AND MT.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of group messages sent',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM Announcement                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM Announcement                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM Announcement                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of announcements ',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM TimeSheet TS INNER JOIN [User] U ON TS.UserId = U.Id 
		WHERE /*TS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(TS.[Date] AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM TimeSheet TS INNER JOIN [User] U ON TS.UserId = U.Id 
		WHERE /*TS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(TS.[Date] AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM TimeSheet TS INNER JOIN [User] U ON TS.UserId = U.Id 
		WHERE /*TS.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of times punchcard is used',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM StarredMessages SM INNER JOIN [Message] M ON M.Id = SM.MessageId INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ MT.CompanyId = @UsageCompanyId
			  AND CAST(SM.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM StarredMessages SM INNER JOIN [Message] M ON M.Id = SM.MessageId INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ MT.CompanyId = @UsageCompanyId
			  AND CAST(SM.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM StarredMessages SM INNER JOIN [Message] M ON M.Id = SM.MessageId INNER JOIN MessageType MT ON M.MessageTypeId = MT.Id 
		WHERE /*M.InActiveDateTime IS NULL
		      AND MT.InActiveDateTime IS NULL
			  AND*/ MT.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of time messages are starred',@TodayUsage,@ThisMonthUsage,@OverallUsage

		--SELECT @TodayUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = 'B1D96BDD-2EFC-483C-85F1-2CC5903492D7'
		--	  AND U.CompanyId = @UsageCompanyId
		--	  AND CAST(UFA.CreatedDateTime AS DATE) = @CurrentDate

		--SELECT @ThisMonthUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = 'B1D96BDD-2EFC-483C-85F1-2CC5903492D7'
		--	  AND U.CompanyId = @UsageCompanyId
		--	  AND CAST(UFA.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		--SELECT @OverallUsage = COUNT(1) FROM UsefulFeatureAudit UFA INNER JOIN [User] U ON U.Id = UFA.CreatedByUserId
		--WHERE /*U.InActiveDateTime IS NULL
		--      AND*/ UFA.UsefulFeatureId = 'B1D96BDD-2EFC-483C-85F1-2CC5903492D7'
		--	  AND U.CompanyId = @UsageCompanyId

		--INSERT INTO #CompanyFeatures
		--SELECT @UsageCompanyId,@CompanyName,'Number of time messages are pinned',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) FROM LeaveApplication LA INNER JOIN [User] U ON LA.UserId = U.Id 
		WHERE /*LA.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(LA.CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) FROM LeaveApplication LA INNER JOIN [User] U ON LA.UserId = U.Id 
		WHERE /*LA.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId
			  AND CAST(LA.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) FROM LeaveApplication LA INNER JOIN [User] U ON LA.UserId = U.Id 
		WHERE /*LA.InActiveDateTime IS NULL
		      AND U.InActiveDateTime IS NULL
			  AND*/ U.CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of leaves applied',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1)
		FROM LeaveApplicationStatusSetHistory LASS
		     INNER JOIN (SELECT LeaveApplicationId, MAX(LASS.CreatedDateTime) CreatedDateTime
						 FROM LeaveApplicationStatusSetHistory LASS 
						      INNER JOIN LeaveApplication LA ON LA.Id = LASS.LeaveApplicationId
						      INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
						 WHERE /*LASS.InActiveDateTime IS NULL
						       AND LA.InActiveDateTime IS NULL
						 	   AND LS.InActiveDateTime IS NULL
						 	   AND*/ LS.CompanyId = @UsageCompanyId
						 	   AND CAST(LASS.CreatedDateTime AS DATE) = @CurrentDate
						  GROUP BY LeaveApplicationId) LASSInner ON LASSInner.LeaveApplicationId = LASS.LeaveApplicationId AND LASSInner.CreatedDateTime = LASS.CreatedDateTime
			INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
		WHERE LS.IsRejected = 1

		SELECT @ThisMonthUsage = COUNT(1)
		FROM LeaveApplicationStatusSetHistory LASS
		     INNER JOIN (SELECT LeaveApplicationId, MAX(LASS.CreatedDateTime) CreatedDateTime
						 FROM LeaveApplicationStatusSetHistory LASS 
						      INNER JOIN LeaveApplication LA ON LA.Id = LASS.LeaveApplicationId
						      INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
						 WHERE /*LASS.InActiveDateTime IS NULL
						       AND LA.InActiveDateTime IS NULL
						 	   AND LS.InActiveDateTime IS NULL
						 	   AND*/ LS.CompanyId = @UsageCompanyId
						 	   AND CAST(LASS.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate
						 GROUP BY LeaveApplicationId) LASSInner ON LASSInner.LeaveApplicationId = LASS.LeaveApplicationId AND LASSInner.CreatedDateTime = LASS.CreatedDateTime
			INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
		WHERE LS.IsRejected = 1

		SELECT @OverallUsage = COUNT(1)
		FROM LeaveApplicationStatusSetHistory LASS
		     INNER JOIN (SELECT LeaveApplicationId, MAX(LASS.CreatedDateTime) CreatedDateTime
						 FROM LeaveApplicationStatusSetHistory LASS 
						      INNER JOIN LeaveApplication LA ON LA.Id = LASS.LeaveApplicationId
						      INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
						 WHERE /*LASS.InActiveDateTime IS NULL
						       AND LA.InActiveDateTime IS NULL
						 	   AND LS.InActiveDateTime IS NULL
						 	   AND*/ LS.CompanyId = @UsageCompanyId
						 GROUP BY LeaveApplicationId) LASSInner ON LASSInner.LeaveApplicationId = LASS.LeaveApplicationId AND LASSInner.CreatedDateTime = LASS.CreatedDateTime
			INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
		WHERE LS.IsRejected = 1
			  
		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of leaves rejected',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1)
		FROM LeaveApplicationStatusSetHistory LASS
		     INNER JOIN (SELECT LeaveApplicationId, MAX(LASS.CreatedDateTime) CreatedDateTime
						 FROM LeaveApplicationStatusSetHistory LASS 
						      INNER JOIN LeaveApplication LA ON LA.Id = LASS.LeaveApplicationId
						      INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
						 WHERE /*LASS.InActiveDateTime IS NULL
						       AND LA.InActiveDateTime IS NULL
						 	   AND LS.InActiveDateTime IS NULL
						 	   AND*/ LS.CompanyId = @UsageCompanyId
						 	   AND CAST(LASS.CreatedDateTime AS DATE) = @CurrentDate
						  GROUP BY LeaveApplicationId) LASSInner ON LASSInner.LeaveApplicationId = LASS.LeaveApplicationId AND LASSInner.CreatedDateTime = LASS.CreatedDateTime
			INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
		WHERE LS.IsApproved = 1

		SELECT @ThisMonthUsage = COUNT(1)
		FROM LeaveApplicationStatusSetHistory LASS
		     INNER JOIN (SELECT LeaveApplicationId, MAX(LASS.CreatedDateTime) CreatedDateTime
						 FROM LeaveApplicationStatusSetHistory LASS 
						      INNER JOIN LeaveApplication LA ON LA.Id = LASS.LeaveApplicationId
						      INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
						 WHERE /*LASS.InActiveDateTime IS NULL
						       AND LA.InActiveDateTime IS NULL
						 	   AND LS.InActiveDateTime IS NULL
						 	   AND*/ LS.CompanyId = @UsageCompanyId
						 	   AND CAST(LASS.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate
						 GROUP BY LeaveApplicationId) LASSInner ON LASSInner.LeaveApplicationId = LASS.LeaveApplicationId AND LASSInner.CreatedDateTime = LASS.CreatedDateTime
			INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
		WHERE LS.IsApproved = 1

		SELECT @OverallUsage = COUNT(1)
		FROM LeaveApplicationStatusSetHistory LASS
		     INNER JOIN (SELECT LeaveApplicationId, MAX(LASS.CreatedDateTime) CreatedDateTime
						 FROM LeaveApplicationStatusSetHistory LASS 
						      INNER JOIN LeaveApplication LA ON LA.Id = LASS.LeaveApplicationId
						      INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
						 WHERE /*LASS.InActiveDateTime IS NULL
						       AND LA.InActiveDateTime IS NULL
						 	   AND LS.InActiveDateTime IS NULL
						 	   AND*/ LS.CompanyId = @UsageCompanyId
						 GROUP BY LeaveApplicationId) LASSInner ON LASSInner.LeaveApplicationId = LASS.LeaveApplicationId AND LASSInner.CreatedDateTime = LASS.CreatedDateTime
			INNER JOIN LeaveStatus LS ON LS.Id = LASS.LeaveStatusId
		WHERE LS.IsApproved = 1
			  
		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Number of leaves approved',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = COUNT(1) 
		FROM UploadFile                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = COUNT(1) 
		FROM UploadFile                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = COUNT(1) 
		FROM UploadFile                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Count of documents',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SELECT @TodayUsage = ISNULL(SUM(FileSize),0)
		FROM UploadFile                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = ISNULL(SUM(FileSize),0)
		FROM UploadFile                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId
			  AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = ISNULL(SUM(FileSize),0)
		FROM UploadFile                
		WHERE /*InActiveDateTime IS NULL
			  AND*/ CompanyId = @UsageCompanyId

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Documents Storage Size',@TodayUsage,@ThisMonthUsage,@OverallUsage

		TRUNCATE TABLE #Productivity

		INSERT INTO #Productivity(UserStoryId,Deadline,IsEsimatedHours,IsLoggedHours)
		SELECT US.Id,UW.DeadLine,CH.IsEsimatedHours,CH.IsLoggedHours
		FROM UserStory US
			 INNER JOIN (SELECT US.Id,MAX(USWFT.TransitionDateTime) AS DeadLine
		                 FROM UserStory US 
			                  INNER JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
			                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
			 				  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
			 				  INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
			                  INNER JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
			                  INNER JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
			 			 GROUP BY US.Id) UW ON US.Id = UW.Id
			INNER JOIN Goal G ON G.Id = US.GoalId
			INNER JOIN Project P ON P.Id = G.ProjectId
			INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
			INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
			INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
			INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
			LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
		WHERE P.CompanyId = @UsageCompanyId
		      AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
			  AND (TS.TaskStatusName IN (N'Done',N'Verification completed'))
			  AND IsProductiveBoard = 1  
			  AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)

		INSERT INTO #Productivity(UserStoryId,Deadline,IsEsimatedHours)
		SELECT US.Id,UW.DeadLine,1
		FROM UserStory US
			 INNER JOIN (SELECT US.Id,MAX(USWFT.TransitionDateTime) AS DeadLine
		                 FROM UserStory US 
			                  INNER JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
			                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
			 				  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
			 				  INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
			                  INNER JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
			                  INNER JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
			 			 GROUP BY US.Id) UW ON US.Id = UW.Id
			INNER JOIN Sprints S ON S.Id = US.SprintId
			INNER JOIN Project P ON P.Id = S.ProjectId
			INNER JOIN [BoardType] BT ON BT.Id = S.BoardTypeId
			INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
			INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
			LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
		WHERE P.CompanyId = @UsageCompanyId
		      AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
			  AND (TS.TaskStatusName IN (N'Done',N'Verification completed'))

		UPDATE #Productivity SET ProductivityIndex = US.EstimatedTime
		FROM UserStory US INNER JOIN #Productivity PUS ON US.Id = PUS.UserStoryId WHERE IsEsimatedHours = 1
		      
		UPDATE #Productivity SET ProductivityIndex = LUSInner.LoggedTime
		FROM #Productivity PUS
		     INNER JOIN (SELECT UST.UserStoryId,SUM(SpentTimeInMin/60.0) LoggedTime
		                 FROM UserStorySpentTime UST 
		                      INNER JOIN #Productivity PUS ON PUS.UserStoryId = UST.UserStoryId
		                 WHERE IsLoggedHours = 1
		                 GROUP BY UST.UserStoryId) LUSInner ON LUSInner.UserStoryId = PUS.UserStoryId

		SELECT @TodayUsage = ISNULL(SUM(ProductivityIndex),0)
		FROM #Productivity                
		WHERE CAST(Deadline AS DATE) = @CurrentDate

		SELECT @ThisMonthUsage = ISNULL(SUM(ProductivityIndex),0)
		FROM #Productivity                
		WHERE CAST(Deadline AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentDate

		SELECT @OverallUsage = ISNULL(SUM(ProductivityIndex),0)
		FROM #Productivity                

		INSERT INTO #CompanyFeatures
		SELECT @UsageCompanyId,@CompanyName,'Productive Hours',@TodayUsage,@ThisMonthUsage,@OverallUsage

		SET @CompaniesCounter = @CompaniesCounter + 1

	END

	SELECT * FROM #CompanyFeatures ORDER BY CompanyName, Feature

END
GO

--EXEC USP_GetCompanyApplicationsUsageDetails