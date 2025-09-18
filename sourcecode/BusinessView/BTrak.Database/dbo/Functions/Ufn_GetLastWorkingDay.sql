CREATE FUNCTION Ufn_GetLastWorkingDay
(
	@CompanyId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
RETURNS Date
BEGIN

	DECLARE @Date  DATE = (SELECT [Date] FROM(SELECT TOP 1   CAST(DATEADD( DAY,-(number + 1),GETUTCDATE()) AS date) [Date]
	                      FROM master..spt_values WHERE Type = 'P'
						  AND CAST(DATEADD( DAY,-(number+1),GETUTCDATE()) AS date) IN (SELECT CAST(DATEADD( DAY,-(number + 1),GETUTCDATE()) AS date) FROM Employee E 
						INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL AND E.UserId = @OperationsPerformedBy
				        INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
				        INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW, CAST(DATEADD( DAY,-(number + 1),GETUTCDATE()) AS date)))
                        GROUP BY  CAST(DATEADD( DAY,-(number+1),GETUTCDATE()) AS date)
	                    HAVING    (CAST(DATEADD( DAY,-(number+1),GETUTCDATE()) AS date) NOT IN  
	                    (SELECT [Date] FROM Holiday WHERE CompanyId = @CompanyId )))T)

	RETURN @Date	

END
GO

