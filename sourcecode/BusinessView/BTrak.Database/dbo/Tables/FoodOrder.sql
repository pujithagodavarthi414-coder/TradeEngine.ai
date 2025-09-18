CREATE TABLE [dbo].[FoodOrder](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[FoodItemName] [nvarchar](800) NOT NULL,
	[Amount] [money] NULL,
	[CurrencyId] [uniqueidentifier] NULL,
	[Comment] [nvarchar](250) NULL,
	[ClaimedByUserId] [uniqueidentifier] NOT NULL,
	[StatusSetByUserId] [uniqueidentifier] NULL,
	[FoodOrderStatusId] [uniqueidentifier] NOT NULL,
	[OrderedDateTime] [datetime] NULL,
	[StatusSetDateTime] [datetime] NULL,
	[Reason] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_FoodOrder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[FoodOrder]  WITH CHECK ADD  CONSTRAINT [FK_FoodOrder_FoodOrderStatus] FOREIGN KEY([FoodOrderStatusId])
REFERENCES [dbo].[FoodOrderStatus] ([Id])
GO

ALTER TABLE [dbo].[FoodOrder] CHECK CONSTRAINT [FK_FoodOrder_FoodOrderStatus]
GO

CREATE NONCLUSTERED INDEX IX_FoodOrder_CompanyId 
ON [dbo].[FoodOrder] ([CompanyId])
INCLUDE ([Amount],[FoodOrderStatusId],[OrderedDateTime])
GO