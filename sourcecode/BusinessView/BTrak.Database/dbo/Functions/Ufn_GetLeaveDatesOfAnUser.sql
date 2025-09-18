--SELECT * FROM [dbo].[Ufn_GetLeaveDatesOfAnUser]('3E3BB0C6-F08A-4272-848C-09A0B2267FE1',NULL,NULL,'2020-10-01','2020-10-30',NULL)
CREATE FUNCTION [dbo].[Ufn_GetLeaveDatesOfAnUser]
(
	@UserId UNIQUEIDENTIFIER,
	@LeaveApplicationId UNIQUEIDENTIFIER = NULL,
	@LeaveTypeId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME,
	@DateTo DATETIME,
    @LeaveStatusId UNIQUEIDENTIFIER = NULL
)
RETURNS @LeaveDatesWithCount TABLE
(
	[Date] DATETIME,
	[Count] FLOAT,
	[LeaveApplicationId] UNIQUEIDENTIFIER,
	[LeaveReason] NVARCHAR(MAX),
	[LeaveStartTime] DATETIME,
	[LeaveEndTime] DATETIME
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
	IF (@DateTo IS NULL) SET @DateTo = GETDATE()
	IF (@DateFrom IS NULL) SET @DateTo = GETDATE()
	INSERT @LeaveDatesWithCount([Date],[Count],[LeaveApplicationId],[LeaveReason],[LeaveStartTime],[LeaveEndTime])
	SELECT T.[Date], CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN 0
			              ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			              ELSE 1 END END AS Cnt,
						  LAP.Id,
						  LAP.[LeaveReason],
						  CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN NULL
						  ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) 
						            THEN  DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,0),
										  DATEADD(MINUTE,DATEDIFF(MINUTE,T.[Date] + CAST(SW.StartTime AS DATETIME),T.[Date] + ISNULL(CAST(SW.EndTime AS DATETIME),'23:59:59')) / 2  
									                      + IIF(SW.EndTime IS NOT NULL,DATEDIFF(MINUTE,T.[Date],T.[Date] + CAST(SW.StartTime AS DATETIME)),0),T.[Date])
										  )
							    ELSE DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,0),T.[Date] + CAST(SW.StartTime AS DATETIME)) END 
						  END AS StartTime,
						  CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) THEN NULL
						  ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) 
						            THEN DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,0),
										 DATEADD(MINUTE,DATEDIFF(MINUTE,T.[Date] + CAST(SW.StartTime AS DATETIME),T.[Date] + ISNULL(CAST(SW.EndTime AS DATETIME),'23:59:59')) / 2
									              + IIF(SW.EndTime IS NOT NULL,DATEDIFF(MINUTE,T.[Date],T.[Date] + CAST(SW.StartTime AS DATETIME)),0),T.[Date])
										 )
						  ELSE DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,0),T.[Date] + ISNULL(CAST(SW.EndTime AS DATETIME),'23:59:59')) END END AS EndTime 
						  FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM MASTER..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
										   AND (@LeaveApplicationId IS NULL OR @LeaveApplicationId = LA.Id) AND (@LeaveTypeId IS NULL OR LA.LeaveTypeId = @LeaveTypeId)
										   AND (@LeaveStatusId IS NULL OR LA.OverAllLeaveStatusId = @LeaveStatusId)
				                           AND (LA.UserId = @UserId) AND (LA.LeaveDateFrom BETWEEN @DateFrom AND @DateTo OR LA.LeaveDateTo BETWEEN @DateFrom AND @DateTo)) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id 
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @CompanyId AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId
					JOIN Branch B ON B.Id = ST.BranchId
					JOIN TimeZone TZ ON TZ.Id = B.TimeZoneId
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
		    WHERE T.[Date] BETWEEN @DateFrom AND @DateTo
	RETURN
END
