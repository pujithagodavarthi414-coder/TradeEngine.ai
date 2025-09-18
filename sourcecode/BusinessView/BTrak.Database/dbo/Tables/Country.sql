CREATE TABLE [dbo].[Country]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NULL,
    [CountryName] [nvarchar](800) NOT NULL,
    [CountryCode] [nvarchar](100) NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
)
GO