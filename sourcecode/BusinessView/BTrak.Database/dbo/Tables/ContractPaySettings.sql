CREATE TABLE [dbo].[ContractPaySettings]
(
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[ContractPayTypeId] [uniqueidentifier] NOT NULL,
	[IsToBePaid] [bit] NOT NULL,
	[ActiveFrom] DATETIME NOT NULL,
	[ActiveTo] DATETIME NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_ContractPaySettings] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[ContractPaySettings]  WITH CHECK ADD  CONSTRAINT [FK_ContractPaySettings_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ContractPaySettings] CHECK CONSTRAINT [FK_ContractPaySettings_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[ContractPaySettings]  WITH CHECK ADD  CONSTRAINT [FK_ContractPaySettings_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ContractPaySettings] CHECK CONSTRAINT [FK_ContractPaySettings_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[ContractPaySettings]  WITH NOCHECK ADD CONSTRAINT [FK_ContractPaySettings_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[ContractPaySettings] CHECK CONSTRAINT [FK_ContractPaySettings_Branch_BranchId]
GO
ALTER TABLE [dbo].[ContractPaySettings]  WITH NOCHECK ADD CONSTRAINT [FK_ContractPaySettings_ContractPayType_ContractPayTypeId] FOREIGN KEY([ContractPayTypeId])
REFERENCES [dbo].[ContractPayType] ([Id])
GO

ALTER TABLE [dbo].[ContractPaySettings] CHECK CONSTRAINT [FK_ContractPaySettings_ContractPayType_ContractPayTypeId]
GO