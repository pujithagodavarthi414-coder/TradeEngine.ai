--EXEC [dbo].[USP_ProductivityStats] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b',@DateFrom = '2021-03-18',@DateTo = '2021-03-18',@FilterType = 'Team'
CREATE PROCEDURE [dbo].[USP_ProductivityStats]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@DateFrom DATETIME = null,
@DateTo DATETIME = null,
@Date DATETIME = NULL,
@FilterType NVARCHAR(MAX) = null,
@UserId UNIQUEIDENTIFIER = null,
@LineManagerId UNIQUEIDENTIFIER = null,
@BranchId UNIQUEIDENTIFIER = null
)AS
BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
	DECLARE @Company UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	SET @FilterType = IIF(@FilterType IS NULL,'Individual',@FilterType)
	SET @UserId = IIF(@UserId IS NULL,@OperationsPerformedBy,@UserId)
	SET @DateFrom = CONVERT(DATE,(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))))))
	SET @DateTo = CONVERT(DATE,(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))

	DECLARE @UsersIds table(Id UNIQUEIDENTIFIER) 
	IF(@FilterType = 'Individual')
		BEGIN
			INSERT INTO @UsersIds
			values (@UserId)
		END
	ELSE IF(@FilterType = 'Team')
		BEGIN
			INSERT INTO @UsersIds
			SELECT Id FROM [User] U
			JOIN Ufn_GetEmployeeReportedMembers(IIF(@LineManagerId IS NULL,@UserId,@LineManagerId),@Company) ERM ON ERM.ChildId = U.Id AND U.InActiveDateTime IS NULL AND U.IsActive = 1 group by Id
		END
	ELSE IF(@FilterType = 'Branch')
		BEGIN
			INSERT INTO @UsersIds
			SELECT U.Id AS UserId
			      	   FROM [User] U
			      JOIN Employee E ON E.UserId = U.Id 
			      JOIN [EmployeeBranch] EB ON EB.EmployeeId = E.Id AND EB.BranchId = iif(@BranchId IS NULL,(SELECT BranchId FROM [dbo].[EmployeeBranch] WHERE EmployeeId = (SELECT Id FROM Employee WHERE UserId= @UserId)),@BranchId)
			      JOIN Branch B ON B.Id = EB.BranchId AND B.CompanyId = U.CompanyId
			      where U.InActiveDateTime IS NULL 
						  AND U.IsActive = 1
			      	  AND B.InActiveDateTime IS NULL		
		END
	ELSE IF(@FilterType = 'Company')
		BEGIN
			INSERT INTO @UsersIds
			SELECT E.UserId from Employee E
			JOIN [User] U On U.Id = E.UserId 
			where U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id= @UserId) AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND U.IsActive = 1
		END
	CREATE TABLE #ProductivityandQualityStats 
	(
		[PlannedHours] FLOAT,
		[DeliveredHours] FLOAT,
		[SpentHoursInMIn] INT,
		[CapacityHours] INT,
		[NoOfBugs] INT,
		[NoOfbouncebacks] INT,
		[ReplanedTasks] INT,
		[OthersTimeInMIn] INT,
		[CompletedTasks] INT,
		[PendingTasks] INT,
		[P0Bugs] INT,
		[P1Bugs] INT,
		[P2Bugs] INT,
		[P3Bugs] INT,
	)
	DECLARE @ProductivityStatsTable table(UserId UNIQUEIDENTIFIER,Planedhours FLOAT,DeliverdHours FLOAT,SpentHoursInMIn INT,CapacityHours INT,noOfAllbugs INT,noOfbouncebacks INT,othersTimeInMIn INT,ReplanedTasks INT,CreatedDateTime DATETIME) 
	INSERT INTO @ProductivityStatsTable
	SELECT UserId,
		   AVG(Planedhours)Planedhours,
		   AVG(DeliverdHours)DeliverdHours,
		   AVG(SpentHoursInMIn)SpentHoursInMIn,
		   AVG(CapacityHours)CapacityHours,
		   AVG(noOfAllbugs)noOfAllbugs,
		   AVG(noOfbouncebacks)noOfbouncebacks,
		   AVG(othersTimeInMIn)othersTimeInMIn,
		   AVG(ReplanedTasks)ReplanedTasks,
		   MAX(CreatedDateTime)CreatedDateTime
		   FROM ProductivityDashboardStats WHERE UserId IN(SELECT * FROM @UsersIds) AND CreatedDateTime  BETWEEN @DateFrom AND @DateTo group by userId,CreatedDateTime

	DECLARE @Planedhours FLOAT,@DeliverdHours FLOAT,@SpentHoursInMIn INT,@CapacityHours INT,@noOfAllbugs INT,@noOfbouncebacks INT,@ReplanedTasks INT,@othersTimeInMIn INT
	SELECT @Planedhours= ISNULL(SUM(Planedhours*60),0),
		   @DeliverdHours=ISNULL(SUM(DeliverdHours),0),
		   @SpentHoursInMIn = ISNULL(SUM(SpentHoursInMIn),0),
		   @CapacityHours = ISNULL(SUM(CapacityHours),0),
		   @noOfAllbugs = ISNULL(SUM(noOfAllbugs),0),
		   @noOfbouncebacks = ISNULL(SUM(noOfbouncebacks),0),
		   @ReplanedTasks = ISNULL(SUM(ReplanedTasks),0),
		   @othersTimeInMIn = ISNULL(SUM(othersTimeInMIn),0)
	 FROM @ProductivityStatsTable WHERE UserId in(SELECT * FROM @UsersIds) AND CreatedDateTime  BETWEEN @DateFrom AND @DateTo

	 --completed tasks
	DECLARE @CompletedTasks INT
	SELECT @CompletedTasks = COUNT(1)
		  FROM  UserStory US
		  INNER JOIN (SELECT US.Id
		                ,MAX(USWFT.TransitionDateTime) AS DeadLine
                                    FROM UserStory US 
	                                JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
	                                JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = @Company
									JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
									JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
	                                JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
	                                JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
									GROUP BY US.Id) UW ON US.Id = UW.Id
		   INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
		   INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
				WHERE (TS.Id IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D')) 
					   AND CONVERT(DATE,UW.DeadLine) between @DateFrom and @DateTo
					   AND US.OwnerUserId in(SELECT * FROM @UsersIds)

--pending tasks
	DECLARE @PendingTasks INT
	SELECT @PendingTasks = COUNT(1) FROM UserStory US
			JOIN UserStoryStatus USS on USS.Id = US.UserStoryStatusId AND CompanyId = @Company
			JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime is null
			LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
			LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
			LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
			where OwnerUserId in(SELECT * FROM @UsersIds)
				  AND USS.TaskStatusId NOT IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D') 
				  --AND convert(date,US.DeadLineDate) between @DateFrom and @DateTo
				  AND (convert(Date,US.DeadLineDate) between @DateFrom and @DateTo OR (convert(Date,US.DeadLineDate) IS NULL AND US.SprintId IS NOT NULL AND S.SprintEndDate between @DateFrom and @DateTo AND S.SprintStartDate IS NOT NULL))
				  AND US.ParkedDateTime IS NULL 
				  AND US.InActiveDateTime IS NULL
				  AND ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL))
--P0/P1/P2/P3
	declare @P0Bugs int,@P1Bugs int,@P2Bugs int,@P3Bugs int
	select @P0Bugs = ISNULL(count(case BP.[Order] when 1 then 1 END),0), 
		   @P1Bugs = ISNULL(count(case BP.[Order] when 2 then 1 END),0),
		   @P2Bugs = ISNULL(count(case BP.[Order] when 3 then 1 END),0),
		   @P3Bugs = ISNULL(count(case BP.[Order] when 4 then 1 END), 0)
	from UserStory US
	INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId and IsBug = 1
	INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
	LEFT join BugCausedUser BCU on BCU.UserStoryId = US.Id
	where US.OwnerUserId in(SELECT * FROM @UsersIds) AND CONVERT(DATE,US.CreatedDateTime) between @DateFrom and @DateTo
								   AND US.InActiveDateTime IS NULL 
								   AND US.ParkedDateTime IS NULL 
								   AND (BCU.UserId =US.OwnerUserId or BCU.UserId  is null)

	insert into #ProductivityandQualityStats
	values(@Planedhours,@DeliverdHours,@SpentHoursInMIn,@CapacityHours,@noOfAllbugs,@noOfbouncebacks,@ReplanedTasks,@othersTimeInMIn,@CompletedTasks,@PendingTasks, @P0Bugs,@P1Bugs,@P2Bugs,@P3Bugs)
	
	select * from #ProductivityandQualityStats

	END TRY
BEGIN CATCH
THROW
END CATCH
END
GO

