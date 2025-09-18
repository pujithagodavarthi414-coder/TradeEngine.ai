Create  TABLE [dbo].[Booking](
	[Id] [uniqueidentifier] NOT NULL,
	[RoomId] [uniqueidentifier] NOT NULL,
	[EventTypeId] [uniqueidentifier] NULL,
	[RoomAmenityId] [nvarchar] (200) NULL,
	[VenueAmenityId] [nvarchar] (200) NULL,
	[BookingFrom] [datetime] NULL,
	[BookingTo] [datetime] NULL,
	[Tax] [decimal](15,3) NULL,
	[PaidAmount] [decimal](15,3) NULL,
	[ActualExpensesAmount] [decimal](15,3) NULL,
	[DamagesAmount] [decimal](15,3) NULL,
	[RefundedAmount] [decimal](15,3) NULL,
	[FromTime] [time] NOT NULL,
	[ToTime] [time] NOT NULL,
	[IsMultiple] [bit] NULL,
	[CanceledDateTime][datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Booking]  WITH CHECK ADD  CONSTRAINT [FK_Room_Booking_RoomId] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Room] ([Id])
GO

ALTER TABLE [dbo].[Booking] CHECK CONSTRAINT [FK_Room_Booking_RoomId]
GO

ALTER TABLE [dbo].[Booking]  WITH CHECK ADD  CONSTRAINT [FK_EventType_Booking_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventType] ([Id])
GO

ALTER TABLE [dbo].[Booking] CHECK CONSTRAINT [FK_EventType_Booking_EventTypeId]
GO
