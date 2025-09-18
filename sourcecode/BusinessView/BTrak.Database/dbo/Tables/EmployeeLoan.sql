CREATE  TABLE [dbo].[EmployeeLoan](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](250) NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[LoanAmount] [decimal](18, 4) NOT NULL,	
	[LoanTakenOn] [datetime]  NULL,
	[LoanInterestPercentagePerMonth] [decimal](18,6) NOT NULL,	
	[TimePeriodInMonths] [decimal](18, 4) NULL,
	[LoanTypeId] [uniqueidentifier] NULL,
	[CompoundedPeriodId] [uniqueidentifier] NULL,
	[LoanPaymentStartDate] [datetime] NULL,
    [LoanBalanceAmount] [decimal](18, 4) NULL,	
	[LoanTotalPaidAmount] [decimal](18, 4) NULL,	
	[LoanClearedDate] [datetime]  NULL,
	[IsApproved] [BIT] NULL,
	[Description] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsPaid] BIT NULL,
	[IsProcessed] BIT NULL,
    CONSTRAINT [PK_EmployeeLoan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeLoan]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeLoan_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoan] CHECK CONSTRAINT [FK_EmployeeLoan_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeLoan]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeLoan_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoan] CHECK CONSTRAINT [FK_EmployeeLoan_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeLoan]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeLoan_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoan] CHECK CONSTRAINT [FK_EmployeeLoan_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[EmployeeLoan]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeLoan_LoanType_LoanTypeId] FOREIGN KEY([LoanTypeId])
REFERENCES [dbo].[LoanType] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoan] CHECK CONSTRAINT [FK_EmployeeLoan_LoanType_LoanTypeId]
GO

ALTER TABLE [dbo].[EmployeeLoan]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeLoan_PeriodType_CompoundedPeriodId] FOREIGN KEY([CompoundedPeriodId])
REFERENCES [dbo].[PeriodType] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoan] CHECK CONSTRAINT [FK_EmployeeLoan_PeriodType_CompoundedPeriodId]
GO