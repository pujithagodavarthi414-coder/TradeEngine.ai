CREATE TABLE [dbo].[AuditConductAnswers]
(
     Id UNIQUEIDENTIFIER NOT NULL
    ,AuditConductId UNIQUEIDENTIFIER
    ,QuestionTypeOptionId UNIQUEIDENTIFIER
    ,QuestionTypeOptionName NVARCHAR(MAX) NULL
    ,Answer NVARCHAR(MAX) NULL
    ,AuditQuestionId UNIQUEIDENTIFIER NOT NULL
    ,Score FLOAT
    ,CreatedByUserId UNIQUEIDENTIFIER
    ,CreatedDateTime DATETIME
    ,UpdatedByUserId UNIQUEIDENTIFIER
    ,UpdatedDateTime DATETIME
    ,[TimeStamp] TIMESTAMP
    ,InactiveDateTime DATETIME
    ,[Order] INT NULL
    ,[QuestionOptionResult] BIT NULL, 
    [QuestionIdentity] NCHAR(100) NULL, 
    CONSTRAINT [PK_AuditConductAnswers] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_AuditConductAnswers_AuditQuestions] FOREIGN KEY ([AuditQuestionId]) REFERENCES [AuditQuestions]([Id]), 
)
