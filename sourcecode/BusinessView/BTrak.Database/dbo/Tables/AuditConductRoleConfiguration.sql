CREATE TABLE [dbo].[AuditConductRoleConfiguration]
(
    [Id] [uniqueidentifier] NOT NULL,
	[AuditQuestionId] [uniqueidentifier]  NULL,
	[ConductQuestionId] [uniqueidentifier]  NULL,
	[ViewRoles] [nvarchar](MAX) NULL,
	[EditRoles] [nvarchar](MAX) NULL,
	[DeleteRoles] [nvarchar](MAX) NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] BIT NULL
)
