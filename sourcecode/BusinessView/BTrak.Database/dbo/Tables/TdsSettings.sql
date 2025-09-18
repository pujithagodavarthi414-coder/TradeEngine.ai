CREATE TABLE [dbo].[TdsSettings]
(
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[IsTdsRequired] [bit] NOT NULL,
	[ActiveFrom] DATETIME NULL,
	[ActiveTo] DATETIME NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_TdsSettings] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[TdsSettings]  WITH CHECK ADD  CONSTRAINT [FK_TdsSettings_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TdsSettings] CHECK CONSTRAINT [FK_TdsSettings_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[TdsSettings]  WITH CHECK ADD  CONSTRAINT [FK_TdsSettings_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TdsSettings] CHECK CONSTRAINT [FK_TdsSettings_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[TdsSettings]  WITH NOCHECK ADD CONSTRAINT [FK_TdsSettings_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[TdsSettings] CHECK CONSTRAINT [FK_TdsSettings_Branch_BranchId]
GO