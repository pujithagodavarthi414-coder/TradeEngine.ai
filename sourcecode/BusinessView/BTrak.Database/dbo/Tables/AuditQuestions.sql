CREATE TABLE [dbo].[AuditQuestions]
(
	[Id] [uniqueidentifier] NOT NULL,
	[QuestionName] [nvarchar](800) NULL,
	[QuestionDescription] [nvarchar](MAX) NULL,
	[QuestionTypeId] [uniqueidentifier] NOT NULL,
	[AuditCategoryId] [uniqueidentifier] NULL,
	[QuestionResponsiblePersonId] [uniqueidentifier] NULL,
	[QuestionResult] [nvarchar](800) NULL,
	[Order] INT NULL,
	[EstimatedTime] [decimal](18, 2) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[PriorityId] UNIQUEIDENTIFIER NULL,
	[ImpactId] UNIQUEIDENTIFIER NULL,
	[RiskId] UNIQUEIDENTIFIER NULL,
    [TimeStamp] TIMESTAMP,
	[CompanyId] UNIQUEIDENTIFIER NULL,
	[QuestionIdentity] NVARCHAR(25) NULL,
	[IsMandatory] BIT NULL
 CONSTRAINT [PK_AuditQuestions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    [IsOriginalQuestionTypeScore] BIT NULL, 
    [QuestionHint] NVARCHAR(MAX) NULL, 
   
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AuditQuestions]  WITH CHECK ADD  CONSTRAINT [FK_QuestionTypes_AuditQuestions] FOREIGN KEY([QuestionTypeId])
REFERENCES [dbo].[QuestionTypes] ([Id])
GO

ALTER TABLE [dbo].[AuditQuestions] CHECK CONSTRAINT [FK_QuestionTypes_AuditQuestions]
GO