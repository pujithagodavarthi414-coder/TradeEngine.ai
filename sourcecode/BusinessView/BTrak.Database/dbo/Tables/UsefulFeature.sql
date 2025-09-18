CREATE TABLE [dbo].[UsefulFeature]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	FeatureName NVARCHAR(500),
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
)
