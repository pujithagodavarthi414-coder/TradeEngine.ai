CREATE TABLE [dbo].[AuditSelectedQuestion]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AuditComplianceId] [uniqueidentifier] NOT NULL,
	[AuditSchedulingDetailsId] [uniqueidentifier] NOT NULL,
	[AuditQuestionId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier]  NULL,
	[Comment] [nvarchar](500)  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	 CONSTRAINT [PK_AuditSelectedQuestion]  PRIMARY KEY CLUSTERED ([Id]) ,
	CONSTRAINT [FK_AuditSelectedQuestion_AuditQuestions] FOREIGN KEY ([AuditQuestionId]) REFERENCES [AuditQuestions]([Id]), 
    CONSTRAINT [FK_AuditSelectedQuestion_AuditCompliance] FOREIGN KEY ([AuditComplianceId]) REFERENCES [AuditCompliance]([Id])
)
	