CREATE TABLE [dbo].[MasterQuestionType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[MasterQuestionTypeName] NVARCHAR(250) NOT NULL,
    [CreatedDateTime] DATETIME NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME NULL,
    [TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_MasterQuestionType] PRIMARY KEY ([Id])
)
