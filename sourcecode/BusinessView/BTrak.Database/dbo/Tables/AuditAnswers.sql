CREATE TABLE [dbo].[AuditAnswers]
(
	 Id UNIQUEIDENTIFIER NOT NULL
    ,QuestionTypeOptionId UNIQUEIDENTIFIER NULL
    ,Answer NVARCHAR(MAX) NULL
    ,AuditId UNIQUEIDENTIFIER
    ,AuditQuestionId UNIQUEIDENTIFIER NOT NULL
    ,Score FLOAT
    ,QuestionOptionDate DATETIME
	,QuestionOptionNumeric FLOAT
	,QuestionOptionBoolean BIT DEFAULT 0
	,QuestionOptionTime TIME
	,QuestionOptionText NVARCHAR(MAX) NULL 
	,CreatedByUserId UNIQUEIDENTIFIER
    ,CreatedDateTime DATETIME
    ,UpdatedByUserId UNIQUEIDENTIFIER
    ,UpdatedDateTime DATETIME
    ,[TimeStamp] TIMESTAMP
    ,InactiveDateTime DATETIME, 
    [QuestionOptionResult] BIT NULL, 
    CONSTRAINT [PK_AuditAnswers] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_AuditAnswers_AuditQuestions] FOREIGN KEY ([AuditQuestionId]) REFERENCES [AuditQuestions]([Id]), 
    CONSTRAINT [FK_AuditAnswers_AuditCompliance] FOREIGN KEY ([AuditId]) REFERENCES [AuditCompliance]([Id]), 
    CONSTRAINT [FK_AuditAnswers_Audit] FOREIGN KEY ([QuestionTypeOptionId]) REFERENCES [QuestionTypeOptions]([Id])
)
