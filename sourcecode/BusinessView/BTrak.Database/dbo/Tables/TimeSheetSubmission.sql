CREATE TABLE [dbo].[TimeSheetSubmission]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime]  DATETIME NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
    [TimeSheetFrequency] UNIQUEIDENTIFIER NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [ActiveFrom] DATETIME NOT NULL, 
    [ActiveTo] DATETIME NULL, 
    CONSTRAINT [FK_TimeSheetSubmission_TimeSheetSubmissionType] FOREIGN KEY ([TimeSheetFrequency]) REFERENCES [TimeSheetSubmissionType]([Id]), 
    CONSTRAINT [PK_TimeSheetSubmission] PRIMARY KEY ([Id]),
)