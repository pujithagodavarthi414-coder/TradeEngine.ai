--EXEC [dbo].[USP_GetHrStatsDetails] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b', @DateFrom = '3/1/2021',@DateTo = '3/24/2021',@FilterType = 'Individual'
CREATE PROCEDURE [dbo].[USP_GetHrStatsDetails] 
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,
@Date DATETIME = NULL,
@FilterType NVARCHAR(MAX) = NULL,
@UserId UNIQUEIDENTIFIER = NULL,
@LinemanagerId UNIQUEIDENTIFIER = NULL,
@BranchId UNIQUEIDENTIFIER = NULL
)
AS

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
CREATE TABLE #TempDates
        (
        [Date] DATETIME
        )
        INSERT INTO #TempDates ([Date])
        SELECT DATEADD(DAY,number+0,@DateFrom) [Date]
        FROM master..spt_values
        WHERE type = 'P'
        AND number <= DATEDIFF(DAY,@DateFrom,@DateTo)

CREATE TABLE #Hrstats 
(
	[NoOfAbsences] FLOAT,
	[NoOfUnplannedAbsences] FLOAT,
	[Latemornings] INT,
	[Latelunches] INT,
	[LongBreaks] INT,
	[UnProductivPercentage] FLOAT,
	[IdelPercentage] FLOAT,
	[Earlyfinishes] INT
)

--absences & unplanned leaves
DECLARE @NoOfAbsences FLOAT ,@NoOfUnplannedAbsences FLOAT

SELECT @NoOfUnplannedAbsences = ISNULL(SUM(t.[unplanedLeaves]),0) ,@NoOfAbsences = ISNULL(SUM(t.[Absences]),0) FROM(
SELECT CASE WHEN convert(Date,LA.LeaveAppliedDate) >= Convert(Date,LA.LeaveDateFrom) or DATEADD(DAY, -1 ,convert(Date,LA.LeaveDateFrom)) = Convert(Date,LA.LeaveAppliedDate) THEN ISNULL(SUM(DC.[Days]),0) END AS [unplanedLeaves],
	    ISNULL(SUM(DC.[Days]),0) AS [Absences]
FROM LeaveApplication LA
INNER JOIN(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@Company)LS ON LS.Id = LA.OverallLeaveStatusId
LEFT JOIN(
SELECT Total.Id,ISNULL(SUM(Total.Cnt),0) AS [Days]
								 FROM 
                                (SELECT T.[Id]
								       ,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                 ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                           ELSE 1 END END AS Cnt FROM
                                                                           (SELECT DATEADD(DAY,NUMBER,LeaveDateFrom) AS [Date],LA.Id
			                                                                FROM MASTER..SPT_VALUES MSPTV WITH(NOLOCK)
		                                                                    JOIN LeaveApplication LA ON MSPTV.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo)
			       	                                                         AND MSPTV.[Type] = 'P' 
			       	                                                        JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
			       						                                     
			       						                                     AND LT.CompanyId = @Company
				                                                            JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId) T
				               JOIN LeaveApplication LAP ON LAP.Id = T.Id
				               JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId
					           JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					           JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
							   JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @Company
							   LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
							   LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				               LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @Company AND H.WeekOffDays IS NULL
							   ) Total
							   GROUP BY Total.Id) DC ON DC.Id = LA.Id
							WHERE UserId IN(SELECT * FROM @UsersIds)
									AND LeaveDateFrom >= @DateFrom
									AND LeaveDateTo <= @DateTo 
								group by LA.UserId,LA.CreatedByUserId,LA.LeaveAppliedDate,LA.LeaveDateFrom
									) AS t
--no of late starts & lunches
DECLARE @Latemornings INT,@Latelunches INT
SELECT  @Latelunches = ISNULL(SUM(LunchBreakLate),0) ,@Latemornings = ISNULL(SUM(MorningLate),0)
        FROM #TempDates T
        inner JOIN (SELECT TS.[Date] AS Date
        ,CASE WHEN SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME)) THEN 1 ELSE 0 END AS MorningLate
        ,CASE WHEN ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) >= 71 THEN 1 ELSE 0 END AS LunchBreakLate
		,TS.LunchBreakStartTime
		,TS.LunchBreakEndTime,E.UserId
        From [User] U
        INNER JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND E.InactiveDateTime IS NULL AND U.InactiveDateTime IS NULL
        LEFT JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id  AND TS.InActiveDateTime IS NULL
        LEFT JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		          AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  )
        LEFT JOIN ShiftTiming ST WITH (NOLOCK) ON ST.Id = ES.ShiftTimingId 
        --LEFT JOIN UserActiveDetails UAD WITH (NOLOCK) ON UAD.UserId = U.Id 
        LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) AND  SW.InActiveDateTime IS NULL
        LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND  SE.InActiveDateTime IS NULL AND CONVERT(DATE,TS.[Date]) = CONVERT(DATE,SE.ExceptionDate)
        WHERE U.Id IN(SELECT * FROM @UsersIds)
        AND U.CompanyId = @Company
        AND TS.[Date] BETWEEN @DateFrom AND @DateTo
        AND (SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME))
        OR ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) >= 71))TInner ON TInner.[Date] = CONVERT(DATE,T.[Date])

--No.OF longBreaks
DECLARE @LongBreaks INT
SELECT @LongBreaks = ISNULL(COUNT(1),0) FROM Employee E
INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId
INNER JOIN UserBreak UB ON UB.UserId = E.UserId and DATEDIFF(minute, UB.BreakIn, UB.BreakOut) > SW.AllowedBreakTime and DATENAME(WEEKDAY, UB.[Date]) = SW.[DayOfWeek]
WHERE E.UserId IN (SELECT * FROM @UsersIds) and UB.[Date] BETWEEN @DateFrom AND @DateTo

--Unproductiv & Idle Percentages
DECLARE @UnProductivPercentage FLOAT,@IdelPercentage FLOAT
SELECT @IdelPercentage = ISNULL(ROUND(AVG(TT.IdelPercentage),2),0),
	   @UnProductivPercentage = ISNULL(ROUND(AVG(TT.UnProductivPercentage),2),0)
	   FROM(SELECT ISNULL(IIF(t.IdleTime = 0 or t.TotalTime = 0,0,ROUND((t.IdleTime/t.TotalTime) *100,2)),0) AS IdelPercentage,
				   ISNULL(IIF(t.UnProductiveTime = 0 or t.TotalTime = 0,0,ROUND((t.UnProductiveTime/t.TotalTime) *100,2)),0) AS UnProductivPercentage
			 FROM(SELECT ISNULL(SUM(FLOOR(IdleInMinutes + (Neutral + UnProductive + Productive)/60000.0)),0) AS TotalTime,
						  ISNULL(SUM(FLOOR((UnProductive)/60000.0)),0) AS UnProductiveTime,
						  ISNULL(SUM(IdleInMinutes),0) AS IdleTime,
						  UserId
				   FROM UserActivityTimeSummary where UserId IN(SELECT * FROM @UsersIds) 
						AND CONVERT(Date,CreatedDateTime) BETWEEN @DateFrom AND @DateTo 
						AND CompanyId = @Company group by UserId)T)TT
--early finishes
DECLARE @EarlyFinishes INT
SELECT @EarlyFinishes = ISNULL(COUNT(1),0) FROM timesheet TS  
INNER JOIN Employee E ON E.UserId = TS.UserId
LEFT JOIN EmployeeShift ES On Es.EmployeeId = E.Id  AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  )
LEFT JOIN(SELECT ShiftTimingId,[DayOfWeek],endTime FROM ShiftWeek) SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY, TS.[Date]) = SW.[DayOfWeek]
WHERE TS.UserId IN (SELECT * FROM @UsersIds) AND [Date] BETWEEN @DateFrom AND @DateTo AND Cast(SWITCHOFFSET(Ts.OutTime, '+00:00') AS time) < SW.endTime 

Insert Into #Hrstats
values(@NoOfAbsences,@NoOfUnplannedAbsences,@Latemornings,@Latelunches,@LongBreaks,@UnProductivPercentage,@IdelPercentage,@EarlyFinishes)

SELECT * FROM #Hrstats

	END TRY
BEGIN CATCH
THROW
END CATCH
END