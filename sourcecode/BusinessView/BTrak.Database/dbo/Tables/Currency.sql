CREATE TABLE [dbo].[Currency]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NULL,
    [CurrencyName] [nvarchar](500) NOT NULL,
	[CurrencyCode] [nvarchar](500) NOT NULL,
	[Symbol] [nvarchar](50) NULL,
    [IsActive] [bit] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
)
GO
