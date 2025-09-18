CREATE TABLE [dbo].[BankDetail]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [EmployeeId] [uniqueidentifier] NOT NULL,
    [IFSCCode] [nvarchar](500) NULL,
    [AccountNumber] [nvarchar](20) NOT NULL,
    [AccountName] [nvarchar](500) NOT NULL,
    [BuildingSocietyRollNumber] [nvarchar](500) NULL,
    [BankId] [uniqueidentifier] NULL,
	[BankName] [nvarchar](500) NULL,
    [BranchName] [nvarchar](500) NOT NULL,
    [DateFrom] [datetime] NOT NULL,
	[EffectiveFrom] [datetime] NULL,
    [EffectiveTo] [datetime] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
)
GO

ALTER TABLE [dbo].[BankDetail]  WITH NOCHECK ADD CONSTRAINT [FK_Employee_BankDetail_EmployeeId] FOREIGN KEY ([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[BankDetail] CHECK CONSTRAINT [FK_Employee_BankDetail_EmployeeId]
GO
ALTER TABLE [dbo].[BankDetail]  WITH NOCHECK ADD CONSTRAINT [FK_BankDetail_Bank_BankId] FOREIGN KEY([BankId])
REFERENCES [dbo].[Bank] ([Id])
GO

ALTER TABLE [dbo].[BankDetail] CHECK CONSTRAINT [FK_BankDetail_Bank_BankId]
GO