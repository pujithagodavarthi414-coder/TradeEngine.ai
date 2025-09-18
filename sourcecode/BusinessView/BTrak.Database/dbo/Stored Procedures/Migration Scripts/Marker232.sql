CREATE PROCEDURE [dbo].[Marker232]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES

(
 
NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon Late Trend Graph '),'Afternoon late count', 'int', 'SELECT FORMAT(TS.[Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),
SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) - 70 [Late in mins]    FROM TimeSheet TS 
INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL   
 WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))   
  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)     AND FORMAT(TS.Date,''dd MMM yyyy'') = CAST(''##Date##'' AS DATE)    
GROUP BY FORMAT(TS.[Date],''dd MMM yyyy''),LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurName   
 HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time'),'Date', 'nvarchar', 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name],CAST(TS.OutTime AS time(0))[Out time]FROM TimeSheet TS 
JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL        
 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 		 		
  WHERE   FORMAT(TS.[Date],''dd MMM yyyy'') =''##Date##''				
  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =''@OperationsPerformedBy''			
  	AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time'),'Avg exit time', 'time', 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name],CAST(TS.OutTime AS time(0))[Out time]FROM TimeSheet TS 
	JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL         
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 		 		
	 WHERE   FORMAT(TS.[Date],''dd MMM yyyy'') = ''##Date##''			
	 	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =''@OperationsPerformedBy''			
		AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph'),'Morning late', 'int', ' SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+u.SurName EmployeeName,Cast(TS.InTime as time)InTime,Deadline FROM TimeSheet TS 
 JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL	                                         
   INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 										
   	   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL											
	      INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId										
		  	   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])											
			      WHERE FORMAT(cast(TS.[Date] as date),''dd MMM yyyy'') = ''##Date##'' and CAST(TS.InTime AS TIME) > Deadline									
				  		  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)



	)
 
   AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND  Target.[CompanyId] = Source.[CompanyId]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden];
           


	
END