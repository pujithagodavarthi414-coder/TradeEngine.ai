CREATE FUNCTION [dbo].[Ufn_CheckYetToDateLeaves]
(
 @LeaveApplicationId  UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN

    DECLARE @Status NVARCHAR(100)

    DECLARE @LeaveTypeId UNIQUEIDENTIFIER,@UserId UNIQUEIDENTIFIER,@FromLeaveSessionId UNIQUEIDENTIFIER,@ToLeaveSessionId UNIQUEIDENTIFIER,@IsPaid BIT,@TotalLeaves FLOAT
    ,@LeaveDateFrom DATE,@LeaveDateTo DATE,@DateFrom DATE,@DateTo DATE,@YtdLeaves FLOAT,@NoOfDays FLOAT,@LeavesTaken FLOAT,@CompanyId UNIQUEIDENTIFIER

    SELECT @LeaveTypeId = LeaveTypeId
          ,@UserId = UserId
          ,@LeaveDateFrom = LeaveDateFrom
          ,@LeaveDateTo = LeaveDateTo
          ,@FromLeaveSessionId = FromLeaveSessionId
          ,@ToLeaveSessionId = ToLeaveSessionId FROM LeaveApplication WHERE Id = @LeaveApplicationId
	
	SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

	SET @IsPaid = (SELECT IsPaid FROM LeaveFrequency WHERE LeaveTypeId = @LeaveTypeId AND InActivedatetime IS NULL AND @LeaveDateFrom BETWEEN DateFrom AND DateTo)

    IF(@IsPaid = 1)
	BEGIN
    
		SELECT @DateFrom = DateFrom,@DateTo = DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@UserId,DATEPART(YEAR,@LeaveDateFrom))

		SET @LeavesTaken = ISNULL((SELECT SUM(LeavesTaken) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,@LeaveTypeId,@DateFrom,@DateTo)),0)

		SET @YtdLeaves = ISNULL((SELECT [dbo].[Ufn_GetEmployeeYTDLeaves](@UserId,DATEPART(YEAR,@LeaveDateFrom),NULL)),0)

		SET @NoOfDays = (SELECT ISNULL(SUM(Total.Cnt),0) AS Cnt FROM 
		                             (SELECT CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                                          ELSE CASE WHEN (T.[Date] = @LeaveDateFrom AND FLS.IsSecondHalf = 1) OR (T.[Date] = @LeaveDateTo AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                                          ELSE 1 END END AS Cnt FROM
			                          (SELECT DATEADD(DAY,NUMBER,@LeaveDateFrom) AS [Date]
			                                  FROM MASTER..SPT_VALUES MSPT
			                          	    WHERE [type]='p' AND number <= DATEDIFF(DAY,@LeaveDateFrom,@LeaveDateTo)) T
			                          	    JOIN LeaveType LT ON LT.Id = @LeaveTypeId AND LT.CompanyId = @CompanyId AND LT.InActiveDateTime IS NULL
			                          	    JOIN LeaveSession FLS ON FLS.Id = @FromLeaveSessionId
			                          	    JOIN LeaveSession TLS ON TLS.Id = @ToLeaveSessionId
			                          		JOIN Employee E ON E.UserId = @UserId AND E.InActiveDateTime IS NULL
			                          		LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
			                          		LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
			                          	    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
		                              WHERE T.[Date] BETWEEN @LeaveDateFrom AND @LeaveDateTo)Total)
		
		IF((@NoOfDays) > @YtdLeaves)
		BEGIN

			SET @Status = 'RestrictionCrossed'

		END
		ELSE

			SET @Status = '1'

	END
	ELSE

		SET @Status = '1'

	RETURN @Status
END
