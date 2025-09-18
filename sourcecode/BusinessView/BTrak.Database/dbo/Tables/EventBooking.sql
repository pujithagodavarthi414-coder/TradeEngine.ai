CREATE TABLE [dbo].[EventBooking](
	[Id] [uniqueidentifier] NOT NULL,
	[RoomId] [uniqueidentifier] NOT NULL,
	[EventTypeId] [uniqueidentifier] NOT NULL,
	[RoomAmenityId] [nvarchar],
	[BookingFrom] [datetime] NULL,
	[BookingTo] [datetime] NULL,
	[Tax] [decimal](15, 3) NULL,
	[PaidAmount] [decimal](15, 3) NULL,
	[ActualExpensesAmount] [decimal](15, 3) NULL,
	[DamagesAmount] [decimal](15, 3) NULL,
	[RefundedAmount] [decimal](15, 3) NULL,
	[CanceledDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_EventBooking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EventBooking]  WITH CHECK ADD  CONSTRAINT [FK_Event_EventBooking_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventBooking] ([Id])
GO
ALTER TABLE [dbo].[EventBooking] CHECK CONSTRAINT [FK_Event_EventBooking_EventTypeId]
GO
ALTER TABLE [dbo].[EventBooking]  WITH CHECK ADD  CONSTRAINT [FK_Room_EventBooking_RoomId] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Room] ([Id])
GO
ALTER TABLE [dbo].[EventBooking] CHECK CONSTRAINT [FK_Room_EventBooking_RoomId]
GO
--ALTER TABLE [dbo].[EventBooking]  WITH CHECK ADD  CONSTRAINT [FK_RoomAmenity_EventBooking_RoomAmenityId] FOREIGN KEY([RoomAmenityId])
--REFERENCES [dbo].[RoomAmenity] ([Id])
--GO
--ALTER TABLE [dbo].[EventBooking] CHECK CONSTRAINT [FK_RoomAmenity_EventBooking_RoomAmenityId]
--GO

