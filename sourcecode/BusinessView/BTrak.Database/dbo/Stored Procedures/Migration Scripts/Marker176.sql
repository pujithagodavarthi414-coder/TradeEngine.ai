CREATE PROCEDURE [dbo].[Marker176]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
   
     UPDATE CustomWidgets SET WidgetQuery = 'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
		       INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		       INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.Date)
			  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND cast(SE.ExceptionDate as date) = CAST(TS.Date as date) AND SE.InActiveDateTime IS NULL
			 WHERE CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
					 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					AND U.CompanyId = ''@CompanyId''         
	             GROUP BY TS.[Date],U.FirstName, U.SurName ,U.Id' WHERE CustomWidgetName = 'Morning late employees' AND CompanyId =   @CompanyId
   
END