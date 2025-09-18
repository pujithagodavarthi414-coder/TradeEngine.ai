CREATE TABLE [dbo].[AuditCompliance]
(
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[AuditName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](800) NULL,
    [IsRAG] [bit] NULL DEFAULT 0,
    [CanLogTime] [bit] NULL DEFAULT 0,
    [InboundPercent] [float] NULL,
    [OutboundPercent] [float] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[ResposibleUserId] UNIQUEIDENTIFIER NULL,
	[EnableQuestionLevelWorkFlow] BIT NULL,
	AuditFolderId UNIQUEIDENTIFIER NULL,
	[EnableWorkFlowForAudit] BIT NULL,
	[EnableWorkFlowForAuditConduct] BIT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
	[ProjectId] [uniqueidentifier] NULL, --DEFAULT NOT NULL
 CONSTRAINT [PK_AuditCompliance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    [SpanInYears] INT NULL,
	[SpanInMonths] INT NULL,
	[SpanInDays] INT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AuditCompliance]  WITH NOCHECK ADD  CONSTRAINT [FK_Project_AuditCompliance_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[AuditCompliance] CHECK CONSTRAINT [FK_Project_AuditCompliance_ProjectId]
GO