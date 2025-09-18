CREATE TABLE [dbo].[PerformanceSubmission]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ConfigurationId] UNIQUEIDENTIFIER NOT NULL, 
    [OfUserId] UNIQUEIDENTIFIER NOT NULL, 
    [IsOpen] BIT NOT NULL,
	[IsShare] BIT NOT NULL,
    [PdfUrl] NVARCHAR(250) NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [ClosedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InActiveDateTime] DATETIME NULL,
	CONSTRAINT [PK_PerformanceSubmission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PerformanceSubmission]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmission_ConfigurationId] FOREIGN KEY(ConfigurationId)
REFERENCES [dbo].PerformanceConfiguration ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmission] CHECK CONSTRAINT [FK_PerformanceSubmission_ConfigurationId]
GO

ALTER TABLE [dbo].[PerformanceSubmission]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmission_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmission] CHECK CONSTRAINT [FK_PerformanceSubmission_User]
GO

ALTER TABLE [dbo].[PerformanceSubmission]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmission_OfUserId] FOREIGN KEY(OfUserId)
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmission] CHECK CONSTRAINT [FK_PerformanceSubmission_OfUserId]
GO

ALTER TABLE [dbo].[PerformanceSubmission]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceSubmission_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceSubmission] CHECK CONSTRAINT [FK_PerformanceSubmission_User1]
GO


