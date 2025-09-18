CREATE TABLE [dbo].[Invoice_New](
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NOT NULL,
	[CurrencyId] [uniqueidentifier] NULL,
	[InvoiceStatusId] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [nvarchar](50) NOT NULL,
	[InvoiceImageUrl] [nvarchar](MAX) NULL,
	[BranchId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CC] [nvarchar](MAX) NULL,
	[BCC] [nvarchar](MAX) NULL,
	[Title] [nvarchar](150) NULL,
	[PO] [nvarchar](50) NULL,
	[IsRecurring] [bit] NULL,
	[ScheduleTypeId] [uniqueidentifier] NULL,
	[IssueDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[Discount] float NULL,
	[TotalAmount] float NULL,
	[SubTotalAmount] float NULL,
	[DiscountAmount] float NULL,
	[Notes] [nvarchar](800) NULL,
	[Terms] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_Invoice_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[Invoice_New] WITH CHECK ADD CONSTRAINT [FK_Client_Invoice_New_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([Id])
GO

ALTER TABLE [dbo].[Invoice_New] CHECK CONSTRAINT [FK_Client_Invoice_New_ClientId]
GO

ALTER TABLE [dbo].[Invoice_New] WITH CHECK ADD CONSTRAINT [FK_Branch_Invoice_New_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[Invoice_New] CHECK CONSTRAINT [FK_Branch_Invoice_New_BranchId]
GO

ALTER TABLE [dbo].[Invoice_New] WITH CHECK ADD CONSTRAINT [FK_ScheduleType_Invoice_New_ScheduleTypeId] FOREIGN KEY([ScheduleTypeId])
REFERENCES [dbo].[ScheduleType] ([Id])
GO

ALTER TABLE [dbo].[Invoice_New] CHECK CONSTRAINT [FK_ScheduleType_Invoice_New_ScheduleTypeId]
GO

ALTER TABLE [dbo].[Invoice_New] WITH CHECK ADD CONSTRAINT [FK_InvoiceStatus_Invoice_New_InvoiceStatusId] FOREIGN KEY([InvoiceStatusId])
REFERENCES [dbo].[InvoiceStatus] ([Id])
GO

ALTER TABLE [dbo].[Invoice_New] CHECK CONSTRAINT [FK_InvoiceStatus_Invoice_New_InvoiceStatusId]
GO

ALTER TABLE [dbo].[Invoice_new] WITH CHECK ADD CONSTRAINT [FK_Company_Invoice_New_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[Invoice_new] CHECK CONSTRAINT [FK_Company_Invoice_New_CompanyId]
GO
