CREATE TABLE [dbo].[StatusReporting](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportingConfigurationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[IsSubmitted] [bit] NULL,
	[IsReviewed] [bit] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReporting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[StatusReporting]  WITH CHECK ADD  CONSTRAINT [FK_StatusReporting_StatusReportingConfigurationDetails_StatusReportingConfigurationId] FOREIGN KEY([StatusReportingConfigurationId])
REFERENCES [dbo].[StatusReportingConfiguration] ([Id])
GO

ALTER TABLE [dbo].[StatusReporting] CHECK CONSTRAINT [FK_StatusReporting_StatusReportingConfigurationDetails_StatusReportingConfigurationId]
GO