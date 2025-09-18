CREATE TABLE [dbo].[CustomWidgetUserFilter](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomWidgetId] [uniqueidentifier] NOT NULL,
	[FilterQuery] [nvarchar](max) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_CustomWidgetUserFilter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomWidgetUserFilter]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetUserFilter_CustomWidgets] FOREIGN KEY([CustomWidgetId])
REFERENCES [dbo].[CustomWidgets] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetUserFilter] CHECK CONSTRAINT [FK_CustomWidgetUserFilter_CustomWidgets]
GO

ALTER TABLE [dbo].[CustomWidgetUserFilter]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetUserFilter_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetUserFilter] CHECK CONSTRAINT [FK_CustomWidgetUserFilter_User]
GO
