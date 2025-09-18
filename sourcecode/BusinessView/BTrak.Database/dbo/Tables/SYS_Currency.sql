CREATE TABLE [dbo].[SYS_Currency]
(
    [Id] [uniqueidentifier] NOT NULL ,
    [CurrencyName] [nvarchar](500) NOT NULL,
	[CurrencyCode] [nvarchar](500) NOT NULL,
	[Symbol] [nvarchar](50) NULL,
	CurrencyNaming [nvarchar](500) NULL,
	DisplayFormat [nvarchar](500) NULL,
    [IsActive] [bit] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP
    CONSTRAINT [PK_SYS_Currency] PRIMARY KEY ([Id]),
)
GO