CREATE TABLE [dbo].[FieldPermission] (
    [Id]                  UNIQUEIDENTIFIER NOT NULL,
    [PermissionId]        UNIQUEIDENTIFIER NOT NULL,
    [ConfigurationTypeId] UNIQUEIDENTIFIER NOT NULL,
    [ConfigurationId]     UNIQUEIDENTIFIER NULL,
    [FieldId]             UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime]     DATETIME         NOT NULL,
    [CreatedByUserId]     UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime]     DATETIME         NULL,
    [UpdatedByUserId]     UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_FieldPermission] PRIMARY KEY CLUSTERED ([Id] ASC),
    --CONSTRAINT [FK_FieldPermission_ConfigurationType_ConfigurationTypeId] FOREIGN KEY ([ConfigurationTypeId]) REFERENCES [dbo].[ConfigurationType] ([Id]),
    --CONSTRAINT [FK_FieldPermission_CrudOperation_PermissionId] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[CrudOperation] ([Id]),
    CONSTRAINT [FK_FieldPermission_Field_FieldId] FOREIGN KEY ([FieldId]) REFERENCES [dbo].[Field] ([Id]), 
    CONSTRAINT [AK_FieldPermission_PermissionId_ConfigurationTypeId_FieldId] UNIQUE ([PermissionId],[ConfigurationTypeId],[FieldId])
)
GO