CREATE TABLE [dbo].[EmployeeCreditorDetails]
(
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[BankId] [uniqueidentifier] NULL,
	[BankName] [nvarchar](250) NULL,
	[AccountNumber] [nvarchar](50) NOT NULL,
	[AccountName] [nvarchar](250) NOT NULL,
	[IfScCode] [nvarchar](100) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP, 
	[Email] [nvarchar](250) NULL,
	[MobileNo] [nvarchar](250) NULL,
    [UseForPerformaInvoice] BIT NULL, 
    [PanNumber] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_EmployeeCreditorDetails] PRIMARY KEY ([Id]),
)
GO

ALTER TABLE [dbo].[EmployeeCreditorDetails]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCreditorDetails_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeCreditorDetails] CHECK CONSTRAINT [FK_EmployeeCreditorDetails_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeCreditorDetails]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCreditorDetails_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeCreditorDetails] CHECK CONSTRAINT [FK_EmployeeCreditorDetails_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeCreditorDetails]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeCreditorDetails_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[EmployeeCreditorDetails] CHECK CONSTRAINT [FK_EmployeeCreditorDetails_Branch_BranchId]
GO
ALTER TABLE [dbo].[EmployeeCreditorDetails]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeCreditorDetails_Bank_BankId] FOREIGN KEY([BankId])
REFERENCES [dbo].[Bank] ([Id])
GO

ALTER TABLE [dbo].[EmployeeCreditorDetails] CHECK CONSTRAINT [FK_EmployeeCreditorDetails_Bank_BankId]
GO