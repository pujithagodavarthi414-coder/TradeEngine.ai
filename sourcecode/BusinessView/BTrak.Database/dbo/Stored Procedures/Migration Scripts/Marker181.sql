CREATE PROCEDURE [dbo].[Marker181]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
 (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Projects' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
)
AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET
		   [WidgetId] = Source.[WidgetId],
		   [ModuleId] = Source.[ModuleId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

END
