CREATE TABLE [dbo].[UserPurchasedCanteenFoodItem](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[FoodItemId] [uniqueidentifier] NULL,
	[Quantity] [int] NOT NULL,
	[PurchasedDateTime] [datetime] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	
 [FoodItemPrice] MONEY NULL, 
    CONSTRAINT [PK_UserPurchasedCanteenFoodItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[UserPurchasedCanteenFoodItem]  WITH CHECK ADD  CONSTRAINT [FK_UserPurchasedCanteenFoodItem_CanteenFoodItem] FOREIGN KEY([FoodItemId])
REFERENCES [dbo].[CanteenFoodItem] ([Id])
GO

ALTER TABLE [dbo].[UserPurchasedCanteenFoodItem] CHECK CONSTRAINT [FK_UserPurchasedCanteenFoodItem_CanteenFoodItem]
GO

ALTER TABLE [dbo].[UserPurchasedCanteenFoodItem]  WITH CHECK ADD  CONSTRAINT [FK_UserPurchasedCanteenFoodItem_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserPurchasedCanteenFoodItem] CHECK CONSTRAINT [FK_UserPurchasedCanteenFoodItem_User]
GO

CREATE NONCLUSTERED INDEX IDX_UserPurchasedCanteenFoodItem_FoodItemId 
ON [dbo].[UserPurchasedCanteenFoodItem] (  FoodItemId ASC  )   
INCLUDE ( Quantity , UserId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserPurchasedCanteenFoodItem_UserId 
ON [dbo].[UserPurchasedCanteenFoodItem] (  UserId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO