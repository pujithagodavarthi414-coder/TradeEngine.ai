
CREATE PROCEDURE [dbo].[Marker326]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
    MERGE INTO [dbo].[CustomTags] AS Target
USING ( VALUES
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Completed exit stories percentage' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Completed vs total exit stories' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Completed exit stories percentage' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Completed vs total exit stories' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Exit configurations' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Exit configurations' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 )
	AS Source ([Id],[ReferenceId], [TagId],[CreatedDateTime],[CreatedByUserId])
	ON Target.[ReferenceId] = Source.[ReferenceId] AND Target.[TagId] = Source.[TagId]
	WHEN MATCHED THEN
	UPDATE SET [ReferenceId] = Source.[ReferenceId],
			   [TagId] = Source.[TagId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.ReferenceId IS NOT NULL THEN  
	INSERT ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]) VALUES
	([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]);
END