create PROCEDURE [dbo].[Marker295]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

UPDATE [HtmlTemplates] SET IsConfigurable = 1  WHERE TemplateName = 'UserRegistrationNotificationTemplate' AND CompanyId = @CompanyId
										  
MERGE INTO [dbo].[TemplateConfiguration] AS Target 
USING (VALUES 
	(NEWID(), (SELECT TOP(1) Id FROM [HtmlTemplates] WHERE TemplateName = 'UserRegistrationNotificationTemplate' AND CompanyId = @CompanyId), 
	STUFF((SELECT ',' + CONVERT(NVARCHAR(50),R.Id)
      FROM [Role] R 
           WHERE R.InActiveDateTime IS NULL
					AND CompanyId = @CompanyId
					AND (R.IsHidden IS NULL OR R.IsHidden = 0)
    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
	@CompanyId, GETDATE(), @UserId)
        )
AS Source ([Id], [HtmlTemplateId], [Roles], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
ON Target.HtmlTemplateId = Source.HtmlTemplateId  AND Target.CompanyId = Source.CompanyId
        WHEN MATCHED THEN 
UPDATE SET [Roles] = Source.[Roles],
           [CompanyId] = Source.[CompanyId],
                   [CreatedDateTime] = Source.[CreatedDateTime],
	       [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND [HtmlTemplateId] is noT null THEN 
INSERT ([Id], [HtmlTemplateId], [Roles], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [HtmlTemplateId], [Roles], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

END
GO
