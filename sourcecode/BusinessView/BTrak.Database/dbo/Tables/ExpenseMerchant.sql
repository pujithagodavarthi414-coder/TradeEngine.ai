CREATE TABLE [dbo].[ExpenseMerchant](
    [Id] [uniqueidentifier] NOT NULL,
	[ExpenseId] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NULL,
    [MerchantName] [nvarchar](250) NOT NULL,
	[StatusId] [uniqueidentifier] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[OriginalCreatedByUserId] [uniqueidentifier] NULL,
	[OriginalCreatedDateTime] [datetime] NULL,
	[OriginalId] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
	[AsAtInactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ExpenseMerchant] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ExpenseMerchant] ADD  DEFAULT ((1)) FOR [VersionNumber]
GO

ALTER TABLE [dbo].[ExpenseMerchant]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseMerchant_ExpenseMerchant_OriginalId] FOREIGN KEY([OriginalId])
REFERENCES [dbo].[ExpenseMerchant] ([Id])
GO

ALTER TABLE [dbo].[ExpenseMerchant] CHECK CONSTRAINT [FK_ExpenseMerchant_ExpenseMerchant_OriginalId]
GO

ALTER TABLE [dbo].[ExpenseMerchant] WITH CHECK ADD CONSTRAINT [FK_Branch_ExpenseMerchant_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[ExpenseMerchant] CHECK CONSTRAINT [FK_Branch_ExpenseMerchant_BranchId]
GO
