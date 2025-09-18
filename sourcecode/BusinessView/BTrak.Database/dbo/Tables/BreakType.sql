CREATE TABLE [dbo].[BreakType]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [BreakName] [nvarchar](800) NOT NULL,
	[IsPaid] [bit] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
)
GO