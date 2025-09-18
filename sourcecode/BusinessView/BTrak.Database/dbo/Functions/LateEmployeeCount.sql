CREATE FUNCTION [dbo].[LateEmployeeCount]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @returntable TABLE
(
	Late INTEGER 
)
AS
BEGIN
	DECLARE @Late INT = 0;

	 IF((SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy) > 0)
			BEGIN
						select @Late = COUNT(1) from TimeSheet TS
						            INNER JOIN [User] U ON U.id = TS.UserId AND U.CompanyId = @CompanyId AND U.Id <> @OperationsPerformedBy
									INNER JOIN Employee E ON E.UserId = TS.UserId
									INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
						            LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
									LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
									LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
									WHERE SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
									       AND TS.[Date] = (SELECT MAX([Date]) FROM TimeSheet WHERE UserId = @OperationsPerformedBy)
			
			END
		
		ELSE 
			BEGIN
				select @Late = COUNT(1) from TimeSheet TS
						            INNER JOIN [User] U ON U.id = TS.UserId AND U.CompanyId = @CompanyId
									INNER JOIN Employee E ON E.UserId = TS.UserId
									INNER JOIN (SELECT ChildId AS Child 
				                          FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
				                          GROUP BY ChildId
				                          ) T ON T.Child = U.Id AND U.InActiveDateTime IS NULL AND T.Child <> @OperationsPerformedBy
									INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
						            LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
									LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
									LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
									WHERE SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
									       AND TS.[Date] = (SELECT MAX([Date]) FROM TimeSheet WHERE UserId = @OperationsPerformedBy)
			END
		INSERT INTO @returntable VALUES(@Late)
	RETURN
END
