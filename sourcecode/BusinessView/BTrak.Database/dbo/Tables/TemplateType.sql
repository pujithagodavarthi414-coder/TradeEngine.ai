CREATE TABLE [dbo].[TemplateType] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [TemplateTypeName] NVARCHAR (100)   NULL,
    [CreatedDateTime]  DATETIME         NOT NULL,
    [CreatedByUserId]  UNIQUEIDENTIFIER NULL,
    [UpdatedDateTime]  DATETIME         NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
	[AsAtInactiveDateTime] [datetime] NULL,
    CONSTRAINT [PK_TemplateType] PRIMARY KEY CLUSTERED ([Id] ASC), 
    CONSTRAINT [AK_TemplateType_TemplateTypeName] UNIQUE ([TemplateTypeName])
);

