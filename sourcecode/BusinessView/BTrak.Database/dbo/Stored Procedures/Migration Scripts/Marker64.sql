CREATE PROCEDURE [dbo].[Marker64]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[CustomWidgets] AS Target 
		USING ( VALUES 
		(@CompanyId,'This app provides the training compliance percentages of a course.Users can download the information in the app and can change the visualization of the app','Training Compliance Percentage')
		,(@CompanyId,'This app provides the current month, last 30 days and last 60 days created actions based on action creation date.Users can download the information in the app and can change the visualization of the app','Actions')
		,(@CompanyId,'This app is the graphical representation of  expenses related to the whole company segregated by category. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Approved category wise expenses')
		,(@CompanyId,'This app provides the audits which are completed and its completion percentage .Users can download the information in the app and can change the visualization of the app and they can filter data in the app','Audit Completion Percentage')
		,(@CompanyId,'This app provides the compliance percentage of  all audits conducted in the company.Users can download the information in the app and can change the visualization of the app and they can filter data in the app','Audit Compliance Percentage')
		,(@CompanyId,'This app provides the list of audit conducts and its corresponding status. Users can download the information in the app and can change the visualization of the app and they can filter data in the app','Audit Conduct Status')
		,(@CompanyId,'This app provides an overview of the audits, it highlights the audits which are not submitted. Users can download the information in the app and can change the visualization of the app and they can filter data in the app','Audit Immediate Priorities')
		,(@CompanyId,'This app provides the last period and this period audit conducts count.Users can download the information in the app and can change the visualization of the app and they can filter data in the app','Audit Progress Tracker')
		,(@CompanyId,'This app provides the not started, in progress and submitted audits count.Users can download the information in the app and can change the visualization of the app and they can filter data in the app	','Audits Due')
		,(@CompanyId,'This app displays the completion  percentage of user stories as a part of induction across the company. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Completed induction stories percentage')
		,(@CompanyId,'This app displays the completed induction stories count vs total assigned induction stories count across the company. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Completed vs total induction stories')
		,(@CompanyId,'This app provides the leaves that are applied for that day across all the employees in the company irrespective of the leave status. Users can download the information in the app and can change the visualization of the app','Day Wise Leave Transaction Report')
		,(@CompanyId,'This app is the graphical representation of the employees who took lunch break more than an hour. It display data related to the logged in employee for each day. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Employee Afternoon Late Report')
		,(@CompanyId,'This app is the graphical representation of the employee leaves across the company highlighting with different colour indications for full day leave, half day leave and working day.Users can download the information in the app and can change the visualization of the app.','Employee Leaves Report')
		,(@CompanyId,'This app is the graphical representation of the employees who came late to the office in the morning session It display data related to the logged in employee for each day. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Employee Morning Late Report')
		,(@CompanyId,'This app is the graphical representation of the logged in employee break timings for each day in the selected period. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Employee Office Break Time Report')
		,(@CompanyId,'This app is the graphical representation of the logged in employee spent time of each day in the selected period. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Employee Office Spent Time Report')
		,(@CompanyId,'This app provides the graphical representation of the planned rate and actual rates of the roster plans on x-axis and the employee on y-axis.Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Employee wise planned vs actual rates')
		,(@CompanyId,'This app provides monthly ESI summary of the employees based on their designation with details like Salary, Employee contribution, Employer contribution, Employer contribution as per the ESI Portal and Total contribution .Users can download the information in the app and can change the visualization of the app','ESI Monthly Summary Report')
		,(@CompanyId,'This app provides the details of the employee''s whose salary was kept on hold with some reason.Users can download the information in the app and can change the visualization of the app','Hold Salary Report')
		,(@CompanyId,'This app provides the details of Income tax for selected month like employee name, date of joining, taxable income , PAN number and Income tax. Users can download the information in the app and can change the visualization of the app','Income Tax Monthly Statement')
		,(@CompanyId,'This app provides the details of the employees who have IT savings included . Users can download the information in the app and can change the visualization of the app','IT Savings Report')
		,(@CompanyId,'This app provides the list of employees whose joining date was in the current month and also with the details like Name, Mobile number, Email, Joining date and Experience.Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Joining Anniversary Report')
		,(@CompanyId,'This app provides the list of leaves used by the employees with details like employee name, leave type, from and to dates of leave, No.of days, Reason, Applied and Approved dates, Approver.Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Leave Availed Report')
		,(@CompanyId,'This app provides the list of leaves applied by the employees after taking the leave with details like employee name, leave type, from and to dates of leave, No.of days, Reason, Applied and Approved dates, Approver.Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Leave Backdated Report')
		,(@CompanyId,'This app provides the list of leaves taken by the employees and the remaining leaves they can encash with further details. Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Leave Encashment Report')
		,(@CompanyId,'This app provides year wise leave summary in selected year for all the employees in the company. Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Leave Summary Report')
		,(@CompanyId,'This app provides the leaves transaction of the employees with details like employee name, leave type, from and to dates of leave, No.of days, Reason, Applied and Approved dates, Approver.Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Leave Transaction Report')
		,(@CompanyId,'This app is the graphical representation of the employees who kept leaves on Monday. It display data related to the logged in employee for each day. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Monday Leave Report')
		,(@CompanyId,'This app provides negative leave balance of employees in given date range.Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Negative Leave Balance Report')
		,(@CompanyId,'This app provides the graphical representation of the spent time and productive time for the current day.Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Office spent Vs productive time')
		,(@CompanyId,'This app provides the graphical representation of the planned rate and actual rates of the roster plans date wise .Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Plan vs Actual rate date wise')
		,(@CompanyId,'This app provides the graphical representation of the burned planned and actual rates for the roster plans.Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Planned and actual burned  cost')
		,(@CompanyId,'This app provides the list of employees with their corresponding Proof of Investment Declarations and with its details.Users can download the information in the app and can change the visualization of the app','Proof of Investment Declaration Report')
		,(@CompanyId,'This app displays the count of canteen purchases done by the logged in user.Users can download the information in the app and can change the visualization of the app.','Purchases this month')
		,(@CompanyId,'This app provides the Salary report in given date range with the salary details like HRA, Bonus, prof tax and other allowances etc.Users can download the information in the app and can change the visualization of the app and they can filter the data in the app.','Quick Salary Report')
		,(@CompanyId,'This app provides the graphical representation of the planned rate and actual rates of the roster plans on x-axis and the shift on y-axis.Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Shift wise spent amount')
		
		,(@CompanyId,'This app is the graphical representation of the employees who kept sick leaves. It display data related to the logged in employee for each day. Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Sick Leave Report')
		,(@CompanyId,'This app displays the count of work items which are assigned to the logged in user with deadline of today.Users change the visualization of the app and they can filter the data in the app','Today''s target')
		
		,(@CompanyId,'This app provides the graphical representation of the planned rate and actual rates of the roster plans week wise .Users can download the information in the app and can change the visualization of the app and they can filter data in the app.','Week wise roster plan vs actual rate')
		,(@CompanyId,'This app provides year wise leave summary in selected year for all the employees in the company. Users can download the information in the app and can change the visualization of the app and they can filter the information in the app','Year Wise Leave Summary Report')
		)
	AS Source (CompanyId,[Description], customWidgetName) 
	ON Target.customWidgetName = Source.customWidgetName 
	AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN 
	UPDATE SET [Description] = Source.[Description];

	



MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Yesterday late people count','','SELECT F.[Late people count] FROM
								(SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN
								          
										  (SELECT [Date],COUNT(CASE WHEN CAST(TS.InTime AS TIME) > Deadline THEN 1 END)[Morning late],COUNT(1)TotalCount FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
											   WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 
											                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Night late people count','','SELECT COUNT(1)[Night late people count] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	         WHERE CAST(TS.[Date] AS date)  = CAST(DATEADD(DAY,-1,GETDATE()) AS date)AND  cast(OutTime as time) >= ''16:30:00.00''
			 AND CompanyId =(SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy''  AND InActiveDateTime IS NULL)',@CompanyId,@UserId,GETDATE())
)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];				

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday late people count'),
'Late people count', 'nvarchar', 
'SELECT T.Date,T.EmployeeName  ,DATEADD(minute,(DATEPART(tz,T.Intime)),CAST(T.Intime AS Time)) Intime ,T.Deadline  
FROM (SELECT [Date],U.FirstName+'' ''+U.SurName EmployeeName  ,TS.Intime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as Intime  ,Deadline FROM TimeSheet TS
JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL  LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId  INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL  INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE())) 
WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND CAST(TS.InTime AS TIME) > Deadline AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.Id = Source.Id
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

END
GO