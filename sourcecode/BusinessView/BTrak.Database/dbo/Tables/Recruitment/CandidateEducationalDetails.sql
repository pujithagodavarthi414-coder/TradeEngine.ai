CREATE TABLE [dbo].[CandidateEducationalDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    CandidateId UNIQUEIDENTIFIER NOT NULL, 
	Institute NVARCHAR(500),
	Department NVARCHAR(500),
	NameOfDegree NVARCHAR(500),
	DateFrom DATETIME,
	DateTo DATETIME,
	IsPursuing BIT,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CandidateEducationalDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateEducationalDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateEducationalDetails_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateEducationalDetails] CHECK CONSTRAINT [FK_CandidateEducationalDetails_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[CandidateEducationalDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateEducationalDetails_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateEducationalDetails] CHECK CONSTRAINT [FK_CandidateEducationalDetails_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateEducationalDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateEducationalDetails_Candidate_CandidateId] FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO

ALTER TABLE [dbo].[CandidateEducationalDetails] CHECK CONSTRAINT [FK_CandidateEducationalDetails_Candidate_CandidateId]
GO
