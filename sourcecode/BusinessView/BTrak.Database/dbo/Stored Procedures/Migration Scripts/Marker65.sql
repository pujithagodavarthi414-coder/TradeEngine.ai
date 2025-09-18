CREATE PROCEDURE [dbo].[Marker65]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
   INSERT INTO [dbo].[RoleFeature]
           ([Id]
           ,[RoleId]
           ,[FeatureId]
           ,[CreatedDateTime]
           ,[CreatedByUserId]
           )
     VALUES
           (NewId()
           ,@RoleId
           ,'C18522C7-81F5-460E-93C6-E830F5848869'
           ,GETDATE()
           ,@UserId
           )

	Update CustomWidgets SET Filters = '' 
	WHERE CustomWidgetName IN ('Canteen bill', 'Canteen Credited this month', 'Canteen Items count', 
							   'Purchases this month', 'This month credited employees', 'This month purchased employees', 'Branch wise food order bill',
							   'Food orders', 'Yesterday food order bill', 'This month food orders bill', 'This month orders count')


	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
        (NEWID(), N'This app is used to display the list of pending expenses list and one can approve all the pending expenses at a time.',N'Pending expenses', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
        (NEWID(), N'This app is used to display the list of approved expenses list and user can download the approved expenses in excel format.',N'Approved expenses', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        )
	AS Source ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.Id = Source.Id 
	WHEN MATCHED THEN 
	UPDATE SET [WidgetName] = Source.[WidgetName],
			   [Description] = Source.[Description],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CompanyId] =  Source.[CompanyId],
	           [UpdatedDateTime] =  Source.[UpdatedDateTime],
	           [UpdatedByUserId] =  Source.[UpdatedByUserId],
	           [InActiveDateTime] =  Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	VALUES ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

	MERGE INTO [dbo].[Widget] AS Target 
		USING ( VALUES 
		(@CompanyId,'This app gives an overview of the information tracked through activity tracker with the details like employee productivity, break timings with colour indications. Users can filter the information based on date ranges, department, branch and employees.','Activity tracker bryntum view')
		,(@CompanyId,'By using this app user can manage the allowance time for different rate sheets with details like Branch name, allowance time, Min and Max times and Active From and To dates. Users can filter the data and can change the vizualization of the app.','Allowance time')
		,(@CompanyId,'This app used to view the announcements passed and also user can send announcements across the company or for specific branches or for specific employesss. User can edit and delete the current announcements. ','Announcements')
		,(@CompanyId,'This app gives you the overall activity of assets. It gives some additional information like when and by whom the actions are taken on assets. Any asset details updated or added or marked as damaged or assigned to someone else will be recorded in this app.','Assets comments and history')
		,(@CompanyId,'This app displays the total number of complaint audits and users can navigate to each individual audit conduct pages to view the compliant answers in the audit conduct.','Audit compliance')
		,(@CompanyId,'By using this app user can manage the badges. User can create new badges, view the badges list and can edit and delete badges. Users can sort and search badges from the list.','Badges')
		,(@CompanyId,'By using this app users can award badges to the employees and also it displays the badges earned by the logged in employee with details like awarded by name.','Badges earned')
		
		,(@CompanyId,'By using this app user can add comments and the added comments will be displayed as a list  with details like when and who commented.','Comments app')
		 ,(@CompanyId,'By using this app user can update the details of the logged in user company details.','Company details')
		
		,(@CompanyId,'This app is to manage the days of a week for different branches with details like week day, parts of day, Is weekend, From and To times, Active from and Active to dates. Users can search and sort the details in the app and they can edit and archive the records in the app.','Days of week configuration')
		,(@CompanyId,'This app allows to view the document templates and allows to generate the templates based on the selected user. Users can also sort the templates.','Document Templates')
		,(@CompanyId,'By using this app user can organise folders and subfolders and they can upload files into the corresponding folders. They can manage all the documents and can preview and download the documents.','Documents')
		,(@CompanyId,'Once a loan is approved, user can view loan installments with the details like Principal amount, Installment amount, Installment date, Is to be paid and also user can download the employee loan statements.','Employee loan installment')
		,(@CompanyId,'By using this app user can manage employee loans. User can add details like employee,loan amount,loan type,perios type etc details. User can also edit these details. Also managers can approve or reject the applied employee loans. Users can sort and search data in the app.','Employee loans')
		,(@CompanyId,'By using this app user can see all the resigned employees of the company, User can add resignation and archive , edit the resignation details.Also users can view the archived resigned employees and can search and sort the resigned employees from the list.','Employee resignation')
		,(@CompanyId,'This app displays the list of employees who gave resignation and their corresponding resignation status with details like employee name, Resignation date, Last date, Approved date,  Resignation rejected date and  Resignation status and comments. Users can search and sort information in this app.','Employee resignation details')
		,(@CompanyId,'This app allows to view the tax allownace details of all the employees in the company for the selected year with some additional information. User can sort and search information and can reset the applied filters','Employee tax allowance details')
		,(@CompanyId,'This app provides the information of monthly ESI statement of all the employees segragated by branch. User can search and sort information in the app. They can filter the data and they can download the information into an excel.','ESI monthly statement')
		,(@CompanyId,'This app provides the informationrelated to ESI of employees with details like IP Number, IP Name, Number of days for which wages paid, total monthly wages, last working day etc. User can search and sort information in the app. They can filter the data and they can download the information into an excel.','ESI of employees')
		
		,(@CompanyId,'By using this users can view the list of estimates with details like estimate number, client name, estimate amount, estimate status, issue date and due date. User can also add estimates and they can search and sort information in the app.','Estimates')
		,(@CompanyId,'This app provides the graphical represenation of the targeted and achieved productivity details for the day.','Everyday target details')
		
		,(@CompanyId,'By using this app we can create new forms by selecting the application and forms. Users can also change the applications and forms.','Forms')
		,(@CompanyId,'This app provides the overall activity of the goal. Users can filter the goal activity based on employee, work item and log time and can set reset the filters applied.','Goal activity')
		,(@CompanyId,'This app is the graphical representation with start and end dates of the goal on x-axis and the userstory points on y-axis. This is an indicator for goal completion. Users can filter the data based on employee, From and to dates and they can reset the applied filters.','Goal burn down chart')
		,(@CompanyId,'This app provides the activity related to the goal replan with its corresponding details','Goal replan history')
		,(@CompanyId,'By using this app user can see all the  goal replan types for the site and you can edit the goal replan type.Also users can can search and sort the goal replan type from the list.','Goal replan type')
		,(@CompanyId,'By using this app user can manage the tax percentages for hourly payroll employees with further details like Branch, Max limit, Tax percentage, Active from and to dates.User can also edit these details. Users can search and sort information in this app.','Hourly tds configuration')
		,(@CompanyId,'This app provides the information of  employee income with the employee details and  the monthly income for the selected date range. User can filter the information using advanced search and also user can download the information into excel','Income salary statement')
		,(@CompanyId,'This app provides the list of invoice statuses and its status color and user can also filter information in this app.','Invoice status')
		,(@CompanyId,'This app provides the list of invoices with its corresponding details and status. Users can download and send invoices with this app and they can sort and search information in this app.','Invoices')
		,(@CompanyId,'By using this app user can see all the  job categories for the company,can add job category,archive job category and edit  the job category.Also users can view the archived job category and can search and sort the job category from the list.','Job category')
		,(@CompanyId,'By using this app user can see all the  languages for the company,can add,archive and edit the languages.Also users can view the archived languages and can search and sort the languages from the list.','Languages')
		,(@CompanyId,'By using this app user can see all the leave encashment settings for the company, can add, archive and edit the leave encashment settings.Also users can view the archived leave encashment settings and can search and sort the leave encashment settings from the list.','Leave encashment settings')
		,(@CompanyId,'By using this app user can see all the  Leave formulas for the company,can add,archive and edit the Leave formula.Also users can view the archived Leave formula and can search and sort the Leave formula from the list.','Leave formula')
		,(@CompanyId,'By using this app user can see all the  leave session for the company,can add leave session and edit the leave session.Also users can search and sort the leave session from the list.','Leave session')
		,(@CompanyId,'By using this app user can see all the  leave statuses for thecompany, edit the leave status.Also users can search and sort the leave status from the list.','Leave status')
		,(@CompanyId,'This app gives the overview of eligible leaves, eligible leaves YTD, leaves taken, Onsite leaves, Work from home leaves, Unplanned leaves, Paid leaves and Unpaid leaves of the current year for all the employees in the company.','Leaves report')
		,(@CompanyId,'By using this app user can see all the license types for the company,can add license type and edit the license type.Also users can view the archived license type and can search and sort the license type from the list.','License type')
		,(@CompanyId,'By using this app user can see all the  main use cases for the company,can add main use case and edit the main use case.Also users can view the archived main use case and can search and sort the main use case from the list.','Main use case')
		,(@CompanyId,'This app provides the list of master question types related to the audits and users can search and sort the master question types.','Master question type')
		,(@CompanyId,'By using this app user can signup and signin into the meet and can organise the meetings within this app.','Meet')
		,(@CompanyId,'By using this app user can see all the memberships for the comapny,can add memberships and edit the memberships.Also users can view the archived memberships and can search and sort the memberships from the list.','Memberships')
		,(@CompanyId,'This app displays organizational design in a diagram that visually conveys a companys internal structure by detailing the role, responsibilities, and relationships between individuals within an entity. This chart broadly depict an enterprise company-wide and drill down to a specific department or unit','Organization chart')
		,(@CompanyId,'By using this app user can configure the peak hours for the days of week, start and end time for that day. User should be able edit and archive the peak hours. User should be able to search and sort information in the app.','Peak hour')
		,(@CompanyId,'This app provides the information related to PF of all the employees in the company with details like UAN, Member name, Gross wages, EPF Wages, EPS Wages, EDLI Wages, EPF Contribution, EPS Contribution, EPF EPS Diff, NCP Days and Refund of Advance. User can filter the data and they can download the information in the app.','PF of employees')
		,(@CompanyId,'This app displays the graphical representation by conidering Months on x-axis and productivity of all the employees on y-axis.  Users can filter the data based on employee and date range and can reset the applied filters.','Productivity report')
		,(@CompanyId,'This app displays the information related to professional tax of  all  the employees with details like Employee number, Employee name, Basic professional tax and Amount. It also displays the professional tax ranges and the corresponding employees count in each tax range. User can filter the information and can download the informtion into an excel.','Professional tax monthly statement')
		,(@CompanyId,'This app provides the information of professional tax of an employer and its corresponding information. User can filter the information based on Date and Branch and they can download this information.','Professional tax returns')
		,(@CompanyId,'This app provides the complete list of active running goals in the company .','Project actively running goals')
		,(@CompanyId,'This app provides the overall activity of the project. Users can filter the project activity based on employee, work item and log time and can set reset the filters applied.','Project activity')
		,(@CompanyId,'By using this app user can configure the question types by using master question types data. User can edit and archive the created question types. Users can search and sort the information in this app.','Question type')
		,(@CompanyId,'By using this app user can configure the rate tags per hour and rate tags for all the days of the week. User can edit and archive the rate tags that are created previously. User can search and sort information in the app.','Rate tag library')
		,(@CompanyId,'By using this app user can see all the configured rate tag allowances for the site, can add, archive and edit the configured rate tag allowances.Also users can view the archived configured rate tag allowances and can search and sort the configured allowances from the list.','Rate tag allowance time')
		,(@CompanyId,'By using this app user can configure the rates per hour and rates for all the days of the week. User can edit and archive the rates that are created previously. User can search and sort information in the app.','Ratesheet')
		,(@CompanyId,'This app provides the information related to the employee salary with details like Earnings, deductions and others for each employee in the company. User can filter the information and can download information into excel','Salary bill register')
		,(@CompanyId,'This app provides the information related to the logged in employee Gross Annual Income/Salary (with all allowances), Total Taxable Income and Net Tax Payable. User can filter the information and can download information into excel','Salary for IT')
		,(@CompanyId,'This app provides the information of salary bill of an employee with details like employee name, month, joined date, bonus and monthly salary. User can filter the data using advanced search and can download the information into excel','Salary register')
			
		,(@CompanyId,'This app provides the information of salary wages of an employee with details like Date of Appointment, Rate of Wages, Normal wages earned,Deduction if any and reasons thereof,Actual wages paid and Date of payment. User can filter the data using advanced search and can download the information into excel','Salary wages')
		,(@CompanyId,'This app provides the overall activity of the sprint. Users can filter the sprint activity based on employee, work item and log time and can set reset the filters applied.','Sprint activity')
		,(@CompanyId,'This app provides the bug report of Sprint related work items with details like work item name, work item unique name, Assignee, RAG status and Bugs count. User can sort and filter information in the app.','Sprint bug report')
		,(@CompanyId,'This app provides the activity related to the sprint replan with its corresponding details','Sprint replan history')
		,(@CompanyId,'This app displays the timesheet records to be submitted for the aoorover with its corresponding status. User can edit the timesheet records in this app. User can sort, search and filter information in this app.','Timesheet submission')
		,(@CompanyId,'This app displays the timesheet records which needs to be approved by you.User can edit the timesheet records in this app. User can sort, search and filter information in this app.','Timesheets waiting for approval')
		,(@CompanyId,'This app displays the total number of submitted audits and provides the details of each audit','Total number of audits submitted')
		,(@CompanyId,'By using this app user can assign and unassign training courses to the employees.','Training Assignments')
		,(@CompanyId,'This app displays the training courses assigned to the logged in person with its corresponding status','Training record')
		,(@CompanyId,'This app provides the work item status report of goal and they can filter information based on advanced search','Work item status report')
		,(@CompanyId,'This app provides the work loggings of users with details like Project, Goal name, Employee name, Board type, Task name, Original deadline, Time spent so far, Time spent today, Remaining time and Description. User can sort and filter information based on advanced search','Work logging report')
		)
	AS Source (CompanyId,[Description], [WidgetName]) 
	ON Target.WidgetName = Source.WidgetName 
	AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN 
	UPDATE SET [Description] = Source.[Description];

END
GO