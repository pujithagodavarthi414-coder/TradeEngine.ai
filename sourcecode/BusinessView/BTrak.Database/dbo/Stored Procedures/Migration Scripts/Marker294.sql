CREATE PROCEDURE [dbo].[Marker294]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
  
   UPDATE WIDGET SET [WidgetName]='Work items analysis board' WHERE [WidgetName]='Work items analysys board' AND CompanyId = @CompanyId

   	DELETE FROM WidgetModuleConfiguration WHERE WidgetId = (SELECT Id FROM Widget WHERE WidgetName = 'Leave Types' AND CompanyId = @CompanyId)
	 
    MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
     USING (VALUES 
      (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Leave Types' AND CompanyId = @CompanyId),'3C10C01F-C571-496C-B7AF-2BEDD36838B5',@UserId,GETDATE())
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

   MERGE INTO [dbo].[CustomAppColumns] AS Target
   USING ( VALUES
   (NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Version details'),'Id', 'uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),NULL)
   ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName ='Version details'),'Milestone name', 'nvarchar',NULL,(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
   )
     AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
     ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName]
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