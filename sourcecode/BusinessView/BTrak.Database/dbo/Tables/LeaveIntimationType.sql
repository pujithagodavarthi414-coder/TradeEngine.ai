CREATE TABLE [dbo].[LeaveIntimationType]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [NumberOfDaysTobeIntimate] INT NULL, 
    [NumberOfLeaves] INT NULL, 
    [LinkLeaveFrequencyId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [OriginalId] UNIQUEIDENTIFIER NULL, 
    [CompanyId] UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] DATETIME NULL,		 
    [VersionNumber] INT NULL DEFAULT 1, 
    [TimeStamp] TIMESTAMP,
    [AsAtInactiveDateTime] [datetime] NULL,				 
CONSTRAINT [PK_LeaveIntimationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
