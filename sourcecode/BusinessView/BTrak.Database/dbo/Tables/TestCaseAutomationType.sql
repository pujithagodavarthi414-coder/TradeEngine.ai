CREATE TABLE [dbo].[TestCaseAutomationType] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [AutomationType]  NVARCHAR (250)    NULL,
    [CreatedDateTime] DATETIMEOFFSET      NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    CompanyId [uniqueidentifier]  NULL,
    [IsDefault] BIT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[InActiveDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestCaseAutomationType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestCaseAutomationType_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([Id]), 
);
GO