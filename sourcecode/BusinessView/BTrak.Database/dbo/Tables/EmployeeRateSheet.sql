CREATE TABLE [dbo].[EmployeeRateSheet]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[RateSheetEmployeeId] UNIQUEIDENTIFIER NOT NULL, 
	[RateSheetId] UNIQUEIDENTIFIER NOT NULL, 
	[CompanyId] UNIQUEIDENTIFIER NULL,
	[RateSheetName] NVARCHAR(250) NULL,
    [RateSheetCurrencyId] UNIQUEIDENTIFIER NULL,
	[RateSheetForId] UNIQUEIDENTIFIER NULL,
	[RateSheetStartDate] DATETIME NULL,
	[RateSheetEndDate] DATETIME NULL,
	[Priority] INT NULL,
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
	[TimeStamp] TIMESTAMP
CONSTRAINT [PK_EmployeeRateSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

CREATE NONCLUSTERED INDEX IX_EmployeeRateSheet_CompanyId 
ON [dbo].[RateSheet] (  CompanyId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeRateSheet_RateSheetFor 
ON [dbo].[RateSheet] (  [RateSheetForId] ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY]
GO