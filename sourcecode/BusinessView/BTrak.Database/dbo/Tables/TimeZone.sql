CREATE TABLE [dbo].[TimeZone](
	[Id] [uniqueidentifier] NOT NULL,
	[TimeZoneName] [nvarchar](250) NOT NULL,
	[TimeZoneAbbreviation] [nvarchar](100) NULL,
	[CountryCode] [nvarchar](50) NULL,
	[CountryName] [nvarchar](150) NULL,
	[TimeZone] [nvarchar](250) NULL,
	[TimeZoneOffset] NVARCHAR(10) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,    
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    [OffsetMinutes] INT NULL, 
    CONSTRAINT [PK_TimeZone] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]

GO