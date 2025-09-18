CREATE TABLE [dbo].[AuditQuestionHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
    [QuestionId] [uniqueidentifier] NULL,
    [AuditId]  [uniqueidentifier]  NULL,
    [FolderId]  [uniqueidentifier]  NULL,
    [ConductId]  [uniqueidentifier]  NULL,
    [OldValue]  [nvarchar](MAX)  NULL,
    [NewValue]  [nvarchar](MAX)  NULL,
    [Description]  [nvarchar](800)  NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
  [TimeStamp] TIMESTAMP,
 [Field] NVARCHAR(100) NULL, 
    [IsAction] BIT NOT NULL DEFAULT 0, 
    [UserStoryId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_AuditQuestionHistory] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AuditQuestionHistory] WITH NOCHECK ADD CONSTRAINT [FK_AuditCompliance_AuditQuestionHistory_AuditId] FOREIGN KEY ([AuditId])
REFERENCES [dbo].[AuditCompliance] ([Id])
GO

ALTER TABLE [dbo].[AuditQuestionHistory] CHECK CONSTRAINT [FK_AuditCompliance_AuditQuestionHistory_AuditId]
GO

ALTER TABLE [dbo].[AuditQuestionHistory] WITH NOCHECK ADD CONSTRAINT [FK_AuditConduct_AuditQuestionHistory_ConductId] FOREIGN KEY ([ConductId])
REFERENCES [dbo].[AuditConduct] ([Id])
GO

ALTER TABLE [dbo].[AuditQuestionHistory] CHECK CONSTRAINT [FK_AuditConduct_AuditQuestionHistory_ConductId]
GO
