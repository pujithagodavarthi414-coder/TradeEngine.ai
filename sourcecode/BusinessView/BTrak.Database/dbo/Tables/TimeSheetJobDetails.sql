CREATE TABLE [dbo].[TimeSheetJobDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [JobId] NVARCHAR(200) NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [InActiveDateTime] DATETIME NULL,
    [CompanyId] [uniqueidentifier] NOT NULL, 
    [ExecutionDate] DATETIME NULL, 
    [IsForProbation] BIT NULL
)
