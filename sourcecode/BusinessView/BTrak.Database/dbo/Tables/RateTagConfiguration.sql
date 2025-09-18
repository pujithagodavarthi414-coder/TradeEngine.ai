CREATE TABLE [dbo].[RateTagConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[RateTagId] UNIQUEIDENTIFIER NULL, 
	[RateTagConfigurationName] NVARCHAR(250) NULL,
    [RateTagCurrencyId] UNIQUEIDENTIFIER NULL,
	[Priority] INT NULL,
    [RatePerHour] decimal(18,2),
    [RatePerHourMon] decimal(18,2),
    [RatePerHourTue] decimal(18,2),
    [RatePerHourWed] decimal(18,2),
    [RatePerHourThu] decimal(18,2),
    [RatePerHourFri] decimal(18,2),
    [RatePerHourSat] decimal(18,2),
    [RatePerHourSun] decimal(18,2),
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	RateTagRoleBranchConfigurationId UNIQUEIDENTIFIER NULL
CONSTRAINT [PK_RateTagConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[RateTagConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagConfiguration] CHECK CONSTRAINT [FK_RateTagConfiguration_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[RateTagConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagConfiguration] CHECK CONSTRAINT [FK_RateTagConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[RateTagConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagConfiguaration_RateTagRoleBranchConfiguration_RateTagRoleBranchConfigurationId] FOREIGN KEY([RateTagRoleBranchConfigurationId])
REFERENCES [dbo].[RateTagRoleBranchConfiguration] ([Id])
GO

ALTER TABLE [dbo].[RateTagConfiguration] CHECK CONSTRAINT [FK_RateTagConfiguaration_RateTagRoleBranchConfiguration_RateTagRoleBranchConfigurationId]
GO

ALTER TABLE [dbo].[RateTagConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagConfiguration_RateTag_RateTagCurrencyId] FOREIGN KEY([RateTagCurrencyId])
REFERENCES [dbo].[SYS_Currency] ([Id])
GO

ALTER TABLE [dbo].[RateTagConfiguration] CHECK CONSTRAINT [FK_RateTagConfiguration_RateTag_RateTagCurrencyId]
GO