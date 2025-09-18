CREATE TABLE [dbo].[AuditAnswerVersions]
(
	 Id UNIQUEIDENTIFIER NOT NULL
	,[AuditComplianceVersionId] [uniqueidentifier] NOT NULL
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
    ,InactiveDateTime DATETIME, 
    [QuestionOptionResult] BIT NULL
)
