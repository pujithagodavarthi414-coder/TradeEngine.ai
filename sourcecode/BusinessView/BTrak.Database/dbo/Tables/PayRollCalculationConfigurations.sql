CREATE TABLE [dbo].[PayRollCalculationConfigurations]
(
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[PeriodTypeId] [uniqueidentifier] NOT NULL,
	[PayRollCalculationTypeId] [uniqueidentifier] NOT NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	 CONSTRAINT [PK_PayRollCalculationConfigurations] PRIMARY KEY ([Id]),
)
GO

ALTER TABLE [dbo].[PayRollCalculationConfigurations]  WITH CHECK ADD  CONSTRAINT [FK_PayRollCalculationConfigurations_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayRollCalculationConfigurations] CHECK CONSTRAINT [FK_PayRollCalculationConfigurations_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayRollCalculationConfigurations]  WITH CHECK ADD  CONSTRAINT [FK_PayRollCalculationConfigurations_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayRollCalculationConfigurations] CHECK CONSTRAINT [FK_PayRollCalculationConfigurations_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[PayRollCalculationConfigurations]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollCalculationConfigurations_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[PayRollCalculationConfigurations] CHECK CONSTRAINT [FK_PayRollCalculationConfigurations_Branch_BranchId]
GO
ALTER TABLE [dbo].[PayRollCalculationConfigurations]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollCalculationConfigurations_PeriodType_PeriodTypeId] FOREIGN KEY([PeriodTypeId])
REFERENCES [dbo].[PeriodType] ([Id])
GO

ALTER TABLE [dbo].[PayRollCalculationConfigurations] CHECK CONSTRAINT [FK_PayRollCalculationConfigurations_PeriodType_PeriodTypeId]
GO
ALTER TABLE [dbo].[PayRollCalculationConfigurations]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollCalculationConfigurations_PayRollCalculationType_PayRollCalculationTypeId] FOREIGN KEY([PayRollCalculationTypeId])
REFERENCES [dbo].[PayRollCalculationType] ([Id])
GO

ALTER TABLE [dbo].[PayRollCalculationConfigurations] CHECK CONSTRAINT [FK_PayRollCalculationConfigurations_PayRollCalculationType_PayRollCalculationTypeId]
GO