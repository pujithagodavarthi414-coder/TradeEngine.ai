CREATE PROCEDURE [dbo].[Marker244]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT(T.Date,''MMM yyyy'') AS [Date],SUM(ISNULL([Employees Count],0)) [Employees Count]
                , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
                FROM(SELECT  CAST(DATEADD( MONTH,number,CAST(ISNULL(@DateFrom,DATEADD(YEAR,-1,GETDATE()))  AS date)) AS date) [Date]         
               FROM master..spt_values
               WHERE Type = ''P'' and number between 1 
               and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(YEAR,-1,GETDATE()))  AS date), 
               CAST(ISNULL(@DateTo,GETDATE()) AS date)))T LEFT JOIN	
                ( SELECT COUNT(1)[Employees Count] ,FORMAT(U.RegisteredDateTime,''MMM yyyy'') RegisterDate 
                FROM [User] U INNER JOIN [Employee]E ON E.UserId = U.Id   
               INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()) 
               Where U.CompanyId = ''@CompanyId''
               AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
               GROUP BY FORMAT(U.RegisteredDateTime,''MMM yyyy''))Z ON Z.RegisterDate = FORMAT(T.Date,''MMM yyyy'')
                GROUP BY  FORMAT(T.Date,''MMM yyyy''),T.Date' WHERE CustomWidgetName = 'Employees Count Vs Join Date' AND CompanyId = @CompanyId

 UPDATE CustomWidgets SET WidgetQuery = 'SELECT U.FirstName+ '' ''+U.SurName [Employe eName] ,ISNULL(SUM(PlannedRate),0)[Planned Rate],ISNULL(SUM(ActualRate),0)[Actual Rate]
 FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND RAP.InActiveDateTime IS NULL
                                   AND E.InActiveDateTime  IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
								   INNER JOIN [USER]U ON U.Id  = E.UserId AND U.InActiveDateTime IS NULL
 WHERE CAST(PlanDate AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date)
    AND CAST(PlanDate AS date)<= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = ''@CompanyId''
 GROUP BY U.FirstName+ '' ''+U.SurName' WHERE CustomWidgetName = 'Employee Wise Planned Vs Actual Rates' AND CompanyId = @CompanyId
 UPDATE CustomWidgets SET WidgetQuery = 'SELECT ShiftName [Shift Name],SUM(ISNULL(PlannedRate,0))[Planned Rate],SUM(ISNULL(ActualRate,0))[Actual Rate]
FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND E.InActiveDateTime IS NULL
                                              AND RAP.InActiveDateTime IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
                                     INNER JOIN [User]U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
									 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
									 INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
							      WHERE PlanDate >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date)
								   AND PlanDate <=  ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))
						  AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						   GROUP BY ShiftName' WHERE CustomWidgetName = 'Shift Wise Spent Amount' AND CompanyId = @CompanyId
 UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT(T.Date,''dd MMM yyyy'') AS Date,PlannedRate = ISNULL((SELECT  SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date
	 AND PlanDate <= IIF( CAST(DATEADD(DAY,6,T.Date) AS Date) > CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AS Date),CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AS Date),CAST(DATEADD(DAY,6,T.Date) AS Date) )
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 )),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))T' 
	WHERE CustomWidgetName = 'Week wise roster plan vs actual rate' AND CompanyId = @CompanyId

END