CREATE PROCEDURE [dbo].[Marker263]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app displays today latest five screenshots of user which are tracked.And with this app we can able to see information like keystrokes, mouse movements etc of latest screenshots',N'Latest screenshots', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
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


	 MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
     USING (VALUES 
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Latest screenshots' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
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

	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"Working","value":"0","legendColor":"#13e91e"},{"legendName":"Leave","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Monday Leave Report')
	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"Working","value":"0","legendColor":"#13e91e"},{"legendName":"Leave","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Sick Leave Report')
	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"Full  day leave","value":"1","legendColor":"#d82323"},{"legendName":"Half day leave","value":"0.5","legendColor":"#da8d17"},{"legendName":"Working day","value":"0","legendColor":"#13e91e"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Leaves Report')
	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"No break","value":"0","legendColor":"#c8d3c9"},{"legendName":"1-30 min","value":"1","legendColor":"#13e91e"},{"legendName":"30-60 min","value":"31","legendColor":"#da8d17"},{"legendName":"Greater than 60 min","value":"60","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Break Time Report')
	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"On time","value":"0","legendColor":"#13e91e"},{"legendName":"Late","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Morning Late Report')
	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"On time","value":"0","legendColor":"#13e91e"},{"legendName":"Late","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Afternoon Late Report')
	UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"No spent time","value":"0","legendColor":"#c8d3c9"},{"legendName":"1-4 hours","value":"1","legendColor":"#d82323"},{"legendName":"4-8 hours","value":"241","legendColor":"#da8d17"},{"legendName":"more than 8 hours","value":"481","legendColor":"#13e91e"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Spent Time Report')

END
GO
