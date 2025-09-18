CREATE TABLE [dbo].[StatusReportSeenHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportId] [uniqueidentifier] NULL,
	[Seen] [bit] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_StatusReportSeenHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StatusReportSeenHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_StatusReportSeenHistory_StatusReporting_New] FOREIGN KEY([StatusReportId])
REFERENCES [dbo].[StatusReporting_New] ([Id])
GO

ALTER TABLE [dbo].[StatusReportSeenHistory] CHECK CONSTRAINT [FK_StatusReportSeenHistory_StatusReporting_New]
GO

ALTER TABLE [dbo].[StatusReportSeenHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusReportSeenHistory_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[StatusReportSeenHistory] CHECK CONSTRAINT [FK_StatusReportSeenHistory_User]
GO
