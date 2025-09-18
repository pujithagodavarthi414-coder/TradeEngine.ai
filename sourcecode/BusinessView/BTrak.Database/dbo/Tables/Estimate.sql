CREATE TABLE [dbo].[Estimate](
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NOT NULL,
	[CurrencyId] [uniqueidentifier] NULL,
	[EstimateStatusId] [uniqueidentifier] NOT NULL,
	[EstimateNumber] [nvarchar](50) NOT NULL,
	[EstimateImageUrl] [nvarchar](MAX) NULL,
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
 CONSTRAINT [PK_Estimate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[Estimate] WITH CHECK ADD CONSTRAINT [FK_Client_Estimate_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([Id])
GO

ALTER TABLE [dbo].[Estimate] CHECK CONSTRAINT [FK_Client_Estimate_ClientId]
GO

ALTER TABLE [dbo].[Estimate] WITH CHECK ADD CONSTRAINT [FK_Branch_Estimate_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[Estimate] CHECK CONSTRAINT [FK_Branch_Estimate_BranchId]
GO

ALTER TABLE [dbo].[Estimate] WITH CHECK ADD CONSTRAINT [FK_ScheduleType_Estimate_ScheduleTypeId] FOREIGN KEY([ScheduleTypeId])
REFERENCES [dbo].[ScheduleType] ([Id])
GO

ALTER TABLE [dbo].[Estimate] CHECK CONSTRAINT [FK_ScheduleType_Estimate_ScheduleTypeId]
GO

ALTER TABLE [dbo].[Estimate] WITH CHECK ADD CONSTRAINT [FK_InvoiceStatus_Estimate_EstimateStatusId] FOREIGN KEY([EstimateStatusId])
REFERENCES [dbo].[InvoiceStatus] ([Id])
GO

ALTER TABLE [dbo].[Estimate] CHECK CONSTRAINT [FK_InvoiceStatus_Estimate_EstimateStatusId]
GO

ALTER TABLE [dbo].[Estimate] WITH CHECK ADD CONSTRAINT [FK_Company_Estimate_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[Estimate] CHECK CONSTRAINT [FK_Company_Estimate_CompanyId]
GO
