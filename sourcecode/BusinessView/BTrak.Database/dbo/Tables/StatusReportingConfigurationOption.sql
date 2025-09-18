CREATE TABLE [dbo].[StatusReportingConfigurationOption](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportingConfigurationId] [uniqueidentifier] NOT NULL,
	[StatusReportingOptionId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReportingConfigurationOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StatusReportingConfigurationOption]  WITH NOCHECK ADD  CONSTRAINT [FK_StatusReportingConfiguration_New_StatusReportingConfigurationOption_StatusReportingConfigurationId] FOREIGN KEY([StatusReportingConfigurationId])
REFERENCES [dbo].[StatusReportingConfiguration_New] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfigurationOption] CHECK CONSTRAINT [FK_StatusReportingConfiguration_New_StatusReportingConfigurationOption_StatusReportingConfigurationId]
GO

ALTER TABLE [dbo].[StatusReportingConfigurationOption]  WITH NOCHECK ADD  CONSTRAINT [FK_StatusReportingOption_New_StatusReportingConfigurationOption_StatusReportingOptionId] FOREIGN KEY([StatusReportingOptionId])
REFERENCES [dbo].[StatusReportingOption_New] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfigurationOption] CHECK CONSTRAINT [FK_StatusReportingOption_New_StatusReportingConfigurationOption_StatusReportingOptionId]
GO
