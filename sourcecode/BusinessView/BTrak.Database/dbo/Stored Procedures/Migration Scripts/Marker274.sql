CREATE PROCEDURE [dbo].[Marker274]
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
	     (NEWID(),N'This app displays the productive time of the employee',N'My productive time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays the Unproductive time of the employee',N'My unproductive time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays the idle time of the employee',N'My Idle time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays the neutral time of the employee',N'My neutral time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays the total tracked time of the employee',N'My desk time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays the start time of the employee',N'My start time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app displays the finish time of the employee',N'My finish time', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
      (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My productive time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My unproductive time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My Idle time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My neutral time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My desk time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My start time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'My finish time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
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