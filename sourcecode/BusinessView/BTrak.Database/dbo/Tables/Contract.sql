CREATE TABLE [dbo].[Contract]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
	[EmployeeId] [uniqueidentifier] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL,
    [ContractDetails] [nvarchar](2000) NULL,
	[ContractTypeId] [uniqueidentifier] NOT NULL,
    [ContractedHours] [int] NULL,
    [HourlyRate] [int] NULL,
    [HolidayOrThisYear] [nvarchar](500) NULL,
    [HolidayOrFullEntitlement] [nvarchar](500) NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
    [CurrencyId] UNIQUEIDENTIFIER NULL,
)
GO

ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD CONSTRAINT [FK_ContractType_Contract_ContractTypeId] FOREIGN KEY ([ContractTypeId])
REFERENCES [dbo].[ContractType] ([Id])
GO

ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_ContractType_Contract_ContractTypeId]
GO

ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD CONSTRAINT [FK_Employee_Contract_EmployeeId] FOREIGN KEY ([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Employee_Contract_EmployeeId]
GO