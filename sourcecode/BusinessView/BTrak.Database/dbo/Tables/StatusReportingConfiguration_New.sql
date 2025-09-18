CREATE TABLE [dbo].[StatusReportingConfiguration_New](
	[Id] [uniqueidentifier] NOT NULL,
	[ConfigurationName] [nvarchar](250) NOT NULL,
	[GenericFormId] [uniqueidentifier] NOT NULL,
	[AssignedByUserId] [uniqueidentifier] NOT NULL,
	[AssignedDateTime] [datetime] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReportingConfiguration_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[StatusReportingConfiguration_New]  WITH NOCHECK ADD  CONSTRAINT [FK_GenericForm_StatusReportingConfiguration_New_GenericFormId] FOREIGN KEY([GenericFormId])
REFERENCES [dbo].[GenericForm] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfiguration_New]  CHECK CONSTRAINT [FK_GenericForm_StatusReportingConfiguration_New_GenericFormId]
GO

ALTER TABLE [dbo].[StatusReportingConfiguration_New]  WITH NOCHECK ADD  CONSTRAINT [FK_User_StatusReportingConfiguration_New_AssignedByUserId] FOREIGN KEY([AssignedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingConfiguration_New] CHECK CONSTRAINT [FK_User_StatusReportingConfiguration_New_AssignedByUserId]
GO