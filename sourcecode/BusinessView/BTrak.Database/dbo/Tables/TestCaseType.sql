CREATE TABLE [dbo].[TestCaseType] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [TypeName]        NVARCHAR (250)    NULL,
    [CreatedDateTime] DATETIMEOFFSET         NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    CompanyId [uniqueidentifier]  NULL,
    [IsDefault] BIT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[InActiveDateTimeZoneId] [uniqueidentifier]  NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestCaseType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestCaseType_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([Id]), 
);
GO