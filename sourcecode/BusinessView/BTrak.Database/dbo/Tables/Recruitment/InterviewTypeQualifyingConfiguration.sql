CREATE TABLE [dbo].[InterviewTypeQualifyingConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    InterviewRatingId UNIQUEIDENTIFIER NOT NULL,
	InterviewTypeId UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_InterviewTypeQualifyingConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration] CHECK CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration] CHECK CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_InterviewRating_InterviewRatingId] FOREIGN KEY([InterviewRatingId])
REFERENCES [dbo].[InterviewRating] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration] CHECK CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_InterviewRating_InterviewRatingId]
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_InterviewType_InterviewTypeId] FOREIGN KEY([InterviewTypeId])
REFERENCES [dbo].[InterviewType] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeQualifyingConfiguration] CHECK CONSTRAINT [FK_InterviewTypeQualifyingConfiguration_InterviewType_InterviewTypeId]
GO