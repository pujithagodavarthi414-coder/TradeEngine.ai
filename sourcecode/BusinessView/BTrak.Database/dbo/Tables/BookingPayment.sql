CREATE TABLE [dbo].[BookingPayment](
	[Id] [uniqueidentifier] NOT NULL,
	[BookingId ] [uniqueidentifier] NULL,
	[CardTypeId] [uniqueidentifier] NULL,
	[CardHolderName] [nvarchar](255) NULL,
	[CardHolderBillingAddress] [nvarchar](800) NULL,
	[CardNumber] [nvarchar](255) NULL,
	[CardExpiryDate] [date] NULL,
	[CardSecurityCode] [nvarchar](255) NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_BookingPayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BookingPayment]  WITH CHECK ADD  CONSTRAINT [FK_Booking_BookingPayment_BookingId] FOREIGN KEY([BookingId ])
REFERENCES [dbo].[Booking] ([Id])
GO
ALTER TABLE [dbo].[BookingPayment] CHECK CONSTRAINT [FK_Booking_BookingPayment_BookingId]
GO
ALTER TABLE [dbo].[BookingPayment]  WITH CHECK ADD  CONSTRAINT [FK_CardType_BookingPayment_CardTypeId] FOREIGN KEY([CardTypeId])
REFERENCES [dbo].[CardType] ([Id])
GO
ALTER TABLE [dbo].[BookingPayment] CHECK CONSTRAINT [FK_CardType_BookingPayment_CardTypeId]
GO