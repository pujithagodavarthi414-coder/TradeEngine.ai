CREATE TABLE [dbo].[TestRailConfiguration] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [ConfigurationName]        NVARCHAR (250) NOT   NULL,
	[ConfigurationShortName] NVARCHAR (250) NULL,
    [ConfigurationTime]        FLOAT  NOT NULL,
    [CreatedDateTime] DATETIMEOFFSET         NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [CompanyId] [uniqueidentifier]  NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestRailConfiguration] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestRailConfiguration_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([Id]), 
)
GO