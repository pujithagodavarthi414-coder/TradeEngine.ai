CREATE TABLE [dbo].[TimeSheetInterval]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime]  DATETIME NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
    [TimeSheetIntervalFrequency] UNIQUEIDENTIFIER NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL
    CONSTRAINT [PK_TimeSheetInterval] PRIMARY KEY ([Id]),
)
