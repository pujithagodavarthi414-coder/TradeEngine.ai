CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterRatesWithTimeSheetData]
(
	@RunStartDate DATE,
	@RunEndDate DATE,
	@EmployeeIds NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	DECLARE  @EmployeeSalaryWithAllowances TABLE
	(
		Id INT,
		EmployeeId UNIQUEIDENTIFIER,
		[Date] DATE,
		StartTime DATETIME,
		EndTime DATETIME,
		FinalRate float
	)

	DECLARE @DATES TABLE
	(
		Id INT IDENTITY(1,1),
		ApproveDate DATETIME
	)

	;WITH DateRange(DateData) AS 
	(
	    SELECT @RunStartDate as Date
	    UNION ALL
	    SELECT DATEADD(d,1,DateData)
	    FROM DateRange 
	    WHERE DateData < @RunEndDate
	)

	INSERT INTO @DATES
	SELECT *FROM DateRange

	DECLARE @Counter INT = 1, @Max INT, @Date DATETIME
	SELECT @Max = MAX(Id) FROM @DATES

	

	WHILE (@Counter <= @Max)
	BEGIN
		SELECT @Date = ApproveDate FROM @DATES WHERE Id = @Counter

		INSERT INTO @EmployeeSalaryWithAllowances
		EXEC [USP_GetHourlyEmployeeRates] @OperationsPerformedBy,@Date,@Date,@EmployeeIds

		SET @Counter = @Counter + 1
	END

	UPDATE R SET ActualFromTime = E.StartTime,
				ActualToTime = E.EndTime,
				ActualRate = E.FinalRate
	FROM RosterActualPlan R
	INNER JOIN @EmployeeSalaryWithAllowances E ON E.[Date] = convert(date, R.PlanDate) AND E.EmployeeId = R.ActualEmployeeId

	UPDATE RAP SET
		ActualFromTime = NULL,
		ActualToTime = NULL,
		ActualRate = NULL
	FROM TimeSheetPunchCard T
	INNER JOIN [USER] U ON T.USERID = U.ID
	INNER JOIN EMPLOYEE E ON E.USERID = U.ID
	INNER JOIN RosterActualPlan RAP ON T.[Date] = convert(date, RAP.PlanDate) AND E.ID = RAP.ActualEmployeeId
	WHERE T.Date BETWEEN @RunStartDate AND @RunEndDate
	AND (@EmployeeIds IS NULL OR E.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@EmployeeIds)))
	AND T.IsOnLeave = 1

END