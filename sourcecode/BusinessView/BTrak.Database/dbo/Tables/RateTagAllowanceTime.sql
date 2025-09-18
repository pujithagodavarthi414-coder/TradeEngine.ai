CREATE TABLE [dbo].[RateTagAllowanceTime]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AllowanceRateTagForId] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[MinTime] FLOAT NULL,
    [MaxTime] FLOAT NULL,
	IsBankHoliday BIT NULL,
	[ActiveFrom] DATETIME NULL,
	[ActiveTo] DATETIME NULL,
	[RateTagForType] NVARCHAR(50) NULL,
	[RateTagForName] NVARCHAR(250) NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_RateTagAllowanceTime] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[RateTagAllowanceTime]  WITH CHECK ADD  CONSTRAINT [FK_RateTagAllowanceTime_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagAllowanceTime] CHECK CONSTRAINT [FK_RateTagAllowanceTime_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[RateTagAllowanceTime]  WITH CHECK ADD  CONSTRAINT [FK_RateTagAllowanceTime_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagAllowanceTime] CHECK CONSTRAINT [FK_RateTagAllowanceTime_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[RateTagAllowanceTime]  WITH NOCHECK ADD CONSTRAINT [FK_RateTagAllowanceTime_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[RateTagAllowanceTime] CHECK CONSTRAINT [FK_RateTagAllowanceTime_Branch_BranchId]
GO