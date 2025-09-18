CREATE TABLE [dbo].[site]
(
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
    [Name] [nvarchar](250) NOT NULL,
    [Address] [nvarchar](250) NULL,
    [Email] [nvarchar](250) NOT NULL,
    [Addressee] [nvarchar](250) NULL,
    [RoofRentalAddress] [nvarchar](250) NULL,
    [Date] [datetime] NULL,
    [ParcellNo] [nvarchar](250) NULL,
    [M2]  DECIMAL(18, 2) NULL,
    [Chf]  DECIMAL(18, 2) NULL,
    [Term] [Int] NULL,
    [Muncipallity] [nvarchar](250) NULL,
    [Canton] [nvarchar](250) NULL,
    [AnnualReduction]  DECIMAL(18, 2) NULL,
    [RepriceExpected]  DECIMAL(18, 2) NULL,
    [AutoCExpected]  DECIMAL(18, 2) NULL,
    [StartingYear] [datetime] NULL,
    [ProductionFirstYear] [Int] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
CONSTRAINT [PK_site] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    [AutoCTariff] DECIMAL(18, 2) NULL, 
)
