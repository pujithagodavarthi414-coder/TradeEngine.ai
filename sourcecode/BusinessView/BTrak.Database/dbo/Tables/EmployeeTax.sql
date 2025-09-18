CREATE TABLE [dbo].[EmployeeTax]
(
	[Id] [uniqueidentifier] NOT NULL,
	EmployeeId UNIQUEIDENTIFIER,
	TaxFinancialYearFromDate DATE,
	TaxFinancialYearToDate DATE,
	WithOutFlatSlabRateTaxableAmount FLOAT,
	WithOutFlatSlabRateTax FLOAT,
	WithFlatSlabRateTaxableAmount FLOAT,
	WithFlatSlabRateTax FLOAT,
	IsWithOutFlatSlabRate BIT,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP
    CONSTRAINT [PK_EmployeeTax] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeTax]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeTax_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTax] CHECK CONSTRAINT [FK_EmployeeTax_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeTax]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTax_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTax] CHECK CONSTRAINT [FK_EmployeeTax_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeTax]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTax_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTax] CHECK CONSTRAINT [FK_EmployeeTax_User_UpdatedByUserId]
GO