CREATE TABLE [dbo].[EmployeeSalary](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[SalaryPayGradeId] [uniqueidentifier] NOT NULL,
	[SalaryComponent] [nvarchar](800) NULL,
	[SalaryPayFrequencyId] [uniqueidentifier] NOT NULL,
	[CurrencyId] [uniqueidentifier] NOT NULL,
	[Amount] [decimal](18, 4) NULL,
	[NetPayAmount] [decimal](18, 4) NULL,
	[Comments] [nvarchar](800) NULL,
	[IsAddedDepositDetails] [bit] NULL,
	[ActiveFrom] [datetime] NULL,
	[PaymentMethodId] [uniqueidentifier] NULL,
    [SalaryParticularsFileId] [uniqueidentifier] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeSalary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[EmployeeSalary]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeSalary_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalary] CHECK CONSTRAINT [FK_Employee_EmployeeSalary_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeSalary]  WITH CHECK ADD  CONSTRAINT [FK_PayFrequency_EmployeeSalary_SalaryPayFrequencyId] FOREIGN KEY([SalaryPayFrequencyId])
REFERENCES [dbo].[PayFrequency] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalary] CHECK CONSTRAINT [FK_PayFrequency_EmployeeSalary_SalaryPayFrequencyId]
GO
ALTER TABLE [dbo].[EmployeeSalary]  WITH CHECK ADD  CONSTRAINT [FK_PayGrade_EmployeeSalary_SalaryPayGradeId] FOREIGN KEY([SalaryPayGradeId])
REFERENCES [dbo].[PayGrade] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalary] CHECK CONSTRAINT [FK_PayGrade_EmployeeSalary_SalaryPayGradeId]
GO
ALTER TABLE [dbo].[EmployeeSalary]  WITH NOCHECK ADD  CONSTRAINT [FK_Currency_EmployeeSalary_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalary] CHECK CONSTRAINT [FK_Currency_EmployeeSalary_CurrencyId]
GO
ALTER TABLE [dbo].[EmployeeSalary]  WITH CHECK ADD  CONSTRAINT [FK_PaymentMethod_EmployeeSalary_PaymentMethodId] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[PaymentMethod] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalary] CHECK CONSTRAINT [FK_PaymentMethod_EmployeeSalary_PaymentMethodId]
GO

