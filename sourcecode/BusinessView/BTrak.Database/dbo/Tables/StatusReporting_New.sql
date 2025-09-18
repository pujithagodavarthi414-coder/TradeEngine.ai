CREATE TABLE [dbo].[StatusReporting_New](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportingConfigurationOptionId] [uniqueidentifier] NOT NULL,
	[FilePath] [nvarchar](250) NULL,
	[FileName] [nvarchar](250) NULL,
	[FormDataJson] [nvarchar](MAX) NULL,
	[FormJson] [nvarchar](MAX) NULL,
	[Description] [nvarchar](MAX) NULL,
	[SubmittedDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReporting_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[StatusReporting_New]  WITH NOCHECK ADD  CONSTRAINT [FK_StatusReportingConfigurationOption_StatusReporting_New_StatusReportingConfigurationOptionId] FOREIGN KEY([StatusReportingConfigurationOptionId])
REFERENCES [dbo].[StatusReportingConfigurationOption] ([Id])
GO

ALTER TABLE [dbo].[StatusReporting_New] CHECK CONSTRAINT [FK_StatusReportingConfigurationOption_StatusReporting_New_StatusReportingConfigurationOptionId]
GO