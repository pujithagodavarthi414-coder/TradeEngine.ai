CREATE  TABLE [dbo].[EmployeeLoanInstallment](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeLoanId] [uniqueidentifier] NOT NULL,
	[PrincipalAmount] [decimal](18, 4) NULL,
	[InstallmentAmount] [decimal](18, 4) NULL,
	[OriginalInstallmentAmount] [decimal](18, 4) NULL,
	[InstalmentDate] [datetime]  NULL,
	[PaidAmount] [decimal](18, 4) NULL,
	Interest FLOAT,
	ClosingBalance FLOAT,
	ClosingBalanceWithInterest FLOAT,
	OpeningBalance FLOAT,
	OpeningBalanceWithInterest FLOAT,
	[IsTobePaid] BIT NULL,
	[IsArchived] BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_EmployeeLoanInstallment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeLoanInstallment]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeLoanInstallment_EmployeeLoan_EmployeeLoanId] FOREIGN KEY([EmployeeLoanId])
REFERENCES [dbo].[EmployeeLoan] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoanInstallment] CHECK CONSTRAINT [FK_EmployeeLoanInstallment_EmployeeLoan_EmployeeLoanId]
GO

ALTER TABLE [dbo].[EmployeeLoanInstallment]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeLoanInstallment_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoanInstallment] CHECK CONSTRAINT [FK_EmployeeLoanInstallment_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeLoanInstallment]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeLoanInstallment_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLoanInstallment] CHECK CONSTRAINT [FK_EmployeeLoanInstallment_User_UpdatedByUserId]
GO