CREATE TABLE [dbo].[StatusReportingConfigurationDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportingConfigurationId] [uniqueidentifier] NOT NULL,
	[StatusReportingOptionId] [uniqueidentifier] NOT NULL,
	[StatusReportingStatusId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReportingConfigurationDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[StatusReportingConfigurationDetails]  WITH CHECK ADD  CONSTRAINT [FK_StatusReportingConfiguration_StatusReportingConfigurationDetails_StatusReportingConfigurationId] FOREIGN KEY([StatusReportingConfigurationId])
REFERENCES [dbo].[StatusReportingConfiguration] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfigurationDetails] CHECK CONSTRAINT [FK_StatusReportingConfiguration_StatusReportingConfigurationDetails_StatusReportingConfigurationId]
GO