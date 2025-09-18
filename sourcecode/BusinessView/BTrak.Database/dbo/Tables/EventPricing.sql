CREATE TABLE [EventPricing](
    [Id] [uniqueidentifier] NOT NULL,
	[EventTypeId] [uniqueidentifier] NOT NULL,
    [PricingTypeId] [uniqueidentifier] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] [timestamp] NULL,
    CONSTRAINT [PK_EventPricing] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventPricing]  WITH CHECK ADD  CONSTRAINT [FK_PricingType_EventPricing_PricingTypeId] FOREIGN KEY([PricingTypeId])
REFERENCES [dbo].[PricingType] ([Id])
GO
ALTER TABLE [dbo].[EventPricing] CHECK CONSTRAINT [FK_PricingType_EventPricing_PricingTypeId]
GO
ALTER TABLE [dbo].[EventPricing]  WITH CHECK ADD  CONSTRAINT [FK_EventType_EventPricing_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventType] ([Id])
GO
ALTER TABLE [dbo].[EventPricing] CHECK CONSTRAINT [FK_EventType_EventPricing_EventTypeId]
GO
