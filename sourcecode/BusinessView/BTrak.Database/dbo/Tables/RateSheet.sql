CREATE TABLE [dbo].[RateSheet]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[CompanyId] [uniqueidentifier] NULL,
    [RateSheetName] NVARCHAR(250) NOT NULL,
	[RateSheetForId] UNIQUEIDENTIFIER NULL,
    [RatePerHour] decimal(18,2),
    [RatePerHourMon] decimal(18,2),
    [RatePerHourTue] decimal(18,2),
    [RatePerHourWed] decimal(18,2),
    [RatePerHourThu] decimal(18,2),
    [RatePerHourFri] decimal(18,2),
    [RatePerHourSat] decimal(18,2),
    [RatePerHourSun] decimal(18,2),
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[Priority] [int] NULL,
CONSTRAINT [PK_RateSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO