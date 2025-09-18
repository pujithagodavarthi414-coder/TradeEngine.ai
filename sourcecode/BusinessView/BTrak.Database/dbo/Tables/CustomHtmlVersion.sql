CREATE TABLE [dbo].[CustomHtmlVersion](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomHtmlAppId] [uniqueidentifier] NOT NULL,
	[Version] [nvarchar](50) NOT NULL,
	[HtmlCode] [nvarchar](max) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomHtmlVersion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomHtmlVersion]  WITH CHECK ADD  CONSTRAINT [FK_CustomHtmlVersion_CustomHtmlApp] FOREIGN KEY([CustomHtmlAppId])
REFERENCES [dbo].[CustomHtmlApp] ([Id])
GO

ALTER TABLE [dbo].[CustomHtmlVersion] CHECK CONSTRAINT [FK_CustomHtmlVersion_CustomHtmlApp]
GO

ALTER TABLE [dbo].[CustomHtmlVersion]  WITH CHECK ADD  CONSTRAINT [FK_CustomHtmlVersion_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomHtmlVersion] CHECK CONSTRAINT [FK_CustomHtmlVersion_User]
GO