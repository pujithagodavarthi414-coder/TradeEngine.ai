CREATE PROCEDURE [dbo].[Marker266]
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
	     (NEWID(),N'This app displays the top 5 productive users based on permission. If permission exists it will display top 5 of all users else reporting users only',N'Most Productive Users', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'This app displays the top 5 unproductive users based on permission. If permission exists it will display top 5 of all users else reporting users only',N'Most Unproductive Users', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)        
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
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Most Productive Users' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
    ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Most Unproductive Users' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())    
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
