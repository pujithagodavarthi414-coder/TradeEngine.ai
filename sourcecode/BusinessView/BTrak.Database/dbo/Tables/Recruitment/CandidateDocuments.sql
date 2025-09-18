CREATE TABLE [dbo].[CandidateDocuments]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    CandidateId UNIQUEIDENTIFIER NOT NULL, 
	DocumentTypeId UNIQUEIDENTIFIER NULL, 
	Document NVARCHAR(500),
	[Description] NVARCHAR(MAX),
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
	[IsResume] BIT NULL,
 CONSTRAINT [PK_CandidateDocuments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateDocuments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateDocuments_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateDocuments] CHECK CONSTRAINT [FK_CandidateDocuments_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[CandidateDocuments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateDocuments_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateDocuments] CHECK CONSTRAINT [FK_CandidateDocuments_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateDocuments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateDocuments_Candidate_CandidateId] FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO

ALTER TABLE [dbo].[CandidateDocuments] CHECK CONSTRAINT [FK_CandidateDocuments_Candidate_CandidateId]
GO

ALTER TABLE [dbo].[CandidateDocuments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateDocuments_DocumentType_DocumentTypeId] FOREIGN KEY([DocumentTypeId])
REFERENCES [dbo].[DocumentType] ([Id])
GO

ALTER TABLE [dbo].[CandidateDocuments] CHECK CONSTRAINT [FK_CandidateDocuments_DocumentType_DocumentTypeId]
GO