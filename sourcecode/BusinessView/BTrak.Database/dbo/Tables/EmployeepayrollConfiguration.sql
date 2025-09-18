CREATE   TABLE [dbo].[EmployeepayrollConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId] [uniqueidentifier] NULL,
	[TaxCalculationTypeId] [uniqueidentifier] NULL,
	[SalaryId] [uniqueidentifier] NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime]  NULL,
	[IsApproved] [bit] NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,

    CONSTRAINT [PK_EmployeepayrollConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeepayrollConfiguration_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration] CHECK CONSTRAINT [FK_EmployeepayrollConfiguration_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeepayrollConfiguration_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration] CHECK CONSTRAINT [FK_EmployeepayrollConfiguration_PayrollTemplate_PayrollTemplateId]
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_EmployeepayrollConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration] CHECK CONSTRAINT [FK_EmployeepayrollConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeepayrollConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_EmployeepayrollConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration] CHECK CONSTRAINT [FK_EmployeepayrollConfiguration_User_UpdatedByUserId]
GO


ALTER TABLE [dbo].[EmployeepayrollConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeepayrollConfiguration_EmployeeSalary_SalaryId] FOREIGN KEY([SalaryId])
REFERENCES [dbo].[EmployeeSalary] ([Id])
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration] CHECK CONSTRAINT [FK_EmployeepayrollConfiguration_EmployeeSalary_SalaryId]
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeepayrollConfiguration_TaxCalculationType_TaxCalculationTypeId] FOREIGN KEY([TaxCalculationTypeId])
REFERENCES [dbo].[TaxCalculationType] ([Id])
GO

ALTER TABLE [dbo].[EmployeepayrollConfiguration] CHECK CONSTRAINT [FK_EmployeepayrollConfiguration_TaxCalculationType_TaxCalculationTypeId]
GO