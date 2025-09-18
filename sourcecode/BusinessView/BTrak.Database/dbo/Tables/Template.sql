CREATE TABLE [dbo].[Template] (
    [Id]                  UNIQUEIDENTIFIER NOT NULL,
    [TemplateTypeId]      UNIQUEIDENTIFIER NOT NULL,
    [TemplateDescription] NVARCHAR (MAX)   NULL,
    [IsDeleted]           BIT              NOT NULL,
    [CreatedDateTime]     DATETIME         NOT NULL,
    [CreatedByUserId]     UNIQUEIDENTIFIER NULL,
    [UpdatedDateTime]     DATETIME         NULL,
    [UpdatedByUserId]     UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Template] PRIMARY KEY CLUSTERED ([Id] ASC)
);

