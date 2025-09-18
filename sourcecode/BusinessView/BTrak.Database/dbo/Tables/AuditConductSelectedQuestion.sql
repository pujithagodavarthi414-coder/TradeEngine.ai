CREATE TABLE [dbo].[AuditConductSelectedQuestion]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AuditConductId] [uniqueidentifier] NOT NULL,
	[AuditQuestionId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier]  NULL,
	[Comment] [nvarchar](500)  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	 CONSTRAINT [PK_AuditConductSelectedQuestion]  PRIMARY KEY CLUSTERED ([Id]) ,
	CONSTRAINT [FK_AuditConductSelectedQuestion_AuditQuestions] FOREIGN KEY ([AuditQuestionId]) REFERENCES [AuditQuestions]([Id]), 
    CONSTRAINT [FK_AuditConductSelectedQuestion_AuditCompliance] FOREIGN KEY ([AuditConductId]) REFERENCES [AuditConduct]([Id])
)