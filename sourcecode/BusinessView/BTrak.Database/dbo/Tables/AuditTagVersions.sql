CREATE TABLE [dbo].[AuditTagVersions]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
	[AuditComplianceVersionId] [uniqueidentifier] NOT NULL,
	[AuditId] UNIQUEIDENTIFIER NOT NULL,
	[TagName] NVARCHAR(MAX) NOT NULL,
	[TagId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[InActiveDateTime] DATETIME NULL,
)
