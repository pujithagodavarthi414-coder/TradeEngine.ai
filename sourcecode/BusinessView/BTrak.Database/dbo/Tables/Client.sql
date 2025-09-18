CREATE TABLE [dbo].[Client](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CompanyName] [nvarchar](800) NOT NULL,
	[CompanyWebsite] [nvarchar](800) NULL,
	[BranchId] [uniqueidentifier] NULL,
	[Note] [nvarchar](1000) NULL,
	[ClientTypeId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
    [ClientKycId] UNIQUEIDENTIFIER NULL, 
    [LeadFormId] UNIQUEIDENTIFIER NULL, 
    [LeadFormData] NVARCHAR(MAX) NULL, 
    [KycFormData] NVARCHAR(MAX) NULL, 
    [CreditLimit] Decimal(18,2) NULL, 
    [AvailableCreditLimit] Decimal(18,2) NULL, 
    [AddressLine1] NVARCHAR(250) NULL, 
    [AddressLine2] NVARCHAR(250) NULL, 
    [PanNumber] NVARCHAR(50) NULL, 
    [BusinessEmail] NVARCHAR(250) NULL, 
    [BusinessNumber] NVARCHAR(250) NULL, 
    [EximCode] NVARCHAR(250) NULL, 
    [GstNumber] NVARCHAR(250) NULL, 
    [KycRemindDays] INT NULL, 
    [KycExpiryDays] INT NULL, 
    [KycVerifiedDate] DATETIME NULL,
    [LegalEntityId] UNIQUEIDENTIFIER NULL, 
    [IsKycSybmissionMailSent] BIT NULL, 
    [KycSubmittedDate] DATETIME NULL, 
    [KycFormStatusId] UNIQUEIDENTIFIER NULL,
    [ContractTemplateIds] NVARCHAR(MAX),
    [BrokerageValue] DECIMAL(18, 3) NULL,
    [TradeTemplateIds] NVARCHAR(MAX) NULL, 
    [PhoneCountryCode] NVARCHAR(50) NULL, 
    [BusinesCountryCode] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Client] WITH CHECK ADD CONSTRAINT [FK_Branch_Client_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_Branch_Client_BranchId]
GO

ALTER TABLE [dbo].[Client] WITH CHECK ADD CONSTRAINT [FK_ClientKycConfiguration_Client_ClientKycId] FOREIGN KEY([ClientKycId])
REFERENCES [dbo].[ClientKycConfiguration] ([Id])
GO

ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_ClientKycConfiguration_Client_ClientKycId]
GO

ALTER TABLE [dbo].[Client] WITH CHECK ADD CONSTRAINT [FK_ClientType_Client_ClientTypeId] FOREIGN KEY([ClientTypeId])
REFERENCES [dbo].[ClientType] ([Id])
GO

ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_ClientType_Client_ClientTypeId]
GO