CREATE PROCEDURE [dbo].[Marker273]
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
	     (NEWID(),N'This app displays the application categories based on permission. If permission exists it will allow to add or delete application categories'
         ,N'Application category', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
      (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Application category' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
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


	MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app displays current day productive, unproductive, neutral time usage. This app consists area and column visual representations . If permission exists it will display all users else reporting users only',N'Time productivity', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays total team members count.',N'Team members count', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
      (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Time productivity' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Team members count' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
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

    INSERT INTO [dbo].[Intro] (Id,UserId,ModuleId,CreatedByUserId,CreatedDateTime,EnableIntro)
    SELECT NEWID(),U.Id AS UserId,M.Id AS ModuleId,@UserId,GETDATE(),0
    FROM [User] U
        INNER JOIN Module M ON 1 = 1
    WHERE M.Id IN (
    SELECT ModuleId FROM CompanyModule CM 
    WHERE CM.CompanyId = @CompanyId 
          --AND CM.IsActive = 1 AND CM.IsEnabled = 1
          AND CM.InActiveDateTime IS NULL
    )
    AND U.CompanyId = @CompanyId

END
GO