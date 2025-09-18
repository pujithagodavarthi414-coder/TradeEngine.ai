CREATE PROCEDURE [dbo].[Marker12]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
		(NEWID(), N'This app provides the work loggings of users',N'Work logging report', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app provides the productivity chart of users on yearly basis',N'Productivity report',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app provides the goal burn down chart of goal',N'Goal burn down chart',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app provides the work item status report of goal',N'Work item status report',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app provides the goal replan history of goal',N'Goal replan history',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app provides goal activity of goal',N'Goal activity',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app we can manage the custom app',N'Custom app', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Personal details of the employee. User can add details like First name, Last name, Email, Date of birth , Gender, Martial status and Nationality. User can also edit these details.',N'Employee personal details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Contact details of the employee. User can add details like Address, State , Postalcode, Country ,Telephone, Mobile number and Emails. User can also edit these details.',N'Employee contact details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the License details of the employee. User can add details like License number, License Type, License issue and expiry dates and they can add attachments. User can also edit and delete these details. User can add multiple license details. Users can search data from the license details list and can sort each column.',N'Employee license details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Emergency contact details of the employee. User can add details like First name, Last name, Relationship, Home and work telephones and Mobile Number. User can also edit and delete these details. User can add multiple emergency contact details. Users can search data from the emergency contact details list and can sort each column.',N'Employee emergency contact details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the dependent details of the employee. User can add details like First name, Last name, Relationship and Mobile Number. User can also edit and delete these details. User can add multiple dependent details. Users can search data from the dependent details list and can sort each column.',N'Employee dependent details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the immigration details of the employee. User can add details like Document type, Document number, Country, Issue and expiry dates, Comments and attachments. User can also edit and delete these details. User can add multiple immigration details. Users can search data from the immigration details list and can sort each column.',N'Employee immigration details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Job details of the employee. User can add details like Designation, Employment type, Job Category, Joined date, Department and Location. User can also edit these details if needed.',N'Employee job details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Pay rates of the employee. User can configure the pay rates for a particular date range with different currencies.User can also edit the pay rates.Users can search data from the rate sheet and can sort each column.',N'Employee rate sheet', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Salary details of the employee. User can add details like Pay grade, Salary component , Pay frequency, Payment method,Currency, Total amount, Start date and End date, Comments and attachments.User can also edit the salary details. Users can search data from the salary details and can sort each column.',N'Employee salary details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the Bank details of the employee. User can add details like Sort code, Account number , Account name, Bank name,Branch name, Start date.User can also edit the bank details. Users can search data from the bank details and can sort each column.',N'Employee bank details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage the reporting details of the employee. User can add details like Employee name, Reporting method , Reporting from date and comments.User can also edit and delete the reporting details.Users can search data from the reporting details and can sort each column.',N'Employee report to', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage education details of the employee. User can add details like education level, institute and score. User can also edit and delete the education details.Users can search data from the education details and can sort each column.',N'Employee education details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage languages known by an employee. User can add details like language, fluency and competancy. User can also edit and delete the language details.Users can search data from the language details and can sort each column.',N'Employee language details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage skill set of an employee. User can add details like skill and years of experience. User can also edit and delete the skills.Users can search data from the list of skills and can sort each column.',N'Employee skill details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage work experience of an employee. User can add details like company, job title and tenure. User can also edit and delete the work experience.Users can search data from the list and can sort each column.',N'Employee work experience details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage membership details of the employee. User can add details like name of the certificate, Issue certifying authority, Membership, Commenced date and attachments.User can also edit and delete the membership details.Users can search data from the membership details and can sort each column.',N'Employee membership details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app user can manage shift details of the employee. User can add details like Shift name, Shift active from and to dates.User can also edit and delete the shift details.Users can search data from the shift details and can sort each column. Users can view the details of the employee shift',N'Employee shift details', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app we can create a form as per our requirement and fill the details in the form. User can rename the app. User can also edit and delete the form. ',N'Custom fields', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'By using this app we can add comments section wherever it is required',N'Comments app', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
	
MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	  (NEWID(), N'Customized_projectDashboard',0, GETDATE(), @UserId, @CompanyId, 'Project')
	 ,(NEWID(), N'Customized_goalDashboard',0, GETDATE(), @UserId, @CompanyId, 'Goal')
	)
	AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
			   [IsHidden] = Source.[IsHidden],
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsCustomizedFor] = Source.[IsCustomizedFor]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(), N'This app displays the history of assets', N'Assets comments and history', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
 
 )
AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [WidgetName] = Source.[WidgetName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] =  Source.[CompanyId],
           [Description] =  Source.[Description],
           [UpdatedDateTime] =  Source.[UpdatedDateTime],
           [UpdatedByUserId] =  Source.[UpdatedByUserId],
           [InActiveDateTime] =  Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker12' WHERE AppSettingsName = 'Marker'
END
GO