CREATE TABLE [dbo].[MasterContract]
(
	[Id] [uniqueidentifier] NOT NULL,
	CompanyId [uniqueidentifier]  NULL,
	[ContractName] [nvarchar](250) NULL,
	[ClientId] [uniqueidentifier]  NULL,
	[ContractUniqueName] [nvarchar](250) NULL,
	[ProductId] [uniqueidentifier]  NULL,
	[GradeId] [uniqueidentifier]  NULL,
	[RateOrTon] DECIMAL(18,2) null,
	[ContractQuantity] [int] null,
	[UsedQuantity] [int] null,
	[RemaningQuantity] [int] null,
	[TimeStamp] TIMESTAMP,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedDateTimeZone] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[ContractDocument] NVARCHAR(MAX) NULL, 
	[ContractDateFrom] [date] NULL,
	[ContractDateTo] [date] NULL, 
    [InactiveDateTime] DATETIME NULL, 
    [ContractNumber] NVARCHAR(200) NULL,

	

)
