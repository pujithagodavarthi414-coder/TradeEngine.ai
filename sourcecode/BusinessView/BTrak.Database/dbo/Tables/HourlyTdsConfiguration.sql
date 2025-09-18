CREATE TABLE [dbo].[HourlyTdsConfiguration]
(
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[MaxLimit] [decimal](18, 4) NOT NULL,
    [TaxPercentage] [decimal](18, 4) NOT NULL,
	[ActiveFrom] DATETIME NOT NULL,
	[ActiveTo] DATETIME NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_HourlyTdsConfiguration] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[HourlyTdsConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_HourlyTdsConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[HourlyTdsConfiguration] CHECK CONSTRAINT [FK_HourlyTdsConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[HourlyTdsConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_HourlyTdsConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[HourlyTdsConfiguration] CHECK CONSTRAINT [FK_HourlyTdsConfiguration_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[HourlyTdsConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_HourlyTdsConfiguration_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[HourlyTdsConfiguration] CHECK CONSTRAINT [FK_HourlyTdsConfiguration_Branch_BranchId]
GO