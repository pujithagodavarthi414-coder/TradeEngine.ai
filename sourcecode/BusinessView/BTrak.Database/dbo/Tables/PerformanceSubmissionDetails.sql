CREATE TABLE [dbo].[PerformanceSubmissionDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [PerformanceSubmissionId] UNIQUEIDENTIFIER NOT NULL, 
    [SubmissionFrom] INT NOT NULL, 
    [FormData] NVARCHAR(MAX) NULL, 
	[IsCompleted] BIT NULL,
    [SubmittedBy] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL,
	CONSTRAINT [PK_PerformanceSubmissionDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmissionDetails_SubmissionFromId] FOREIGN KEY(PerformanceSubmissionId)
REFERENCES [dbo].PerformanceSubmission ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails] CHECK CONSTRAINT [FK_PerformanceSubmissionDetails_SubmissionFromId]
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmissionDetails_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails] CHECK CONSTRAINT [FK_PerformanceSubmissionDetails_User]
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmissionDetails_SubmittedBy] FOREIGN KEY(SubmittedBy)
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails] CHECK CONSTRAINT [FK_PerformanceSubmissionDetails_SubmittedBy]
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmissionDetails_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmissionDetails] CHECK CONSTRAINT [FK_PerformanceSubmissionDetails_User1]
GO

