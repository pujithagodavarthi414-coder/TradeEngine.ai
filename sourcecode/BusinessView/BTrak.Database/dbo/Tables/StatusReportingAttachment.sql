CREATE TABLE [dbo].[StatusReportingAttachment](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusReportingId] [uniqueidentifier] NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[IsSubmitted] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReportingAttachment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[StatusReportingAttachment]  WITH CHECK ADD  CONSTRAINT [FK_StatusReporting_StatusReportingAttachment_StatusReportingId] FOREIGN KEY([StatusReportingId])
REFERENCES [dbo].[StatusReporting] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingAttachment] CHECK CONSTRAINT [FK_StatusReporting_StatusReportingAttachment_StatusReportingId]
GO