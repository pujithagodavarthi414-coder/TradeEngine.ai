CREATE TABLE [dbo].[Feature](
	[Id] [uniqueidentifier] NOT NULL,
	[FeatureName] [nvarchar](800) NOT NULL,
	[Description] [nvarchar](800) NULL,
	[ParentFeatureId] [uniqueidentifier] NULL,
	[IsActive] [bit] NOT NULL,
	[MenuItemId] [uniqueidentifier] NULL,
	SiteEnum INT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Feature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]

GO