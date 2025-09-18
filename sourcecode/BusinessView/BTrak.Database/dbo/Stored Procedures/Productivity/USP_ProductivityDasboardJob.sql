-------------------------------------------------------------------------------
-- Author       LSSMK Varma
-- Created      '2021-02-18 00:00:00.000'
-- Purpose      Recurring productivity dashboard job
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--   EXEC [dbo].[USP_ProductivityDasboardJob] @UserId='369df921-fe0d-4955-add7-76dfefee0bda'

CREATE PROCEDURE [dbo].[USP_ProductivityDasboardJob]
(
    @Date DATE = NULL,
	@UserId UNIQUEIDENTIFIER = NULL

)AS
BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
 DECLARE @Company UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

 SET @Date = IIF(@Date IS NULL,CONVERT(DATE, DATEADD(day,-1,GETDATE())) ,CONVERT(DATE,@Date)) 
 DECLARE @CountOfRecords INT = (select COUNT(1) from ProductivityDashboardStats where CONVERT(DATE,CreatedDateTime) = CONVERT(DATE,@Date) and userId = @UserId)
 IF(@CountOfRecords = 0)
 BEGIN
-- productivity--
	DECLARE @productiveHoursInMin FLOAT = (select FLOOR(Productive/60000.0) from UserActivityTimeSummary where UserId = @UserId and convert(Date,CreatedDateTime) = @Date and CompanyId = @Company)
	DECLARE @ToDay DATETIME = @Date
	DECLARE @noOfDays FLOAT = (SELECT DAY(EOMONTH(@ToDay)) AS DaysInMonth)
	DECLARE @totalExpectedHoursInMin FLOAT =(SELECT TOP 1 ([Value]/@noOfDays)*60.0 FROM [dbo].[CompanySETtings]
																 WHERE [Key] = 'ExpectedProductivityFROMEmployeePerMonth' and CompanyId = @Company)
	DECLARE @Productivity FLOAT
	IF(@productiveHoursInMin = 0 or @totalExpectedHoursInMin = 0 or @totalExpectedHoursInMin IS NULL)
		BEGIN
			SET @Productivity = 0
		END
	ELSE
		BEGIN
			SET @Productivity = (SELECT ISNULL(ROUND((@productiveHoursInMin/@totalExpectedHoursInMin) * 100,2),0));
		END

-- efficiency--
	DECLARE @taskProductivityInMin FLOAT
	SELECT @taskProductivityInMin = ISNULL(SUM(EstimatedTime * 60),0) FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](@Date,@Date,@UserId,@Company) 
	--DECLARE @timeProductivity FLOAT = (SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId in(SELECT UserStoryId FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](@Date,@Date,@UserId,@Company)))
	DECLARE @efficency FLOAT 
	IF(@taskProductivityInMin = 0 or @productiveHoursInMin = 0 or @productiveHoursInMin IS NULL)
		BEGIN
			SET @efficency = 0
		END
	ELSE
		BEGIN
			SET @efficency = (SELECT ISNULL(ROUND((@taskProductivityInMin/CAST(@productiveHoursInMin AS INT)) * 100, 2),0))
		END

-- Utilization
	DECLARE @taskWorkedHours FLOAT,
			@totalExpectedhoursoftasks FLOAT,
			@utilization FLOAT
		SELECT  @taskWorkedHours = ISNULL(SUM(SpentTimeInMin),0), @totalExpectedhoursoftasks = ISNULL(sum(US.EstimatedTime)*60,0)
			  FROM UserStorySpentTime USST
			  LEFT JOIN UserStory US ON US.Id = USST.UserStoryId AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
			  --LEFT JOIN Goal G ON G.Id = US.GoalId AND G.IsProductiveBoard = 1 AND G.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL
			  --LEFT JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
			  --LEFT join Sprints S ON S.Id = US.SprintId and S.InActiveDateTime is null AND S.IsComplete <> 1
			  WHERE UserId = @UserId AND CONVERT(DATE,DateFROM) = CONVERT(DATE,@Date)
	IF(@taskWorkedHours = 0 or @totalExpectedhoursoftasks = 0 or @totalExpectedhoursoftasks IS NULL)
		BEGIN
			SET @utilization = 0
		END
	ELSE
		BEGIN
			SET @utilization = (SELECT ROUND((@taskWorkedHours/@totalExpectedhoursoftasks) * 100, 2))
		END
		
--Predictability--

	DECLARE @Nooftasksmetdeadlines FLOAT,@TotalNoOFTasks FLOAT
	SELECT @TotalNoOFTasks = count(*),
		  @Nooftasksmetdeadlines = count(CASE WHEN USS1.TaskStatusId IN('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D') THEN 1 END) 
		  
	FROM UserStory US 
	JOIN Project P ON P.Id = US.ProjectId 
	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
		  LEFT JOIN Goal G ON G.Id = US.GoalId AND (G.InActiveDateTime IS NULL)
		  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
	left join (SELECT USWST.UserStoryId,max(USWST.TransitionDateTime) [DoneDate] FROM UserStoryWorkflowStatusTransition USWST
						INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId 
						INNER JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id --AND USS1.TaskStatusId IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
						where USWST.CompanyId = @Company AND CONVERT(DATE,USWST.TransitionDateTime) <= @Date group by USWST.UserStoryId) DDT ON DDT.UserStoryId = US.Id
	left join UserStoryWorkflowStatusTransition USWST1 on USWST1.UserStoryId = DDT.UserStoryId and USWST1.TransitionDateTime = DDT.DoneDate
	left join WorkflowEligibleStatusTransition WEST1 on WEST1.Id = USWST1.WorkflowEligibleStatusTransitionId
	left join UserStoryStatus USS1 ON WEST1.ToWorkflowUserStoryStatusId = USS1.Id
	WHERE US.OwnerUserId= @UserId AND (CONVERT(DATE,US.DeadLineDate) = @Date OR (convert(Date,US.DeadLineDate) IS NULL AND US.SprintId IS NOT NULL AND S.SprintEndDate = @Date AND S.SprintStartDate IS NOT NULL))
	AND ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL))
	AND US.InActiveDateTime IS NULL
	AND P.InActiveDateTime IS NULL
	DECLARE @Predictability FLOAT;
	IF(@Nooftasksmetdeadlines = 0 or @TotalNoOFTasks = 0)
		BEGIN
			SET @Predictability = 0
		END
	ELSE
		BEGIN
			SET @Predictability = (SELECT ROUND((@Nooftasksmetdeadlines/@TotalNoOFTasks) * 100, 2))
		END
	
--Quality--
	DECLARE @Quality nvarchar(max) 
	--SET @Productivity= @taskProductivityInMin  --iif(@productiveHoursInMin is null,0,@productiveHoursInMin)
	DECLARE @noOfBugs INT = (select ISNULL(count(1),0) from (
												select BCU.UserId,US.Id,
													   OwnerUserId 
											    from UserStory US
												left join BugCausedUser BCU on BCU.UserStoryId = US.Id 
												WHERE UserStoryTypeId = (SELECT Id FROM UserStoryType WHERE  CompanyId = @Company and IsBug = 1) 
												and OwnerUserId=@UserId and CONVERT(DATE,US.CreatedDateTime) = CONVERT(DATE,@Date) and US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
												  ) as NB where NB.OwnerUserId=NB.UserId or NB.UserId is null)

-- Planed Hours--
	DECLARE @PlanedHours FLOAT = (SELECT ISNULL(SUM(EstimatedTime),0) FROM userStory US
									JOIN Project P ON P.Id = US.ProjectId 
									LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
									LEFT JOIN Goal G ON G.Id = US.GoalId AND (G.InActiveDateTime IS NULL) 
									LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
								WHERE US.OwnerUserId = @UserId AND (convert(Date,US.DeadLineDate) = @Date OR (convert(Date,US.DeadLineDate) IS NULL AND US.SprintId IS NOT NULL AND S.SprintEndDate = @Date AND S.SprintStartDate IS NOT NULL))
										  AND ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL))
										  AND US.InActiveDateTime IS NULL 
										  AND US.ParkedDateTime is null
										  AND P.InActiveDateTime IS NULL)

--delivered hours--
	DECLARE @DeliverdHours FLOAT = @taskProductivityInMin

--spent hours-- 
	DECLARE @SpentHoursInMin INT
	SELECT @SpentHoursInMin = ISNULL(SUM(SpentTimeInMin),0) FROM UserStorySpentTime USST
			INNER JOIN UserStory US ON US.Id = USST.UserStoryId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
			LEFT JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
			LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL
			LEFT JOIN Sprints S ON S.ID = US.SprintId AND S.InActiveDateTime IS NULL 
	WHERE UserId = @UserId and CONVERT(DATE,DateFROM) = CONVERT(DATE,@Date)	

--completed hours--
		DECLARE @CompletedTasks INT
	SELECT @CompletedTasks = COUNT(1)
		  FROM  UserStory US
		  INNER JOIN (SELECT US.Id
		                ,MAX(USWFT.TransitionDateTime) AS DeadLine
                                    FROM UserStory US 
	                                JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
	                                JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
									JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
	                                JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
	                                JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
									GROUP BY US.Id) UW ON US.Id = UW.Id
		   INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
		   INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
				WHERE (TS.Id IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D')) 
					   AND CONVERT(DATE,UW.DeadLine) = CONVERT(DATE,@Date) 
					   AND US.OwnerUserId = @UserId
--pending Tasks--
	DECLARE @PendingTasks INT
	SELECT @PendingTasks = COUNT(1) FROM UserStory US
			JOIN UserStoryStatus USS on USS.Id = US.UserStoryStatusId AND CompanyId = @Company
			JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime is null
			LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
			LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
			LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
			where OwnerUserId = @UserId 
				  AND USS.TaskStatusId NOT IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76','884947DF-579A-447A-B28B-528A29A3621D') 
				  AND convert(date,US.DeadLineDate) = @Date
				  AND US.ParkedDateTime IS NULL 
				  AND US.InActiveDateTime IS NULL
				  AND ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL))
--No. of bugs--
    DECLARE @noOfAllbugs INT = @noOfBugs 
								--(SELECT COUNT(Id) FROM UserStory  WHERE  UserStoryTypeId = (SELECT Id FROM UserStoryType WHERE IsBug = 1 and CompanyId = @Company) 
								--and OwnerUserId = @UserId 
								--and CONVERT(DATE,CreatedDateTime) = CONVERT(DATE,@Date) and InActiveDateTime IS NULL AND ParkedDateTime IS NULL)


--no. of bounce backs--
	DECLARE @noOfbouncebacks INT = (SELECT count(*) FROM UserStory US 
									INNER JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id and CONVERT(DATE,USWST.CreatedDateTime) = CONVERT(DATE,@date)
									INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId 
									INNER JOIN UserStoryStatus USS ON WEST.FROMWorkflowUserStoryStatusId = USS.Id AND USS.TaskStatusId IN ('5C561B7F-80CB-4822-BE18-C65560C15F5B','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  
									INNER JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id AND USS1.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
									WHERE US.OwnerUserId = @UserId AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL)
	

--Others Time--
	DECLARE @othersTimeInMin NVARCHAR(max) = (select ISNULL(SUM(USST.SpentTimeInMin),0) from UserStory US
											  INNER JOIN UserStorySpentTime USST on USST.UserStoryId = US.Id AND USST.UserId <> US.OwnerUserId AND convert(Date,USST.CreatedDateTime) = convert(Date,@Date)
											  where US.OwnerUserId = @UserId AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL) 
	

--P0,p1,p2,p3 bugs--
	declare @P0Bugs int,@P1Bugs int,@P2Bugs int,@P3Bugs int
	select @P0Bugs = ISNULL(count(case BP.[Order] when 1 then 1 END),0), 
		   @P1Bugs = ISNULL(count(case BP.[Order] when 2 then 1 END),0),
		   @P2Bugs = ISNULL(count(case BP.[Order] when 3 then 1 END),0),
		   @P3Bugs = ISNULL(count(case BP.[Order] when 4 then 1 END), 0)
	from UserStory US
	INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId and IsBug = 1
	INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
	LEFT join BugCausedUser BCU on BCU.UserStoryId = US.Id
	where US.OwnerUserId = @UserId AND CONVERT(DATE,US.CreatedDateTime) = CONVERT(DATE,@Date) 
								   AND US.InActiveDateTime IS NULL 
								   AND US.ParkedDateTime IS NULL 
								   AND (BCU.UserId =US.OwnerUserId or BCU.UserId  is null)


--capacity hours
	DECLARE @CapacityHours int
	DECLARE @DatofWeek NVARCHAR(MAX) = (SELECT DATENAME(WEEKDAY, @Date)) 
	SELECT @CapacityHours =  ISNULL(IIF(H.[Date] is not null,0,DATEDIFF(HOUR, SW.StartTime, SW.EndTime)),0) FROM Employee E
	LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id and (@date between ActiveFrom and ActiveTo or (ActiveFrom<=@date and ActiveTo is null))
	LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId and SW.[DayOfWeek] = @DatofWeek
	LEFT JOIN Holiday H ON H.[Date] = @Date
	where UserId = @UserId AND E.InActiveDateTime IS NULL

--no. of Replaned tasks
     DECLARE @ReplanedTasks int
   SELECT @ReplanedTasks = ISNULL(SUM(RC.ReplanCount),0) FROM (
					SELECT COUNT(UserStoryId) AS [ReplanCount] FROM UserStoryReplan USR 
							inner join UserStory US ON US.Id = USR.UserStoryId and US.OwnerUserId = @UserId
							INNER join Project P ON P.Id = US.ProjectId and P.InActiveDateTime is null
							left join Goal G ON G.Id = US.GoalId and G.ParkedDateTime is null and G.InActiveDateTime is null
							LEFT JOIN GoalStatus GS ON  GS.Id = G.GoalStatusId
							left join Sprints S On S.Id = Us.SprintId and S.InActiveDateTime is null
							WHERE CONVERT(DATE,USR.CreatedDateTime) = @Date AND ((us.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (us.GoalId IS NOT NULL))
							GROUP BY UserStoryId HAVING COUNT(UserStoryId)>0) RC


Insert INTo ProductivityDashboardStats
values(NEWID(),@UserId,ISNULL(@Productivity,0),ISNULL(@efficency,0),ISNULL(@utilization,0),ISNULL(@Predictability,0),ISNULL(@noOfBugs,0),ISNULL(@PlanedHours,0),ISNULL(@DeliverdHours,0),ISNULL(@SpentHoursInMin,0),ISNULL(@CompletedTasks,0),ISNULL(@PendingTasks,0),ISNULL(@noOfAllbugs,0),ISNULL(@noOfbouncebacks,0),ISNULL(@othersTimeInMin,0),ISNULL(@P0Bugs,0),ISNULL(@P1Bugs,0),ISNULL(@P2Bugs,0),ISNULL(@P3Bugs,0),@Date,ISNULL(@CapacityHours,0),ISNULL(@ReplanedTasks,0),ISNULL(@taskProductivityInMin,0))
END
  END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO