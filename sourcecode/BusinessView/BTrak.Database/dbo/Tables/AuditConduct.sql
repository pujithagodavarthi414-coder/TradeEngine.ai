CREATE TABLE [dbo].[AuditConduct](
	[Id] [uniqueidentifier] NOT NULL,
	[AuditConductName] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](800) NULL,
	[AuditComplianceId] [uniqueidentifier] NOT NULL,
	[IsIncludeAllQuestions] [bit] NULL,
	[IsOpen] [bit] NULL,
	[IsCompleted] [bit] NULL,
	[DeadlineDate] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[ResponsibleUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 [CronStartDate] DATETIME NULL, 
    [CronEndDate] DATETIME NULL, 
    [CronExpression] NVARCHAR(50) NULL, 
	[ProjectId] [uniqueidentifier] NULL, --DEFAULT NOT NULL
	[AuditRatingId] [uniqueidentifier] NULL,
    CONSTRAINT [PK_AuditConduct] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AuditConduct]  WITH NOCHECK ADD  CONSTRAINT [FK_AuditConduct_AuditCompliance] FOREIGN KEY([AuditComplianceId])
REFERENCES [dbo].[AuditCompliance] ([Id])
GO

ALTER TABLE [dbo].[AuditConduct] CHECK CONSTRAINT [FK_AuditConduct_AuditCompliance]
GO

ALTER TABLE [dbo].[AuditConduct]  WITH NOCHECK ADD  CONSTRAINT [FK_Project_AuditConduct_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[AuditConduct] CHECK CONSTRAINT [FK_Project_AuditConduct_ProjectId]
GO

CREATE NONCLUSTERED INDEX [IX_AuditConduct_Id_AuditComplianceId_IsCompleted]
ON [dbo].[AuditConduct] ([InActiveDateTime],[CreatedDateTime])
INCLUDE ([Id],[AuditComplianceId],[IsCompleted])
GO