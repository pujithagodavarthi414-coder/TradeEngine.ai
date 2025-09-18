
CREATE PROCEDURE [dbo].[Marker150]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

MERGE INTO [dbo].[WorkSpace] AS Target
USING ( VALUES
(NEWID(), N'Customized_auditDashboard',0, GETDATE(), @UserId, @CompanyId, 'Audits')
)
AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
ON Target.WorkSpaceName = Source.WorkSpaceName AND Target.CompanyId = Source.CompanyId
WHEN MATCHED THEN
UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
  [IsHidden] = Source.[IsHidden],
  [CompanyId] = Source.[CompanyId],
  [CreatedDateTime] = Source.[CreatedDateTime],
  [CreatedByUserId] = Source.[CreatedByUserId],
  [IsCustomizedFor] = Source.[IsCustomizedFor]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

MERGE INTO [dbo].[Tags] AS Target
USING ( VALUES
 (NEWID(),NULL,'Audit analytics',NULL,@CompanyId,@UserId,GETDATE())
)
AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
ON Target.TagName = Source.TagName AND Target.CompanyId = Source.CompanyId
WHEN MATCHED THEN
UPDATE SET [TagName] = Source.[TagName],
  [CompanyId] = Source.[CompanyId],
  [ParentTagId] = Source.[ParentTagId],
  [Order] = Source.[Order],
  [CreatedDateTime] = Source.[CreatedDateTime],
  [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);

END
GO