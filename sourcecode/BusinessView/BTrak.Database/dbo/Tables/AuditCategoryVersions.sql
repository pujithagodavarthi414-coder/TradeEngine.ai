CREATE TABLE [dbo].[AuditCategoryVersions]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AuditComplianceVersionId] [uniqueidentifier] NOT NULL,
	[AuditComplianceId] [uniqueidentifier] NULL,
	[AuditCategoryName] [nvarchar](150) NULL,
    [AuditCategoryDescription] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [ParentAuditCategoryId] UNIQUEIDENTIFIER NULL
)
