CREATE TABLE ConductQuestionDocuments
(
[Id] [uniqueidentifier] NOT NULL,
DocumentName NVARCHAR(MAX) NOT NULL,
DocumentOrder INT NULL,
IsDocumentMandatory BIT NULL,
ConductQuestionId UNIQUEIDENTIFIER NOT NULL,
CreatedByUserId  UNIQUEIDENTIFIER NOT NULL,
CreatedDateTime DATETIME NOT NULL,
UpdatedByUserId  UNIQUEIDENTIFIER NULL,
UpdatedDateTime DATETIME NULL,
InActiveDateTime DATETIME NULL
)