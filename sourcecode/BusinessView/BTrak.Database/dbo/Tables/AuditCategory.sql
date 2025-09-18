CREATE TABLE [dbo].[AuditCategory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AuditComplianceId] [uniqueidentifier] NULL,
	[AuditCategoryName] [nvarchar](150) NULL,
	[Order] INT NULL,
    [AuditCategoryDescription] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [ParentAuditCategoryId] UNIQUEIDENTIFIER NULL,
    [TimeStamp] TIMESTAMP
 CONSTRAINT [PK_AuditCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_AuditCategory_AuditCompliance] FOREIGN KEY ([AuditComplianceId]) REFERENCES [AuditCompliance]([Id])
) ON [PRIMARY]
GO