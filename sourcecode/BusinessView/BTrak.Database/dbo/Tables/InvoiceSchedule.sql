CREATE TABLE [dbo].[InvoiceSchedule](
	[Id] [uniqueidentifier] NOT NULL,
	[ScheduleName] [nvarchar](150) NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[CurrencyId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CompanyLogo] [nvarchar](800) NULL,
	[ScheduleStartDate] [datetime] NOT NULL,
	[ScheduleTypeId] [uniqueidentifier] NOT NULL,
	[Extension] [int] NULL,
	[RatePerHour] [decimal](18, 4) NOT NULL, 
	[HoursPerSchedule] [int] NOT NULL,
	[ExcessHoursRate] [decimal](18, 4) NULL,
	[ExcessHours] [int] NULL,
	[ScheduleSequenceId] [nvarchar](100) NULL,
	[ScheduleSequenceQuantity] [int] NOT NULL,
	[LateFees] [decimal](18, 4) NULL,
	[LateFeesDays] [int] NULL,
	[Description] [nvarchar](MAX) NULL,
	[SendersName] [nvarchar](800) NULL,
	[SendersAddress] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_InvoiceSchedule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_New_InvoiceSchedule_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceSchedule] CHECK CONSTRAINT [FK_Invoice_New_InvoiceSchedule_InvoiceId]
GO

ALTER TABLE [dbo].[InvoiceSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Currency_InvoiceSchedule_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[InvoiceSchedule] CHECK CONSTRAINT [FK_Currency_InvoiceSchedule_CurrencyId]
GO
