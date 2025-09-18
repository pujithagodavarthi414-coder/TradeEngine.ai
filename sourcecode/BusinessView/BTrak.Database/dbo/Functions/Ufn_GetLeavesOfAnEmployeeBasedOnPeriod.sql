CREATE FUNCTION Ufn_GetLeavesOfAnEmployeeBasedOnPeriod
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@StartDate DATE,
	@EndDate DATE
)
RETURNS @LeaveEmployee TABLE
(
	EmployeeId UNIQUEIDENTIFIER,
	LeavesTaken FLOAT,
	UnplannedHolidays FLOAT,
	SickDays FLOAT,
	PlannedHolidays FLOAT,
	PaidLeaves FLOAT,
	UnPaidLeaves FLOAT
)
AS
BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @FirstHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsFirstHalf = 1 AND CompanyId = @CompanyId)
	​	
		DECLARE @SecondHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsSecondHalf = 1 AND CompanyId = @CompanyId)

		DECLARE @Leaves TABLE
		(
			UserId UNIQUEIDENTIFIER,
			EmployeeId UNIQUEIDENTIFIER,
			IsPaid BIT,
			[Count] FLOAT,
			MasterLeaveTypeId UNIQUEIDENTIFIER
		)

		INSERT INTO @Leaves
		SELECT U.Id UserId, E.Id EmployeeId,
		       T.IsPaid,
			   T.[Count],
			   T.MasterLeaveTypeId
		FROM [User] U
		     INNER JOIN Employee E ON E.UserId = U.Id
			 LEFT JOIN 
						(SELECT LAP.UserId,
						       LF.IsPaid,
							   CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
								    ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
								              ELSE 1 END END AS [Count],
							   LT.MasterLeaveTypeId
						FROM
						(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],
						        LA.Id 
						 FROM MASTER..SPT_VALUES MSPT
						 	  INNER JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL) T
						 	  INNER JOIN LeaveApplication LAP ON LAP.Id = T.Id AND T.[Date] BETWEEN @StartDate AND @EndDate
							  INNER JOIN [User] U ON U.Id = LAP.UserId
							  INNER JOIN Employee E ON E.UserId = U.Id
						 	  INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsApproved = 1
						 	  INNER JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.InActiveDateTime IS NULL
						 	  INNER JOIN LeaveFrequency LF ON LF.LeaveTypeId = LT.Id AND T.[Date] BETWEEN LF.DateFrom AND LF.DateTo AND LF.InActiveDateTime IS NULL
						 	  INNER JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
						 	  INNER JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
						 	  LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL))
						 	  LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
						 	  LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL AND H.[Date] BETWEEN @StartDate AND @EndDate
						)T ON T.UserId = U.Id
		WHERE U.CompanyId = @CompanyId AND U.IsActive = 1
		      AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)

		INSERT INTO @LeaveEmployee
		SELECT L.EmployeeId,
		       LeavesTakenQuery.LeavesTaken,
		       UnplannedHolidaysQuery.UnplannedHolidays,
		       SickDaysQuery.SickDays,
		       LeavesTakenQuery.LeavesTaken-UnplannedHolidaysQuery.UnplannedHolidays PlannedHolidays,
			   Paid.PaidLeaves,
			   UnPaid.UnPaidLeaves
		FROM @Leaves L
			 
			 LEFT JOIN (SELECT EmployeeId, ISNULL(SUM([Count]),0) AS LeavesTaken
			 	        FROM @Leaves 
			 		    GROUP BY EmployeeId) LeavesTakenQuery ON LeavesTakenQuery.EmployeeId = L.EmployeeId
			 
			 LEFT JOIN (SELECT EmployeeId, ISNULL(SUM([Count]),0) AS UnplannedHolidays
			 	        FROM @Leaves L 
			 			    INNER JOIN MasterLeaveType MLT ON (MLT.IsWithoutIntimation = 1 OR MLT.IsSickLeave = 1) AND L.MasterLeaveTypeId = MLT.Id
			            GROUP BY EmployeeId) UnplannedHolidaysQuery ON UnplannedHolidaysQuery.EmployeeId = L.EmployeeId
			 
			 LEFT JOIN (SELECT EmployeeId, ISNULL(SUM([Count]),0) AS SickDays
			 	        FROM @Leaves L 
			 			    INNER JOIN MasterLeaveType MLT ON MLT.IsSickLeave = 1 AND L.MasterLeaveTypeId = MLT.Id
			            GROUP BY EmployeeId) SickDaysQuery ON SickDaysQuery.EmployeeId = L.EmployeeId

			LEFT JOIN (SELECT EmployeeId,ISNULL(SUM([Count]),0) AS PaidLeaves FROM @Leaves WHERE IsPaid = 1 GROUP BY EmployeeId) Paid ON Paid.EmployeeId = L.EmployeeId

			LEFT JOIN (SELECT EmployeeId,ISNULL(SUM([Count]),0 ) AS UnPaidLeaves FROM @Leaves WHERE IsPaid = 0 GROUP BY EmployeeId) UnPaid ON UnPaid.EmployeeId = L.EmployeeId

		GROUP BY L.EmployeeId,LeavesTakenQuery.LeavesTaken,UnplannedHolidaysQuery.UnplannedHolidays,SickDaysQuery.SickDays,L.UserId,Paid.PaidLeaves,UnPaid.UnPaidLeaves

		RETURN

END

GO
