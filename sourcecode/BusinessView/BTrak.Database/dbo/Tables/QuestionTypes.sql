CREATE TABLE [dbo].[QuestionTypes]
(
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[QuestionTypeName] [nvarchar](800) NULL,
	[MasterQuestionTypeId] [uniqueidentifier] NULL,
	[IsFromMasterQuestionType] BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
 CONSTRAINT [PK_QuestionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_QuestionTypes_ToTable] FOREIGN KEY ([MasterQuestionTypeId]) REFERENCES [MasterQuestionType]([Id])
) ON [PRIMARY]
GO