CREATE TABLE [dbo].[ContractPurchase]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(250) NOT NULL, 
	[SelectedRoles] NVARCHAR(MAX) NULL,
	[IsDraft] BIT NOT NULL,
    [FormJson] NVARCHAR(MAX) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDatetime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDatetime] DATETIME NULL,
	[InActiveDatetime] DATETIME NULL, 
	[TimeStamp] TimeStamp NOT NULL,
CONSTRAINT [PK_ContractPurchase] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ContractPurchase]  WITH CHECK ADD  CONSTRAINT [FK_ContractPurchase_User1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ContractPurchase] CHECK CONSTRAINT [FK_ContractPurchase_User1]
GO

ALTER TABLE [dbo].[ContractPurchase]  WITH CHECK ADD  CONSTRAINT [FK_ContractPurchase_User2] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ContractPurchase] CHECK CONSTRAINT [FK_ContractPurchase_User2]
GO
