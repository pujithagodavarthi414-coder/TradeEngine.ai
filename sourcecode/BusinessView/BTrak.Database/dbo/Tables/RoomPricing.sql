CREATE TABLE [RoomPricing](
    [Id] [uniqueidentifier] NOT NULL,
	[RoomId] [uniqueidentifier] NOT NULL,
	[EventPricingId] [uniqueidentifier] NOT NULL,
    [PricingCategoryTypeId] [uniqueidentifier] NOT NULL,
	[Cost] [decimal](15,3) NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] [timestamp] NULL,
    CONSTRAINT [PK_RoomPricing] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoomPricing]  WITH CHECK ADD  CONSTRAINT [FK_Room_RoomPricing_RoomId] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Room] ([Id])
GO
ALTER TABLE [dbo].[RoomPricing] CHECK CONSTRAINT [FK_Room_RoomPricing_RoomId]
GO
ALTER TABLE [dbo].[RoomPricing]  WITH CHECK ADD  CONSTRAINT [FK_EventPricing_RoomPricing_EventPricingId] FOREIGN KEY([EventPricingId])
REFERENCES [dbo].[EventPricing] ([Id])
GO
ALTER TABLE [dbo].[RoomPricing] CHECK CONSTRAINT [FK_EventPricing_RoomPricing_EventPricingId]
GO
ALTER TABLE [dbo].[RoomPricing]  WITH CHECK ADD  CONSTRAINT [FK_PricingCategoryType_RoomPricing_PricingCategoryTypeId] FOREIGN KEY([PricingCategoryTypeId])
REFERENCES [dbo].[PricingCategoryType] ([Id])
GO
ALTER TABLE [dbo].[RoomPricing] CHECK CONSTRAINT [FK_PricingCategoryType_RoomPricing_PricingCategoryTypeId]
GO