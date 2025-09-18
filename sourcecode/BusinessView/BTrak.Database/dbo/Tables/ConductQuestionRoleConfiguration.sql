CREATE TABLE [dbo].[ConductQuestionRoleConfiguration]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [AuditQuestionId] [uniqueidentifier]  NULL,
	[ConductQuestionId] [uniqueidentifier]  NULL,
	[Roles] [nvarchar](MAX) NULL,
	[Users] [nvarchar](MAX) NULL,
	[CanEdit] BIT NULL,
	[CanView] BIT  NULL,
	[CanAddAction] BIT NULL,
	[NoPermission] BIT NULL,
	CompanyId [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	[UpdatedDateTime] DATETIME   NULL,	
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] BIT NULL
)
