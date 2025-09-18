CREATE TABLE [dbo].[Company](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyAuthenticationId] [uniqueidentifier] NULL,
	[CompanyName] [nvarchar](800) NOT NULL,
	[CompanyLogo] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[TimeStamp] [TIMESTAMP] NULL,
    [SiteAddress] [NVARCHAR](1000) NULL, 
    [WorkEmail] [NVARCHAR](1000) NULL, 
    [Password] [NVARCHAR](500) NULL, 
    [IndustryId] [UNIQUEIDENTIFIER] NULL, 
    [MainUseCaseId] [UNIQUEIDENTIFIER] NULL, 
    [TeamSize] BIGINT NULL, 
	[NoOfPurchasedLicences] [INT] NULL, 
	[IsRemoteAccess] [BIT] NULL, 
    [PhoneNumber] [NVARCHAR](100) NULL, 
    [CountryId] [UNIQUEIDENTIFIER] NULL, 
    [TimeZoneId] [UNIQUEIDENTIFIER] NULL,
	[CurrencyId] [UNIQUEIDENTIFIER] NULL,
	[NumberFormatId] [UNIQUEIDENTIFIER] NULL,
	[DateFormatId] [UNIQUEIDENTIFIER] NULL,
	[TimeFormatId] [UNIQUEIDENTIFIER] NULL,
	[IsDemoDataCleared] [BIT] NULL,
	[IsDemoData] [BIT] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [DATETIME] NULL, 
    [IsSoftWare] BIT NULL, 
	[Language]  [nvarchar](20) NULL,
	[TrailDays] [INT] NULL,
	[ConfigurationUrl] [nvarchar] (500) NULL,
	[SiteDomain] [nvarchar] (500) NULL,
	[IsVerify] BIT NULL
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
	[ReDirectionUrl] NVARCHAR(500) NULL, 
    [VAT] NVARCHAR(500) NULL, 
    [PrimaryCompanyAddress] NVARCHAR(MAX) NULL, 
    [RegistrerSiteAddress] NVARCHAR(MAX) NULL, 
    CONSTRAINT [FK_TimeZone_Company_TimeZoneId] FOREIGN KEY ([TimeZoneId]) REFERENCES [TimeZone]([Id]),
	CONSTRAINT [FK_Company_Industry] FOREIGN KEY ([IndustryId]) REFERENCES [Industry]([Id]),
	CONSTRAINT [FK_Company_MainUseCase] FOREIGN KEY ([MainUseCaseId]) REFERENCES [MainUseCase]([Id]),
	CONSTRAINT [FK_Company_NumberFormat] FOREIGN KEY ([NumberFormatId]) REFERENCES [NumberFormat]([Id]),
	CONSTRAINT [FK_Company_DateFormat] FOREIGN KEY ([DateFormatId]) REFERENCES [DateFormat]([Id]),
	CONSTRAINT [FK_Company_TimeFormat] FOREIGN KEY ([TimeFormatId]) REFERENCES [TimeFormat]([Id])
)
GO

ALTER TABLE [dbo].[Company]  WITH CHECK ADD CONSTRAINT [FK_SYS_Country_Company_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[SYS_Country] ([Id])
GO

ALTER TABLE [dbo].[Company]  WITH CHECK ADD CONSTRAINT [FK_SYS_Currency_Company_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[SYS_Currency] ([Id])
GO