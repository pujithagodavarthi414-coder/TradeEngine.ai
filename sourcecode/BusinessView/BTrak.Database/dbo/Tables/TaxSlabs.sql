CREATE TABLE [dbo].[TaxSlabs]
(	
    [Id] [uniqueidentifier]  NOT NULL PRIMARY KEY,
	[Name] [nvarchar](150) NULL,
	[FromRange] [decimal](18, 4) NULL,
	[ToRange] [decimal](18, 4) NULL,
	[TaxPercentage] [decimal](10, 4) NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[MinAge] [int] NULL,
	[MaxAge] [int] NULL,
	[ForMale] [bit] NULL,
	[ForFemale] [bit] NULL,
	[Handicapped] [bit] NULL,
	[PayrollTemplateId] [uniqueidentifier] NULL,
	[TaxCalculationTypeId] [uniqueidentifier] NULL,
	[Order] [int] NULL,
	[IsArchived] [bit] NULL,
	[IsFlatRate] [bit] NULL,
	[ParentId] [uniqueidentifier] NULL,
	[BranchId] [uniqueidentifier] NULL,
	[CountryId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
)
GO

ALTER TABLE [dbo].[TaxSlabs]  WITH CHECK ADD  CONSTRAINT [FK_TaxSlabs_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TaxSlabs] CHECK CONSTRAINT [FK_TaxSlabs_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[TaxSlabs]  WITH CHECK ADD  CONSTRAINT [FK_TaxSlabs_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TaxSlabs] CHECK CONSTRAINT [FK_TaxSlabs_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[TaxSlabs]  WITH CHECK ADD  CONSTRAINT [FK_TaxSlabs_TaxSlabs_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[TaxSlabs] ([Id])
GO

ALTER TABLE [dbo].[TaxSlabs] CHECK CONSTRAINT [FK_TaxSlabs_TaxSlabs_ParentId]
GO
ALTER TABLE [dbo].[TaxSlabs]  WITH NOCHECK ADD CONSTRAINT [FK_TaxSlabs_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO
ALTER TABLE [dbo].[TaxSlabs] CHECK CONSTRAINT [FK_TaxSlabs_Branch_BranchId]
GO
ALTER TABLE [dbo].[TaxSlabs]  WITH NOCHECK ADD CONSTRAINT [FK_TaxSlabs_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[TaxSlabs] CHECK CONSTRAINT [FK_TaxSlabs_Country_CountryId]
GO