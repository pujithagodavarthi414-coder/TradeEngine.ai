CREATE TABLE [dbo].[FinancialYearConfigurations]
(
	[Id] [uniqueidentifier] NOT NULL,
	FinancialYearTypeId [uniqueidentifier] NULL, 
	[FromMonth] INT NULL,
	[ToMonth] INT NULL, 
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] DateTime NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP, 
	[BranchId] [uniqueidentifier] NULL,
	[CountryId] [uniqueidentifier] NULL,
    CONSTRAINT [PK_FinancialYearConfigurations] PRIMARY KEY ([Id]),
)
GO
ALTER TABLE [dbo].[FinancialYearConfigurations]  WITH CHECK ADD  CONSTRAINT [FK_FinancialYearConfigurations_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FinancialYearConfigurations] CHECK CONSTRAINT [FK_FinancialYearConfigurations_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[FinancialYearConfigurations]  WITH CHECK ADD  CONSTRAINT [FK_FinancialYearConfigurations_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FinancialYearConfigurations] CHECK CONSTRAINT [FK_FinancialYearConfigurations_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[FinancialYearConfigurations]  WITH NOCHECK ADD CONSTRAINT [FK_FinancialYearConfigurations_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[FinancialYearConfigurations] CHECK CONSTRAINT [FK_FinancialYearConfigurations_Branch_BranchId]
GO

ALTER TABLE [dbo].[FinancialYearConfigurations]  WITH NOCHECK ADD CONSTRAINT [FK_FinancialYearConfigurations_FinancialYearType_FinancialYearTypeId] FOREIGN KEY(FinancialYearTypeId)
REFERENCES [dbo].FinancialYearType ([Id])
GO

ALTER TABLE [dbo].[FinancialYearConfigurations] CHECK CONSTRAINT [FK_FinancialYearConfigurations_FinancialYearType_FinancialYearTypeId]
GO
GO
ALTER TABLE [dbo].[FinancialYearConfigurations]  WITH NOCHECK ADD CONSTRAINT [FK_FinancialYearConfigurations_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[FinancialYearConfigurations] CHECK CONSTRAINT [FK_FinancialYearConfigurations_Country_CountryId]
GO