CREATE TABLE [dbo].[StatusReportingConfigurationUser](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportingConfigurationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_StatusReportingConfigurationUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StatusReportingConfigurationUser]  WITH NOCHECK ADD  CONSTRAINT [FK_StatusReportingConfiguration_New_StatusReportingConfigurationUser_StatusReportingConfigurationId] FOREIGN KEY([StatusReportingConfigurationId])
REFERENCES [dbo].[StatusReportingConfiguration_New] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfigurationUser] CHECK CONSTRAINT [FK_StatusReportingConfiguration_New_StatusReportingConfigurationUser_StatusReportingConfigurationId]
GO

ALTER TABLE [dbo].[StatusReportingConfigurationUser]  WITH NOCHECK ADD  CONSTRAINT [FK_User_StatusReportingConfigurationUser_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfigurationUser] CHECK CONSTRAINT [FK_User_StatusReportingConfigurationUser_UserId]
GO