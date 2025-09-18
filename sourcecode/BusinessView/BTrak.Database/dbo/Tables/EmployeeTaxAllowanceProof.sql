CREATE TABLE [dbo].[EmployeeTaxAllowanceProof](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeTaxAllowanceId] [uniqueidentifier] NOT NULL,
	[ProofDocumentLink]  [nvarchar](max) NOT NULL,
	[SubmittedDate] [datetime]  NULL,
	[Comments] [nvarchar](max)  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_EmployeeTaxAllowanceProof] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeTaxAllowanceProof]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeTaxAllowanceProof_EmployeeTaxAllowances_EmployeeTaxAllowancesId] FOREIGN KEY([EmployeeTaxAllowanceId])
REFERENCES [dbo].[EmployeeTaxAllowances] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTaxAllowanceProof] CHECK CONSTRAINT [FK_EmployeeTaxAllowanceProof_EmployeeTaxAllowances_EmployeeTaxAllowancesId]
GO