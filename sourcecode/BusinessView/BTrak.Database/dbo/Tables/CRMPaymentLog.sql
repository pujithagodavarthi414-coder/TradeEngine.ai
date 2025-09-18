CREATE TABLE [dbo].[CRMPaymentLog]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ReceiverId] [uniqueidentifier] NOT NULL,
	[PaymentType] [uniqueidentifier] NOT NULL,
	[AmountDue] [int] NOT NULL,
	[AmountPaid] [int] NOT NULL,
	[ChequeNumber] nvarchar(250) NULL,
	[BankName] nvarchar(250) NULL,
	[BenificiaryName] nvarchar(250) NULL,
	[PaidBy] nvarchar(250),
	[CompanyId] [uniqueidentifier],
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_CRMPaymentLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
)
GO
