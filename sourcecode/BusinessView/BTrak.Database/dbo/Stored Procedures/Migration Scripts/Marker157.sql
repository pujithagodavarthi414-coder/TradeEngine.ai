CREATE PROCEDURE [dbo].[Marker157]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 



      MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),N'By using this app user can see all the audit risk,can edit  and can search and sort the audit risk from the list. ', N'Audit Risk', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL))
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
  
MERGE INTO [dbo].[AuditRisk] AS Target 
    USING ( VALUES 
     (NEWID(), N'Critical', CAST(GETDATE() AS DateTime),@UserId,@CompanyId , N'Critical',NULL,NULL,NULL),
     (NEWID(), N'Medium', CAST(GETDATE() AS DateTime),@UserId,@CompanyId,N'Medium',NULL,NULL,NULL),
     (NEWID(), N'Low', CAST(GETDATE() AS DateTime),@UserId,@CompanyId,N'Low',NULL,NULL,NULL))
    AS Source ([Id], [RiskName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[Description],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[RiskName] = Source.[RiskName] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN 
    UPDATE SET [RiskName] = Source.[RiskName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [RiskName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [RiskName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;


END
GO