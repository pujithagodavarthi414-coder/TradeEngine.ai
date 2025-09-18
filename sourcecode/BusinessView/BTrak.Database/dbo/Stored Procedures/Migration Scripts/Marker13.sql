CREATE PROCEDURE [dbo].[Marker13]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


    MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(), 'By using this app user can see all the payroll components for the site, can add, archive and edit the payroll componets.Also users can view the archived payroll components and can search and sort the payroll components from the list', N'Payroll component',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the payroll templates for the site, can add, archive and edit the payroll componets.Also users can view the archived payroll templates and can search and sort the payroll templates from the list.', N'Payroll template',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured roles of payroll templates for the site, can add, archive and edit the configured roles of payroll templates.Also users can view the archived configured roles of payroll templates and can search and sort the configured roles of payroll templates from the list.', N'Payroll role configuration',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured branches of payroll templates for the site, can add, archive and edit the configured branches of payroll templates.Also users can view the archived configured branches of payroll templates and can search and sort the configured branches of payroll templates from the list.', N'Payroll branch configuration',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured genders of payroll templates for the site, can add, archive and edit the configured genders of payroll templates.Also users can view the archived configured genders of payroll templates and can search and sort the configured genders of payroll templates from the list.', N'Payroll gender configuration',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured marital status of payroll templates for the site, can add, archive and edit the configured marital status of payroll templates.Also users can view the archived configured marital status of payroll templates and can search and sort the configured marital status of payroll templates from the list.', N'Payroll marital status configuration',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the tax slabs for the site, can add, archive and edit the tax slabs.Also users can view the archived tax slabs and can search and sort the tax slabs from the list.', N'Tax slabs',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the Professional tax ranges of branches for the site, can add, archive and edit the Professional tax ranges of branches.Also users can view the archived Professional tax ranges of branches and can search and sort the Professional tax ranges of branches from the list.', N'Professional tax ranges',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured employee bonus for the site, can add, archive and edit the configured employee bonus.Also users can view the archived configured employee bonus and can search and sort the configured employee bonus from the list.', N'Configure Employee bonus',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured employee payroll templates for the site, can add, archive and edit the configured employee payroll templates.Also users can view the archived configured employee payroll templates and can search and sort the configured employee payroll templates from the list.', N'Employee payroll configuration',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the resigned employees for the site, can add, archive and edit the resigned employees.Also users can view the archived resigned employees and can search and sort the resigned employees from the list.', N'Employee resignation',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured payroll status for the site, can add, archive and edit the configured payroll status.Also users can view the archived configured payroll status and can search and sort the configured payroll status from the list.', N'Configure Payroll status',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the configured tax allowances for the site, can add, archive and edit the configured tax allowances.Also users can view the archived configured tax allowances and can search and sort the configured tax allowances from the list.', N'Tax allowance',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
,(NEWID(), 'By using this app user can see all the leave encashment settings for the site, can add, archive and edit the leave encashment settings.Also users can view the archived leave encashment settings and can search and sort the leave encashment settings from the list.', N'Leave encashment settings',CAST(N'2019-01-21 11:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
)
AS Source ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [Description] = Source.[Description],
           [WidgetName] = Source.[WidgetName],
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
 (NEWID(),N'By using this app user can see all the configured creditor details for the site, can add, archive and edit the configured creditor details.Also users can view the archived configured creditor details and can search and sort the configured creditor details from the list.', N'Creditor details', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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


    MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(),N'By using this app user can see all the configured financial year of branches for the site, can add, archive and edit the configured financial year of branches.Also users can view the archived configured financial year of branches and can search and sort the configured financial year of branches from the list.', N'Financial year configurations', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

 
    MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(),N'By using this app user can see all the configured Payroll calculations for the site, can add, archive and edit the configured Payroll calculations.Also users can view the archived configured Payroll calculations and can search and sort the configured Payroll calculations from the list.', N'Payroll calculation configurations', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

   

    UPDATE [dbo].[Widget] SET InActiveDateTime = GETDATE() WHERE WidgetName='Resignation status' AND InActiveDateTime IS NULL

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'656502D8-3898-4451-8609-5F9BBCF23463', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

 MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'3631B1E9-B9CA-4CE4-B33B-3DDBA2B2459E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]); 

 MERGE INTO [dbo].[TaxAllowanceType] AS Target 
        USING ( VALUES 
        		(NEWID(), N'Automatic', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @UserId, @CompanyId),
        		(NEWID(), N'Manual', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @UserId, @CompanyId)
        		) 
        AS Source ([Id], [TaxAllowanceTypeName],[CreatedDateTime], [CreatedByUserId],[CompanyId])
        ON Target.Id = Source.Id  
        WHEN MATCHED THEN 
        UPDATE SET [TaxAllowanceTypeName] = Source.[TaxAllowanceTypeName],
                   [CreatedDateTime] = Source.[CreatedDateTime],
        		   [CreatedByUserId] = Source.[CreatedByUserId],
        		   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT([Id], [TaxAllowanceTypeName],[CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES([Id], [TaxAllowanceTypeName],[CreatedDateTime], [CreatedByUserId],[CompanyId]);	

MERGE INTO [dbo].[PayRollComponent] AS Target 
USING (VALUES 
		(NEWID(),@CompanyId,'Bonus',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
	   ,(NEWID(),@CompanyId,'Other Allowance',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
	   ,(NEWID(),@CompanyId,'Leave Encashment',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
	   ,(NEWID(),@CompanyId,'TDS',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
) 
AS Source ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [CompanyId] = Source.[CompanyId],
		   [ComponentName] = Source.[ComponentName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [UpdatedDateTime] = Source.[UpdatedDateTime],
           [UpdatedByUserId] = Source.[UpdatedByUserId],
           [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) VALUES ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

('A104193F-D638-4BE2-B629-A2DEA9182085','PayrollSendNotification',
'<!DOCTYPE html><html><head> <title>Template</title></head><body> <p> Dear ##role## <br /><br /> You have been assigned to a  ##payrollName## payroll run for review. Please follow <a href="##payrollrunLink##">this link</a> to complete this task. <br /><br /> </p></body></html>'
,'2020-02-25','127133F1-4427-4149-9DD6-B02E0E036971'
)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId]) ;

update payrollcomponent
set IsVisible = 1
where ComponentName not in( 
'Bonus',
'Other Allowance',
'Leave Encashment',
'TDS'
)

update payrollcomponent
set IsVisible = 0
where ComponentName in( 
'Bonus',
'Other Allowance',
'Leave Encashment',
'TDS'
)

MERGE INTO [dbo].[PayrollStatus] AS Target 
USING ( VALUES 
          (NEWID(),@CompanyId, N'Generated', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId,0,N'#B3B09E')
         ,(NEWID(),@CompanyId, N'Submitted', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId,0,N'#5959e8')
		 ,(NEWID(),@CompanyId, N'Approved', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId,0,N'#FE7E02')
		 ,(NEWID(),@CompanyId, N'Rejected', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId,0,N'#F95959')
		 ,(NEWID(),@CompanyId, N'Paid', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId,0,N'#31E804')
)  
AS Source ([Id], [CompanyId], [PayrollStatusName], [CreatedDateTime], [CreatedByUserId],[IsArchived],[PayRollStatusColour]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId] = Source.[CompanyId],
	       [PayrollStatusName] = Source.[PayrollStatusName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [IsArchived] = Source.[IsArchived],
		   [PayRollStatusColour] = Source.[PayRollStatusColour]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [CompanyId], [PayrollStatusName], [CreatedDateTime], [CreatedByUserId],[IsArchived],[PayRollStatusColour]) VALUES ([Id], [CompanyId], [PayrollStatusName], [CreatedDateTime], [CreatedByUserId],[IsArchived],[PayRollStatusColour]);

UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker12' WHERE AppSettingsName = 'Marker'

END
GO