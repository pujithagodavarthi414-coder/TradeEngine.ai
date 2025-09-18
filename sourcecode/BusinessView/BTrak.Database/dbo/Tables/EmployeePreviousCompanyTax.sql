CREATE  TABLE [dbo].[EmployeePreviousCompanyTax](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[TaxAmount] [decimal](18, 4) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsArchived] BIT
    CONSTRAINT [PK_EmployeePreviousCompanyTax] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeePreviousCompanyTax]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeePreviousCompanyTax_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeePreviousCompanyTax] CHECK CONSTRAINT [FK_EmployeePreviousCompanyTax_Employee_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeePreviousCompanyTax]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePreviousCompanyTax_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeePreviousCompanyTax] CHECK CONSTRAINT [FK_EmployeePreviousCompanyTax_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeePreviousCompanyTax]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePreviousCompanyTax_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EmployeePreviousCompanyTax] CHECK CONSTRAINT [FK_EmployeePreviousCompanyTax_User_UpdatedByUserId]
GO