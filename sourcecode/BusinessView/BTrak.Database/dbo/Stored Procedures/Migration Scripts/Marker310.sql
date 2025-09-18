CREATE PROCEDURE [dbo].[Marker310]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	  (NEWID(),'By using this app user can see all the HTML templates for the site, can add, archive and edit the html templates. Also users can view the archived HTML templates and can search and sort the HTML templates from the list.
	  ', 'Templates', GETDATE(),@UserId,@CompanyId)
	 	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId]) 
	ON Target.[WidgetName] = Source.[WidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId]) 
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId]) ;

	MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
       (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Templates' AND CompanyId = @CompanyId),'3FF89B1F-9856-477D-AF3C-40CF20D552FC',@UserId,GETDATE())
     )
    AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
    ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
    WHEN MATCHED THEN 
    UPDATE SET
    		   [WidgetId] = Source.[WidgetId],
    		   [ModuleId] = Source.[ModuleId],
    		   [CreatedDateTime] = Source.[CreatedDateTime],
    		   [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
    INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

END
GO