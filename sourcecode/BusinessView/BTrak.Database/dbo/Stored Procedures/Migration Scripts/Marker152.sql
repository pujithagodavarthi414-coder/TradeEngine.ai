CREATE PROCEDURE [dbo].[Marker152]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

      MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),N'', N'Audit Priority', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'', N'Audit Impact', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL))
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
    
    
    MERGE INTO [dbo].[AuditPriority] AS Target 
    USING ( VALUES 
     (NEWID(), N'Critical', CAST(GETDATE() AS DateTime),@UserId,@CompanyId , N'Critical',NULL,NULL,NULL),
     (NEWID(), N'Medium', CAST(GETDATE() AS DateTime),@UserId,@CompanyId,N'Medium',NULL,NULL,NULL),
     (NEWID(), N'Low', CAST(GETDATE() AS DateTime),@UserId,@CompanyId,N'Low',NULL,NULL,NULL))
    AS Source ([Id], [PriorityName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[Description],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.[PriorityName] = Source.[PriorityName] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN 
    UPDATE SET [PriorityName] = Source.[PriorityName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [PriorityName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [PriorityName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;
    
    MERGE INTO [dbo].[AuditImpact] AS Target 
    USING ( VALUES 
     (NEWID(), N'Critical', CAST(GETDATE() AS DateTime),@UserId,@CompanyId , N'Critical',NULL,NULL,NULL),
     (NEWID(), N'Medium', CAST(GETDATE() AS DateTime),@UserId,@CompanyId,N'Medium',NULL,NULL,NULL),
     (NEWID(), N'Low', CAST(GETDATE() AS DateTime),@UserId,@CompanyId,N'Low',NULL,NULL,NULL))
    AS Source ([Id], [ImpactName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[Description],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.[ImpactName] = Source.[ImpactName] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN 
    UPDATE SET [ImpactName] = Source.[ImpactName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [ImpactName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [ImpactName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

END
GO
