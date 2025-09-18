CREATE TABLE [dbo].[Audit](
	[Id] [uniqueidentifier] NOT NULL,
	[AuditJson] [nvarchar](MAX) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[IsOldAudit] [bit] NULL,
	[TimeStamp] TIMESTAMP,
	[InactiveDateTime] [datetime] NULL,
    [FeatureId] UNIQUEIDENTIFIER NULL 
)
GO