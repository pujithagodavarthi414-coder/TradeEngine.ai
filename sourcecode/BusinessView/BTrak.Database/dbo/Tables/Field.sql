CREATE TABLE [dbo].[Field] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    CompanyId [uniqueidentifier]  NULL,
    [FieldName]       NVARCHAR (500)   NOT NULL,
    [FieldAliasName]  NVARCHAR (500)   NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InactiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Field] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO