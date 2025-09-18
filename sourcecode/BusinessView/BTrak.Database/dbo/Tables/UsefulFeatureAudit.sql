CREATE TABLE [dbo].[UsefulFeatureAudit]
(
	[Id] [uniqueidentifier] NOT NULL,
	UsefulFeatureId [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	CONSTRAINT [PK_UsefulFeatureAudit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_UsefulFeatureAudit_UsefulFeatureId] FOREIGN KEY (UsefulFeatureId) REFERENCES [UsefulFeature]([Id])
)
GO

