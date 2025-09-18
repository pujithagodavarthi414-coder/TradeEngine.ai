CREATE TABLE [dbo].[SYS_Country]
(
	[Id] [uniqueidentifier] NOT NULL ,
    [CountryName] [nvarchar](800) NOT NULL,
    [CountryCode] [nvarchar](100) NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP
    CONSTRAINT [PK_SYS_Country] PRIMARY KEY ([Id]),
)
GO
