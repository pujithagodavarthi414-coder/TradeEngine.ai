CREATE TABLE [dbo].[AuditConductSelectedCategory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AuditCategoryId] [uniqueidentifier] NOT NULL,
	[ParentAuditCategoryId] [uniqueidentifier] NULL,
	[AuditComplianceId] [uniqueidentifier] NOT NULL,
	[AuditConductId] [uniqueidentifier] NOT NULL,
	[AuditCategoryName] [nvarchar](150) NULL,
    [AuditCategoryDescription] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[Order] INT NULL,
	[TimeStamp] TIMESTAMP,
	 CONSTRAINT [PK_AuditConductSelectedCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_AuditConductSelectedCategory_AuditCategory] FOREIGN KEY ([AuditCategoryId]) REFERENCES [AuditCategory]([Id]), 
    CONSTRAINT [FK_AuditConductSelectedCategory_AuditConduct] FOREIGN KEY ([AuditConductId]) REFERENCES [AuditConduct]([Id]), 
    CONSTRAINT [FK_AuditConductSelectedCategory_ParentAuditCategory] FOREIGN KEY ([ParentAuditCategoryId]) REFERENCES [AuditCategory]([Id]), 
    CONSTRAINT [FK_AuditConductSelectedCategory_AuditCompliance] FOREIGN KEY ([AuditComplianceId]) REFERENCES [AuditCompliance]([Id]),
)
GO