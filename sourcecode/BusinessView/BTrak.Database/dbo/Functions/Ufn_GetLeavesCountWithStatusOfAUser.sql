--SELECT * FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser]('0B2921A9-E930-4013-9047-670B5352F308','2020-01-01','2020-12-31',NULL,NULL,'29BA7038-B0A6-48A1-B448-10ADA7AF3C23')
CREATE FUNCTION [dbo].[Ufn_GetLeavesCountWithStatusOfAUser]
(
	@UserId UNIQUEIDENTIFIER,
	@DateFrom DATETIME,
	@DateTo DATETIME,
	@LeaveApplicationId UNIQUEIDENTIFIER = NULL,
	@LeaveTypeId UNIQUEIDENTIFIER = NULL,
	@LeaveStatusId UNIQUEIDENTIFIER = NULL
)
RETURNS @returntable TABLE
(
	UserId UNIQUEIDENTIFIER,
	LeaveStatusId UNIQUEIDENTIFIER,
	LeaveStatus NVARCHAR(100),
	Cnt FLOAT
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
	INSERT INTO @returntable
	SELECT LS.UserId,LS.Id AS OverallLeaveStatusId,LS.LeaveStatusName,ISNULL(SUM(Total.Cnt),0) AS Cnt FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM MASTER..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
										   AND (@LeaveApplicationId IS NULL OR @LeaveApplicationId = LA.Id) AND (@LeaveTypeId IS NULL OR LA.LeaveTypeId = @LeaveTypeId)
				                           AND (LA.UserId = @UserId) AND (LA.LeaveDateFrom BETWEEN @DateFrom AND @DateTo OR LA.LeaveDateTo BETWEEN @DateFrom AND @DateTo)) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id 
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @CompanyId AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
		    WHERE T.[Date] BETWEEN @DateFrom AND @DateTo)Total
			RIGHT JOIN (SELECT @UserId AS UserId,Id,
			            CASE WHEN IsApproved = 1 THEN 'Approved'
						     WHEN IsWaitingForApproval = 1 THEN 'WaitingForApproval'
							 WHEN IsRejected = 1 THEN 'Rejected' END
							 AS LeaveStatusName FROM LeaveStatus WHERE CompanyId = @CompanyId AND (@LeaveStatusId IS NULL OR Id = @LeaveStatusId)) LS ON LS.Id = Total.OverallLeaveStatusId AND LS.UserId = Total.UserId
			
			GROUP BY LS.UserId,LS.Id,LS.LeaveStatusName
	RETURN
END