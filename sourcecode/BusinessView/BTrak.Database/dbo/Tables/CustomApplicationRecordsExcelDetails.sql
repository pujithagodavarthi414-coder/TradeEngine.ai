CREATE TABLE [dbo].[CustomApplicationRecordsExcelDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER,
    [ExcelSheetName] NVARCHAR(200) NOT NULL, 
    [CustomApplicationId] UNIQUEIDENTIFIER NULL, 
    [IsUploaded] BIT NOT NULL, 
    [FormId] UNIQUEIDENTIFIER NULL, 
    [IsHavingErrors] BIT NOT NULL, 
    [NeedManualCorrection] BIT NOT NULL,
    [ErrorText] NVARCHAR(2000),
    [MailAddress] NVARCHAR(500),
    [ExcelSheetErrorFolder] NVARCHAR(500),
    [ExcelSheetProcessedFolder] NVARCHAR(500),
    [ExcelPath] NVARCHAR(2000),
    [AuthToken] NVARCHAR(2000),
    [CreatedDateTime] DATETIME NULL,
    [CreatedUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    CONSTRAINT PK_CustomApplicationRecordsExcelDetails_Id PRIMARY KEY ([Id]),
    CONSTRAINT UQ_ExcelSheetName UNIQUE (ExcelSheetName),
    CONSTRAINT FK_CustomApplicationRecordsExcelDetails_CompanyId FOREIGN KEY (CompanyId) REFERENCES Company(Id)
)
