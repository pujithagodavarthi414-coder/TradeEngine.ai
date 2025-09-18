CREATE TABLE [dbo].[EmployeeMembership](
    [Id] [uniqueidentifier] NOT NULL,
    [EmployeeId] [uniqueidentifier] NOT NULL,
    [MembershipId] [uniqueidentifier] NOT NULL,
    [SubscriptionId] [uniqueidentifier] NULL,
    [SubscriptionAmount] [decimal](18, 4) NULL,
    [CurrencyId] [uniqueidentifier] NULL,
    [CommenceDate] [datetime] NULL,
    [RenewalDate] [datetime] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL,
   [TimeStamp] TIMESTAMP,
   [NameOfTheCertificate] NVARCHAR(800) NULL, 
   [IssueCertifyingAuthority] NVARCHAR(800) NULL, 
    CONSTRAINT [PK_EmployeeMembership] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)
)
GO
ALTER TABLE [dbo].[EmployeeMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_EmployeeMembership_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[EmployeeMembership] CHECK CONSTRAINT [FK_Employee_EmployeeMembership_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeMembership]  WITH NOCHECK ADD CONSTRAINT [FK_SubscriptionPaidBy_EmployeeMembership_SubscriptionId] FOREIGN KEY ([SubscriptionId])
REFERENCES [dbo].[SubscriptionPaidBy] ([Id])
GO
ALTER TABLE [dbo].[EmployeeMembership] CHECK CONSTRAINT [FK_SubscriptionPaidBy_EmployeeMembership_SubscriptionId]
GO

ALTER TABLE [dbo].[EmployeeMembership]  WITH NOCHECK ADD CONSTRAINT [FK_MemberShip_EmployeeMembership_MembershipId] FOREIGN KEY ([MembershipId])
REFERENCES [dbo].[MemberShip] ([Id])
GO

ALTER TABLE [dbo].[EmployeeMembership] CHECK CONSTRAINT [FK_MemberShip_EmployeeMembership_MembershipId]
GO

ALTER TABLE [dbo].[EmployeeMembership]  WITH NOCHECK ADD  CONSTRAINT [FK_Currency_EmployeeMembership_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[EmployeeMembership] CHECK CONSTRAINT [FK_Currency_EmployeeMembership_CurrencyId]
GO
