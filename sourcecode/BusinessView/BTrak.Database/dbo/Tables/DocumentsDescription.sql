CREATE TABLE [dbo].[DocumentsDescription]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[ReferenceId] UNIQUEIDENTIFIER NOT NULL,
	[ReferenceTypeId] UNIQUEIDENTIFIER NULL,
	[Description] NVARCHAR(MAX) NULL,
	[OrderNumber] INT NULL,
	CompanyId [uniqueidentifier]  NULL,
    [InactiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
)
