CREATE TABLE [dbo].[TaxAllowances](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[TaxAllowanceTypeId] [uniqueidentifier] NOT NULL,
	[IsPercentage] [bit] NULL DEFAULT 0,
	[MaxAmount] [decimal](10,4) NULL DEFAULT 0,
	[PercentageValue] [decimal](10,4) NULL DEFAULT 0,
	[ParentId] [uniqueidentifier] NULL,
	[PayRollComponentId] [uniqueidentifier] NULL,
	[ComponentId] [uniqueidentifier] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[OnlyEmployeeMaxAmount] [decimal](10,4) NULL DEFAULT 0,
	[MetroMaxPercentage] [decimal](10,4) NULL DEFAULT 0,
	[LowestAmountOfParentSet] BIT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[BranchId] [uniqueidentifier] NULL,
	[CountryId] [uniqueidentifier] NULL
    CONSTRAINT [PK_TaxAllowances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[TaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_TaxAllowances_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_TaxAllowances_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_TaxAllowances_TaxAllowanceType_TaxAllowanceTypeId] FOREIGN KEY([TaxAllowanceTypeId])
REFERENCES [dbo].[TaxAllowanceType] ([Id])
GO

ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_TaxAllowanceType_TaxAllowanceTypeId]
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_TaxAllowances_PayRollComponent_PayRollComponentId] FOREIGN KEY([PayRollComponentId])
REFERENCES [dbo].[PayRollComponent] ([Id])
GO

ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_PayRollComponent_PayRollComponentId]
GO
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_TaxAllowances_Component_ComponentId] FOREIGN KEY([ComponentId])
REFERENCES [dbo].[Component] ([Id])
GO

ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_Component_ComponentId]
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_TaxAllowances_TaxAllowances_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[TaxAllowances] ([Id])
GO
ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_TaxAllowances_ParentId]
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH NOCHECK ADD CONSTRAINT [FK_TaxAllowances_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO
ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_Branch_BranchId]
GO
ALTER TABLE [dbo].[TaxAllowances]  WITH NOCHECK ADD CONSTRAINT [FK_TaxAllowances_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[TaxAllowances] CHECK CONSTRAINT [FK_TaxAllowances_Country_CountryId]
GO