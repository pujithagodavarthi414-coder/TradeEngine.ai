CREATE TABLE [dbo].[ProbationSubmission]
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
)
