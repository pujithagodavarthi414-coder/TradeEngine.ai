CREATE TABLE [dbo].[FoodOrderUser](
	[Id] [uniqueidentifier] NOT NULL,
	[OrderId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_FoodOrderUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_FoodOrderUser_OrderId_UserId] UNIQUE ([OrderId],[UserId])
)
GO
ALTER TABLE [dbo].[FoodOrderUser]  WITH CHECK ADD  CONSTRAINT [FK_FoodOrderUser_FoodOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[FoodOrder] ([Id])
GO

ALTER TABLE [dbo].[FoodOrderUser] CHECK CONSTRAINT [FK_FoodOrderUser_FoodOrder]
GO
ALTER TABLE [dbo].[FoodOrderUser]  WITH CHECK ADD  CONSTRAINT [FK_FoodOrderUser_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FoodOrderUser] CHECK CONSTRAINT [FK_FoodOrderUser_User]
GO