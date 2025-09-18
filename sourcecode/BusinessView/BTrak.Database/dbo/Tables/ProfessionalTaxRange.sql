CREATE TABLE [dbo].[ProfessionalTaxRange]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [FromRange] Decimal(18,4), 
    [ToRange] Decimal(18,4), 
    [TaxAmount] Decimal(18,4),
	[IsArchived] bit,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[BranchId] UNIQUEIDENTIFIER NULL
)
GO
ALTER TABLE [dbo].[ProfessionalTaxRange] WITH CHECK ADD CONSTRAINT [FK_Branch_ProfessionalTaxRange_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[ProfessionalTaxRange] CHECK CONSTRAINT [FK_Branch_ProfessionalTaxRange_BranchId]
GO