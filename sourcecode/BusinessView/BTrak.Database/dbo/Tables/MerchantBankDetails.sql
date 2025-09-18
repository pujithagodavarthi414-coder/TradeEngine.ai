CREATE TABLE [dbo].[MerchantBankDetails](
    [Id] [uniqueidentifier] NOT NULL,
	[ExpenseMerchantId] [uniqueidentifier] NOT NULL,
	[PayeeName] [nvarchar](250) NULL,
	[BankName] [nvarchar](250) NULL,
	[BranchName] [nvarchar](250) NULL,
	[AccountNumber] [nvarchar](250) NULL,
	[IFSCCode] [nvarchar](250) NULL,
	[SortCode] [nvarchar](250) NULL,
    [CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[OriginalCreatedByUserId] [uniqueidentifier] NULL,
	[OriginalCreatedDateTime] [datetime] NULL,
	[OriginalId] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
	[AsAtInactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_MerchantBankDetails] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MerchantBankDetails] ADD  DEFAULT ((1)) FOR [VersionNumber]
GO

ALTER TABLE [dbo].[MerchantBankDetails]  WITH CHECK ADD  CONSTRAINT [FK_MerchantBankDetails_MerchantBankDetails_OriginalId] FOREIGN KEY([OriginalId])
REFERENCES [dbo].[MerchantBankDetails] ([Id])
GO

ALTER TABLE [dbo].[MerchantBankDetails] CHECK CONSTRAINT [FK_MerchantBankDetails_MerchantBankDetails_OriginalId]
GO

ALTER TABLE [dbo].[MerchantBankDetails] WITH CHECK ADD CONSTRAINT [FK_ExpenseMerchant_MerchantBankDetails_ExpenseMerchantId] FOREIGN KEY([ExpenseMerchantId])
REFERENCES [dbo].[ExpenseMerchant] ([Id])
GO

ALTER TABLE [dbo].[MerchantBankDetails] CHECK CONSTRAINT [FK_ExpenseMerchant_MerchantBankDetails_ExpenseMerchantId]
GO
