CREATE TABLE [dbo].[SCOGenerations]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    [LeadSubmissionId] UNIQUEIDENTIFIER NOT NULL, 
    [UniqueScoId] NVARCHAR(250) NOT NULL,
    [CreditsAllocated] INT NOT NULL,
    [ClientId] UNIQUEIDENTIFIER NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [Comments] NVARCHAR(MAX) NULL, 
    [IsScoAccepted] BIT NULL,
    [TimeStamp] TIMESTAMP NULL, 
    [PerformaPdf] NVARCHAR(MAX) NULL, 
    [ScoPdf] NVARCHAR(MAX) NULL
)
