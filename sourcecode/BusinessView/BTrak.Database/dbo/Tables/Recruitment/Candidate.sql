CREATE TABLE [dbo].[Candidate]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	CandidateUniqueName NVARCHAR(250) NULL,
    FirstName NVARCHAR(500),
	LastName NVARCHAR(500),
	FatherName NVARCHAR(500),
	[ProfileImage] [nvarchar](800) NULL,
	Email NVARCHAR(500),
	SecondaryEmail NVARCHAR(500),
	Mobile NVARCHAR(100),
	Phone NVARCHAR(100),
	Fax NVARCHAR(250),
	Website NVARCHAR(500),
	SkypeId NVARCHAR(500),
	TwitterId NVARCHAR(500),
	AddressJson NVARCHAR(MAX),
	CountryId UNIQUEIDENTIFIER,
	ExperienceInYears FLOAT,
	CurrentDesignation UNIQUEIDENTIFIER,
	CurrentSalary FLOAT,
	ExpectedSalary FLOAT,
	SourceId UNIQUEIDENTIFIER,
	SourcePersonId UNIQUEIDENTIFIER,
	HiringStatusId UNIQUEIDENTIFIER,
	AssignedToManagerId UNIQUEIDENTIFIER,
	ClosedById UNIQUEIDENTIFIER,
	CompanyId UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Candidate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_Country_CountryId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_Source_SourceId] FOREIGN KEY([SourceId])
REFERENCES [dbo].[Source] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_Source_SourceId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_User_SourcePersonId] FOREIGN KEY([SourcePersonId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_User_SourcePersonId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_HiringStatus_HiringStatusId] FOREIGN KEY([HiringStatusId])
REFERENCES [dbo].[HiringStatus] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_HiringStatus_HiringStatusId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_User_AssignedToManagerId] FOREIGN KEY([AssignedToManagerId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_User_AssignedToManagerId]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_User_ClosedById] FOREIGN KEY([ClosedById])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_User_ClosedById]
GO

ALTER TABLE [dbo].[Candidate]  WITH CHECK ADD  CONSTRAINT [FK_Candidate_Designation_CurrentDesignation] FOREIGN KEY([CurrentDesignation])
REFERENCES [dbo].[Designation] ([Id])
GO

ALTER TABLE [dbo].[Candidate] CHECK CONSTRAINT [FK_Candidate_Designation_CurrentDesignation]
GO