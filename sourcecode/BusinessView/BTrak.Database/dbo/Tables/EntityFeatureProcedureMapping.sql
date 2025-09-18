CREATE TABLE [dbo].[EntityFeatureProcedureMapping]
(
    Id UNIQUEIDENTIFIER NOT NULL,
    EntityFeatureId UNIQUEIDENTIFIER NOT NULL,
    ProcedureName NVARCHAR(150) NOT NULL,
    CreatedDateTime DATETIME NOT NULL,
    CreatedByUserId UNIQUEIDENTIFIER NOT NULL,
   	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	InActiveDateTime DATETIME NULL,
    [TimeStamp] TimeStamp NOT NULL,
CONSTRAINT [PK_EntityFeatureProcedureMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EntityFeatureProcedureMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_EntityFeature_EntityFeatureProcedureMapping_EntityFeatureId] FOREIGN KEY([EntityFeatureId])
REFERENCES [dbo].[EntityFeature] ([Id])
GO

ALTER TABLE [dbo].[EntityFeatureProcedureMapping] CHECK CONSTRAINT [FK_EntityFeature_EntityFeatureProcedureMapping_EntityFeatureId]
GO