CREATE TABLE [dbo].[AllowanceTime]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AllowanceRateSheetForId] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[MinTime] FLOAT NULL,
    [MaxTime] FLOAT NULL,
	[ActiveFrom] DATETIME NULL,
	[ActiveTo] DATETIME NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_AllowanceTime] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[AllowanceTime]  WITH CHECK ADD  CONSTRAINT [FK_AllowanceTime_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[AllowanceTime] CHECK CONSTRAINT [FK_AllowanceTime_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[AllowanceTime]  WITH CHECK ADD  CONSTRAINT [FK_AllowanceTime_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[AllowanceTime] CHECK CONSTRAINT [FK_AllowanceTime_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[AllowanceTime]  WITH NOCHECK ADD CONSTRAINT [FK_AllowanceTime_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[AllowanceTime] CHECK CONSTRAINT [FK_AllowanceTime_Branch_BranchId]
GO
ALTER TABLE [dbo].[AllowanceTime]  WITH NOCHECK ADD CONSTRAINT [FK_AllowanceTime_RateSheetFor_AllowanceRateSheetForId] FOREIGN KEY([AllowanceRateSheetForId])
REFERENCES [dbo].[RateSheetFor] ([Id])
GO

ALTER TABLE [dbo].[AllowanceTime] CHECK CONSTRAINT [FK_AllowanceTime_RateSheetFor_AllowanceRateSheetForId]
GO