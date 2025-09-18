CREATE TABLE [dbo].[QuestionTypeOptions]
(
	 Id UNIQUEIDENTIFIER NOT NULL
    ,QuestionTypeId	UNIQUEIDENTIFIER NULL
    ,QuestionTypeOptionName	NVARCHAR(150)
    ,QuestionTypeOptionScore FLOAT
    ,QuestionTypeOptionOrder INT
    ,CreatedByUserId UNIQUEIDENTIFIER
    ,CreatedDateTime DATETIME
    ,UpdatedByUserId UNIQUEIDENTIFIER
    ,UpdatedDateTime DATETIME
    ,[TimeStamp] TIMESTAMP
    ,InactiveDateTime DATETIME
    ,CONSTRAINT [PK_QuestionTypeOptions] PRIMARY KEY ([Id])
    ,CONSTRAINT [FK_QuestionTypeOptions_QuestionTypes] FOREIGN KEY ([QuestionTypeId]) REFERENCES [QuestionTypes]([Id])
)