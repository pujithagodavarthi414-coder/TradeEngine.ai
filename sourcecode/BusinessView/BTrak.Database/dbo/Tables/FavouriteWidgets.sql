CREATE TABLE [dbo].[FavouriteWidgets](
	[Id] [uniqueidentifier] NOT NULL,
	[WidgetId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[IsFavourite] [bit] NULL
) ON [PRIMARY]
GO