CREATE TABLE [dbo].[CustomWidgetHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomWidgetId] [uniqueidentifier] NOT NULL,
	[FieldName] [nvarchar](250) NOT NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_CustomWidgetHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomWidgetHistory]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetHistory_CustomWidgets] FOREIGN KEY([CustomWidgetId])
REFERENCES [dbo].[CustomWidgets] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetHistory] CHECK CONSTRAINT [FK_CustomWidgetHistory_CustomWidgets]
GO

ALTER TABLE [dbo].[CustomWidgetHistory]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetHistory_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetHistory] CHECK CONSTRAINT [FK_CustomWidgetHistory_User]
GO