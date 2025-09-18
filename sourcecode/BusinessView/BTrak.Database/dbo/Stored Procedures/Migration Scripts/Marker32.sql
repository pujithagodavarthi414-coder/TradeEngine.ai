CREATE PROCEDURE [dbo].[Marker32]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	  (NEWID(), N'Customized_ProjectActivityDashboard',0, GETDATE(), @UserId, @CompanyId, 'ProjectActivity')
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
	    (NEWID(), N'This app displays organizational design in a diagram that visually conveys a companys internal structure by detailing the role, responsibilities, and relationships between individuals within an entity. This chart broadly depict an enterprise company-wide and drill down to a specific department or unit',N'Organization chart', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
        (NEWID(), N'This app displays the history of changes of employee details',N'Employee history', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
        --(NEWID(), N'This app displays the project activity',N'Project activity', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
        (NEWID(), N'This app is used to for form submissions and form assignments. By using this app we can fill a form and assign that to a user for furthur updations. Here we can also add some discusions related to form in comments section and history is saved',N'Form submissions', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
        (NEWID(), N'This app is used to configure forms for performance review submissions.By using this app we can create dynamic forms with different type of fields provided. We can also save roles with respect to forms and these forms are displayed during submissions based on the roles',N'Performance configurations', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL))
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
	
	UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker28' WHERE AppSettingsName = 'Marker'
END

