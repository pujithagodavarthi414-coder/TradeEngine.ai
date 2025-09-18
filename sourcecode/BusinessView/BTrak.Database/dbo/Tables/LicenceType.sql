CREATE TABLE [dbo].[LicenceType]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [LicenceTypeName] [nvarchar](800) NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP	
)
GO