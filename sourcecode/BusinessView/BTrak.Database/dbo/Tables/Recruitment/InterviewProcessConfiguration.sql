CREATE TABLE [dbo].[InterviewProcessConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	InterviewProcessTypeConfigurationId UNIQUEIDENTIFIER,
	JobOpeningId UNIQUEIDENTIFIER,
	CandidateId UNIQUEIDENTIFIER,
	IsVideoCalling BIT,
	IsPhoneCalling BIT,
	[Order] INT,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_InterviewProcessConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[InterviewProcessConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewProcessConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewProcessConfiguration] CHECK CONSTRAINT [FK_InterviewProcessConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[InterviewProcessConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewProcessConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewProcessConfiguration] CHECK CONSTRAINT [FK_InterviewProcessConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[InterviewProcessConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewProcessConfiguration_InterviewProcessTypeConfiguration_InterviewProcessTypeConfigurationId] FOREIGN KEY(InterviewProcessTypeConfigurationId)
REFERENCES [dbo].[InterviewProcessTypeConfiguration] ([Id])
GO

ALTER TABLE [dbo].[InterviewProcessConfiguration] CHECK CONSTRAINT [FK_InterviewProcessConfiguration_InterviewProcessTypeConfiguration_InterviewProcessTypeConfigurationId]
GO