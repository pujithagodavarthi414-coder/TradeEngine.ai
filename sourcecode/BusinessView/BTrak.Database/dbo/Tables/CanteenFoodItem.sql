CREATE TABLE [dbo].[CanteenFoodItem](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[FoodItemName] [nvarchar](500) NULL,
	[Price] [money] NOT NULL,
	[CurrencyId] [uniqueidentifier] NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 [BranchId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_CanteenFoodItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_CanteenFoodItem_Branch] FOREIGN KEY ([BranchId]) REFERENCES [Branch]([Id]),
)
GO

ALTER TABLE [dbo].[CanteenFoodItem]  WITH CHECK ADD  CONSTRAINT [FK_CanteenFoodItem_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CanteenFoodItem] CHECK CONSTRAINT [FK_CanteenFoodItem_User]
GO

ALTER TABLE [dbo].[CanteenFoodItem]  WITH CHECK ADD  CONSTRAINT [FK_CanteenFoodItem_Currency_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[CanteenFoodItem] CHECK CONSTRAINT [FK_CanteenFoodItem_Currency_CurrencyId]
GO
