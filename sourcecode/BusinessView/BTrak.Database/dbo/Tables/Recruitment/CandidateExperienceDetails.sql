CREATE TABLE [dbo].[CandidateExperienceDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    CandidateId UNIQUEIDENTIFIER NOT NULL, 
	OccupationTitle NVARCHAR(500),
	Company NVARCHAR(500),
	CompanyType NVARCHAR(500),
	[Description] NVARCHAR(MAX),
	DateFrom DATETIME,
	DateTo DATETIME,
	[Location] NVARCHAR(500),
	IsCurrentlyWorkingHere BIT,
	Salary FLOAT,
	CurrencyId UNIQUEIDENTIFIER,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CandidateExperienceDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateExperienceDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateExperienceDetails_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateExperienceDetails] CHECK CONSTRAINT [FK_CandidateExperienceDetails_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[CandidateExperienceDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateExperienceDetails_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateExperienceDetails] CHECK CONSTRAINT [FK_CandidateExperienceDetails_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateExperienceDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateExperienceDetails_Candidate_CandidateId] FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO

ALTER TABLE [dbo].[CandidateExperienceDetails] CHECK CONSTRAINT [FK_CandidateExperienceDetails_Candidate_CandidateId]
GO

ALTER TABLE [dbo].[CandidateExperienceDetails]  WITH CHECK ADD  CONSTRAINT [FK_CandidateExperienceDetails_SYS_Currency_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[SYS_Currency] ([Id])
GO

ALTER TABLE [dbo].[CandidateExperienceDetails] CHECK CONSTRAINT [FK_CandidateExperienceDetails_SYS_Currency_CurrencyId]
GO