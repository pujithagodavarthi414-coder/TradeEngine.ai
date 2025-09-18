CREATE TABLE [dbo].[Asset](
	[Id] [uniqueidentifier] NOT NULL,
	[AssetNumber] [nvarchar](50) NOT NULL,
	[PurchasedDate] [datetime] NOT NULL,
	[ProductId] [uniqueidentifier] NULL,
	[ProductDetailsId] [uniqueidentifier] NULL,
	[AssetName] [nvarchar](50) NOT NULL,
	[Cost] [decimal](18, 0) NULL,
	[CurrencyId] [uniqueidentifier] NOT NULL,
	[IsWriteOff] [bit] NULL,
	[DamagedDate] [datetime] NULL,
	[DamagedReason] [nvarchar](800) NULL,
	[IsEmpty] [bit] NOT NULL,
	[IsVendor] [bit] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[DamagedByUserId] UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
    [SeatingId] UNIQUEIDENTIFIER NULL, 
    [BranchId] UNIQUEIDENTIFIER NOT NULL, 
    CONSTRAINT [PK_Asset] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[Asset]  WITH NOCHECK ADD CONSTRAINT [FK_Product_Asset_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO

ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Product_Asset_ProductId]
GO

ALTER TABLE [dbo].[Asset]  WITH NOCHECK ADD CONSTRAINT [FK_ProductDetails_Asset_ProductDetailsId] FOREIGN KEY ([ProductDetailsId])
REFERENCES [dbo].[ProductDetails] ([Id])
GO

ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_ProductDetails_Asset_ProductDetailsId]
GO

ALTER TABLE [dbo].[Asset]  WITH NOCHECK ADD CONSTRAINT [FK_User_Asset_DamagedByUserId] FOREIGN KEY ([DamagedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_User_Asset_DamagedByUserId]
GO

ALTER TABLE [dbo].[Asset]  WITH NOCHECK ADD CONSTRAINT [FK_Asset_Currency_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Asset_Currency_CurrencyId]
GO