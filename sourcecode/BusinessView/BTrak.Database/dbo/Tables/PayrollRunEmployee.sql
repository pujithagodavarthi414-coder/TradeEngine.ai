CREATE  TABLE [dbo].[PayrollRunEmployee](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId] [uniqueidentifier] NULL,
	[PayrollRunId] [uniqueidentifier] NOT NULL,
	PayrollStatusId [uniqueidentifier] NOT NULL,
	EmployeeSalary FLOAT,
	ActualEmployeeSalary FLOAT,
	OneDaySalary FLOAT,
	[PaidAmount] [decimal](18, 4) NOT NULL,
	[ActualPaidAmount] [decimal](18, 4) NULL,
	Earning FLOAT, 
	Deduction FLOAT,
	ActualEarning FLOAT, 
	ActualDeduction FLOAT,
	OriginalPaidAmount [decimal](18, 4) NULL,
	OriginalActualPaidAmount [decimal](18, 4) NULL,
	OriginalEarning FLOAT, 
	OriginalDeduction FLOAT,
	OriginalActualEarning FLOAT, 
	OriginalActualDeduction FLOAT,
	[EmployeeName] [nvarchar](250) NULL,
	[Address] [nvarchar](2000) NULL,
	[BankAccountDetailsJson] [nvarchar](MAX) NULL,
	[TotalAmountPaid] [decimal](18, 4)  NULL,
	[LoanAmountRemaining]  [decimal](18, 4)  NULL,
	[OriginalTotalAmountPaid] [decimal](18, 4)  NULL,
	[OriginalLoanAmountRemaining]  [decimal](18, 4)  NULL,
	[TotalDaysInPayroll] FLOAT  NULL,
	[TotalWorkingDays] FLOAT  NULL,
	[PlannedHolidays] FLOAT  NULL,
	[SickDays] FLOAT  NULL,
	[UnplannedHolidays] FLOAT  NULL,
	TotalLeaves FLOAT  NULL,
	AllowedLeaves FLOAT  NULL,
	PaidLeaves FLOAT  NULL,
	UnPaidLeaves FLOAT  NULL,
	LeavesTaken FLOAT NULL,
	LossOfPay FLOAT NULL,
	IsLossOfPayMonth BIT NULL,
	EffectiveWorkingDays FLOAT NULL,
	EncashedLeaves FLOAT NULL,
	[TotalEarningsToDate] [decimal](18, 4)  NULL,
	[ActualEarningsToDate] [decimal](18, 4)  NULL,
	[TotalDeductionsToDate] [decimal](18, 4)  NULL,
	[ActualDeductionsToDate] [decimal](18, 4)  NULL,
	[OriginalTotalEarningsToDate] [decimal](18, 4)  NULL,
	[OriginalActualEarningsToDate] [decimal](18, 4)  NULL,
	[OriginalTotalDeductionsToDate] [decimal](18, 4)  NULL,
	[OriginalActualDeductionsToDate] [decimal](18, 4)  NULL,
	IsInResignation BIT NULL,
	IsManualLeaveManagement BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsHold] BIT,
	[IsProcessedToPay] BIT NULL,
    [IsPayslipReleased] BIT DEFAULT 0, 
    CONSTRAINT [PK_PayrollRunEmployee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollRunEmployee]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunEmployee_PayrollRun_PayrollRunId] FOREIGN KEY([PayrollRunId])
REFERENCES [dbo].[PayrollRun] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployee] CHECK CONSTRAINT [FK_PayrollRunEmployee_PayrollRun_PayrollRunId]
GO
ALTER TABLE [dbo].[PayrollRunEmployee]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunEmployee_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployee] CHECK CONSTRAINT [FK_PayrollRunEmployee_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[PayrollRunEmployee]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunEmployee_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployee] CHECK CONSTRAINT [FK_PayrollRunEmployee_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollRunEmployee]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunEmployee_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployee] CHECK CONSTRAINT [FK_PayrollRunEmployee_User_UpdatedByUserId]
GO