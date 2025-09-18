CREATE TABLE [dbo].[DaysOfWeekConfiguration]
(
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[IsWeekend] [bit] NOT NULL,
	[DaysOfWeekId] [uniqueidentifier] NOT NULL,
	[PartsOfDayId] [uniqueidentifier] NOT NULL,
	[FromTime] [time] NULL,
    [ToTime] [time] NULL,
	[ActiveFrom] DATETIME NOT NULL,
	[ActiveTo] DATETIME NULL,
	[IsBankHoliday] BIT NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_DaysOfWeekConfiguration] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[DaysOfWeekConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_DaysOfWeekConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[DaysOfWeekConfiguration] CHECK CONSTRAINT [FK_DaysOfWeekConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[DaysOfWeekConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_DaysOfWeekConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[DaysOfWeekConfiguration] CHECK CONSTRAINT [FK_DaysOfWeekConfiguration_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[DaysOfWeekConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_DaysOfWeekConfiguration_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[DaysOfWeekConfiguration] CHECK CONSTRAINT [FK_DaysOfWeekConfiguration_Branch_BranchId]
GO
ALTER TABLE [dbo].[DaysOfWeekConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_DaysOfWeekConfiguration_RateSheetFor_PartsOfDayId] FOREIGN KEY([PartsOfDayId])
REFERENCES [dbo].[PartsOfDay] ([Id])
GO

ALTER TABLE [dbo].[DaysOfWeekConfiguration] CHECK CONSTRAINT [FK_DaysOfWeekConfiguration_RateSheetFor_PartsOfDayId]
GO
ALTER TABLE [dbo].[DaysOfWeekConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_DaysOfWeekConfiguration_WeekDays_DaysOfWeekId] FOREIGN KEY([DaysOfWeekId])
REFERENCES [dbo].[WeekDays] ([Id])
GO

ALTER TABLE [dbo].[DaysOfWeekConfiguration] CHECK CONSTRAINT [FK_DaysOfWeekConfiguration_WeekDays_DaysOfWeekId]
GO