CREATE FUNCTION [dbo].[Ufn_GetCarryForwardAndEncashedLeavesOfAnEmployee]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@StartDate DATE,
	@EndDate DATE,
	@LeaveTypeId UNIQUEIDENTIFIER,
	@IsPreviousFrequency BIT
)
RETURNS @LeaveDetails TABLE
(
	LeaveTypeId UNIQUEIDENTIFIER,
	LeaveTypeName NVARCHAR(500),
	Leaves FLOAT,
	DateFrom DATE,
	DateTo DATE,
	CarryForwardLeavesCount FLOAT,
	EncashedLeavesCount FLOAT,
	LeavesTaken FLOAT,
	UnplannedHolidays FLOAT,
	SickDays FLOAT,
	PlannedHolidays FLOAT,
	PaidLeaves FLOAT,
	UnPaidLeaves FLOAT,
	IsPaid BIT,
	MaxEncashedLeavesCount FLOAT,
	MaxCarryForwardLeavesCount FLOAT,
	MaxCarryForwardLeavesCountYTD FLOAT
)
AS
BEGIN
	
	DECLARE @UserId UNIQUEIDENTIFIER = NULL

	SELECT @UserId = UserId FROM Employee WHERE Id = @EmployeeId

	DECLARE @ActualStartDate DATE = @StartDate, @ActualEndDate DATE = @EndDate

	IF(@IsPreviousFrequency = 1)
	BEGIN

		DECLARE @MaxDateFrom DATE

		SELECT @MaxDateFrom = MAX(DateFrom)
		FROM LeaveFrequency
		WHERE LeaveTypeId = @LeaveTypeId
		      AND DateFrom < @StartDate

		IF(@MaxDateFrom IS NOT NULL)
		BEGIN

			SELECT @StartDate = DateFrom, @EndDate = DateTo
			FROM LeaveFrequency
			WHERE LeaveTypeId = @LeaveTypeId
			      AND DateFrom = @MaxDateFrom

		END
		ELSE SELECT @StartDate = NULL, @EndDate = NULL 

	END

	DECLARE @JoinedDate DATETIME = (SELECT JoinedDate
             FROM Employee E 
             JOIN Job J ON J.EmployeeId = E.Id AND E.UserId = @UserId)

	IF(@JoinedDate > @StartDate AND @StartDate IS NOT NULL) SET @StartDate = @JoinedDate

	INSERT INTO @LeaveDetails(LeaveTypeId,Leaves,DateFrom,DateTo,CarryForwardLeavesCount,EncashedLeavesCount,IsPaid)
	SELECT LeaveTypeId, 
	       ROUND(CASE WHEN (@StartDate < DateFrom AND @EndDate > DateTo) THEN NoOfLeaves
										   	           WHEN (@StartDate >= DateFrom AND @EndDate <= DateTo) THEN (((DATEDIFF(MONTH,@StartDate,@EndDate)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * NoOfLeaves
										   	           WHEN (@StartDate < DateFrom AND @EndDate <= DateTo) THEN (((DATEDIFF(MONTH,DateFrom,@EndDate)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * NoOfLeaves
										   	           WHEN (@EndDate > DateTo AND @StartDate >= DateFrom AND @StartDate BETWEEN DateFrom AND DateTo) THEN (((DATEDIFF(MONTH,@StartDate,DateTo)) + 1)/(((DATEDIFF(MONTH,DateFrom,DateTo)) * 1.0) + 1)) * NoOfLeaves
										   	     ELSE 0
										   	     END,1) Leaves,
		   DateFrom,
		   DateTo,
		   CarryForwardLeavesCount,
		   EncashedLeavesCount,
		   IsPaid
	FROM (
	SELECT LF.LeaveTypeId,
	       LF.DateFrom,
		   LF.DateTo,
		   Job.JoinedDate,
		   LF.NoOfLeaves,
		   LF.CarryForwardLeavesCount,
		   LF.EncashedLeavesCount,
		   LF.IsPaid
	FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId) ELT 
		 INNER JOIN LeaveFrequency LF ON LF.LeaveTypeId = ELT.LeaveTypeId AND LF.InActiveDateTime IS NULL AND DATEPART(YEAR,LF.DateFrom) = DATEPART(YEAR,@EndDate) --AND (LF.IsPaid IS NOT NULL AND LF.IsPaid = 1)
		 INNER JOIN (SELECT E.UserId, MAX(J.JoinedDate) JoinedDate 
	                 FROM Job J 
				          INNER JOIN Employee E ON E.Id = J.EmployeeId
					      INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
				     WHERE J.InActiveDateTime IS NULL GROUP BY E.UserId) Job ON Job.UserId = @UserId
					 AND (@LeaveTypeId IS NULL OR LF.LeaveTypeId = @LeaveTypeId)
	) T
	WHERE (
			(@StartDate BETWEEN DateFrom AND DateTo
			AND @EndDate BETWEEN DateFrom AND DateTo)

		OR (@StartDate < DateFrom AND @StartDate < DateTo)
		)
		
	

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
		MasterLeaveTypeId UNIQUEIDENTIFIER,
		LeaveTypeId UNIQUEIDENTIFIER,
		DateFrom DATE,
		DateTo DATE
	)

	INSERT INTO @Leaves
	SELECT U.Id UserId, E.Id EmployeeId,
	       T.IsPaid,
		   T.[Count],
		   T.MasterLeaveTypeId,
		   LeaveTypeId,
		   DateFrom,
		   DateTo
	FROM [User] U
	     INNER JOIN Employee E ON E.UserId = U.Id
		 LEFT JOIN 
					(SELECT LAP.UserId,
					       LF.IsPaid,
						   CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
							    ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
							              ELSE 1 END END AS [Count],
						   LT.MasterLeaveTypeId,
						   LT.Id LeaveTypeId,
						   LF.DateFrom,
						   LF.DateTo
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
					WHERE (@LeaveTypeId IS NULL OR LF.LeaveTypeId = @LeaveTypeId)
					)T ON T.UserId = U.Id
	WHERE U.CompanyId = @CompanyId AND U.IsActive = 1
	      AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)

	DECLARE @LeaveEmployee TABLE
	(
		EmployeeId UNIQUEIDENTIFIER,
		LeaveTypeId UNIQUEIDENTIFIER,
		DateFrom DATE,
		DateTo DATE,
		LeavesTaken FLOAT,
		UnplannedHolidays FLOAT,
		SickDays FLOAT,
		PlannedHolidays FLOAT,
		PaidLeaves FLOAT,
		UnPaidLeaves FLOAT
	)

	INSERT INTO @LeaveEmployee
	SELECT L.EmployeeId,
	       L.LeaveTypeId,
		   L.DateFrom,
		   L.DateTo,
	       LeavesTakenQuery.LeavesTaken,
	       UnplannedHolidaysQuery.UnplannedHolidays,
	       SickDaysQuery.SickDays,
	       LeavesTakenQuery.LeavesTaken-UnplannedHolidaysQuery.UnplannedHolidays PlannedHolidays,
		   Paid.PaidLeaves,
		   UnPaid.UnPaidLeaves
	FROM @Leaves L
		 
		 LEFT JOIN (SELECT EmployeeId,LeaveTypeId, ISNULL(SUM([Count]),0) AS LeavesTaken
		 	        FROM @Leaves 
		 		    GROUP BY EmployeeId,LeaveTypeId) LeavesTakenQuery ON LeavesTakenQuery.EmployeeId = L.EmployeeId AND LeavesTakenQuery.LeaveTypeId = L.LeaveTypeId
		 
		 LEFT JOIN (SELECT EmployeeId,LeaveTypeId, ISNULL(SUM([Count]),0) AS UnplannedHolidays
		 	        FROM @Leaves L 
		 			    INNER JOIN MasterLeaveType MLT ON (MLT.IsWithoutIntimation = 1 OR MLT.IsSickLeave = 1) AND L.MasterLeaveTypeId = MLT.Id
		            GROUP BY EmployeeId,LeaveTypeId) UnplannedHolidaysQuery ON UnplannedHolidaysQuery.EmployeeId = L.EmployeeId AND UnplannedHolidaysQuery.LeaveTypeId = L.LeaveTypeId
		 
		 LEFT JOIN (SELECT EmployeeId,LeaveTypeId, ISNULL(SUM([Count]),0) AS SickDays
		 	        FROM @Leaves L 
		 			    INNER JOIN MasterLeaveType MLT ON MLT.IsSickLeave = 1 AND L.MasterLeaveTypeId = MLT.Id
		            GROUP BY EmployeeId,LeaveTypeId) SickDaysQuery ON SickDaysQuery.EmployeeId = L.EmployeeId AND SickDaysQuery.LeaveTypeId = L.LeaveTypeId

		LEFT JOIN (SELECT EmployeeId,LeaveTypeId,ISNULL(SUM([Count]),0) AS PaidLeaves FROM @Leaves WHERE IsPaid = 1 GROUP BY EmployeeId,LeaveTypeId) Paid ON Paid.EmployeeId = L.EmployeeId AND Paid.LeaveTypeId = L.LeaveTypeId

		LEFT JOIN (SELECT EmployeeId,LeaveTypeId,ISNULL(SUM([Count]),0 ) AS UnPaidLeaves FROM @Leaves WHERE IsPaid = 0 GROUP BY EmployeeId,LeaveTypeId) UnPaid ON UnPaid.EmployeeId = L.EmployeeId AND UnPaid.LeaveTypeId = L.LeaveTypeId

	GROUP BY L.EmployeeId,L.LeaveTypeId,L.DateFrom,L.DateTo,LeavesTakenQuery.LeavesTaken,UnplannedHolidaysQuery.UnplannedHolidays,SickDaysQuery.SickDays,L.UserId,Paid.PaidLeaves,UnPaid.UnPaidLeaves

	UPDATE @LeaveDetails SET LeavesTaken = LE.LeavesTaken,
							 UnplannedHolidays = LE.UnplannedHolidays,
							 SickDays = LE.SickDays,
							 PlannedHolidays = LE.PlannedHolidays,
							 PaidLeaves = LE.PaidLeaves,
							 UnPaidLeaves = LE.UnPaidLeaves
	FROM @LeaveDetails LD LEFT JOIN @LeaveEmployee LE ON LD.LeaveTypeId = LE.LeaveTypeId

	UPDATE @LeaveDetails SET MaxEncashedLeavesCount = ROUND((CASE WHEN  ISNULL(Leaves,0) - ISNULL(PaidLeaves,0) > ISNULL(EncashedLeavesCount,0) THEN ISNULL(EncashedLeavesCount,0) ELSE ISNULL(Leaves,0) - ISNULL(PaidLeaves,0) END),2)
	
	UPDATE @LeaveDetails SET MaxCarryForwardLeavesCount = ROUND((CASE WHEN  ISNULL(Leaves,0) - ISNULL(PaidLeaves,0) > ISNULL(CarryForwardLeavesCount,0) THEN ISNULL(CarryForwardLeavesCount,0) ELSE ISNULL(Leaves,0) - ISNULL(PaidLeaves,0) END),2)

	UPDATE @LeaveDetails SET LeaveTypeName = LT.LeaveTypeName
	FROM LeaveType LT INNER JOIN @LeaveDetails LD ON LD.LeaveTypeId = LT.Id

	UPDATE @LeaveDetails SET MaxCarryForwardLeavesCountYTD = ROUND((((MaxCarryForwardLeavesCount * 1.0)/(DATEDIFF(MONTH,@ActualStartDate,@ActualEndDate) + 1.0)) * (DATEDIFF(MONTH,@ActualStartDate,CAST(GETDATE() AS DATE)) + 1.0)),2)

	RETURN
END
