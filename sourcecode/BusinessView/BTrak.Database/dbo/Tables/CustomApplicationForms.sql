CREATE TABLE [dbo].[CustomApplicationForms]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [CustomApplicationId] UNIQUEIDENTIFIER NOT NULL, 
    [GenericFormId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[PublicUrl] NVARCHAR(250) NULL,
	[TimeStamp] [timestamp] NOT NULL, 
    CONSTRAINT [PK_CustomApplicationForms] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_CustomApplicationForms_CustomApplication] FOREIGN KEY ([CustomApplicationId]) REFERENCES [CustomApplication]([Id])
)
