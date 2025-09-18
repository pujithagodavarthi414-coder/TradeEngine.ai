CREATE TABLE [dbo].[TimeSheetSubmissionType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(50) NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL,  
    [UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    [InActiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_TimeSheetSubmissionType] PRIMARY KEY ([Id])
)
