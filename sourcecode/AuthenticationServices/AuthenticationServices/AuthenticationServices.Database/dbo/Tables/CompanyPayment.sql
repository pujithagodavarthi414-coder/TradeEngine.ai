CREATE TABLE [dbo].[CompanyPayment](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[Noofpurchasedlicences] INT NULL,
	[PurchasedDatetime] DATETIME NULL,
	[TotalAmountPaid] [decimal](15,3) NULL,
	[SubscriptionType] [nvarchar](255) NULL,
	[StripeTokenId] [nvarchar](MAX) NULL,
	[StripeCustomerId] [nvarchar](MAX) NULL,
	[StripePaymentId] [nvarchar](MAX) NULL,
	[PricingId] [nvarchar](MAX) NULL,
	[SubscriptionId] [nvarchar](MAX) NULL,
	[PurchaseType] [nvarchar](250) NULL,
	[IsSubscriptionDone] BIT NULL,
	[Status] NVARCHAR(250) NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
	[IsCancelled] [BIT] NULL,
	[IsRenewal] [BIT] NULL,
	[IsUpdate] [BIT] NULL,
	[CurrentPeriodStart] DATETIME NULL,
	[CurrentPeriodEnd] DATETIME NULL,
	[CancelAt] DATETIME NULL,
	[InvoiceId] [nvarchar](MAX) NULL,
 CONSTRAINT [PK_CompanyPayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CompanyPayment]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_CompanyPayment_CompanyId] FOREIGN KEY(CompanyId)
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[CompanyPayment] CHECK CONSTRAINT [FK_Company_CompanyPayment_CompanyId]
GO