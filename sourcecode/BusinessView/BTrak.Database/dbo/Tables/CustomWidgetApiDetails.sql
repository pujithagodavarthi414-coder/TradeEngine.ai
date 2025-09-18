CREATE TABLE [dbo].[CustomWidgetApiDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [CustomWidgetId] UNIQUEIDENTIFIER NOT NULL,  
    [HttpMethod] NVARCHAR(50) NULL, 
    [OutputRoot] NVARCHAR(250) NULL, 
    [ApiUrl] NVARCHAR(MAX) NOT NULL, 
    [ApiHeadersJson] NVARCHAR(MAX) NULL,
    [ApiOutputsJson] NVARCHAR(MAX) NULL,
    [BodyJson] NVARCHAR(MAX) NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NULL ,
    CONSTRAINT [PK_CustomWidgetApiDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetApiDetails_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails] CHECK CONSTRAINT [FK_CustomWidgetApiDetails_User]
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetApiDetails_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails] CHECK CONSTRAINT [FK_CustomWidgetApiDetails_User1]
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetApiDetails_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails] CHECK CONSTRAINT [FK_CustomWidgetApiDetails_Company]
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetApiDetails_CustomWidget] FOREIGN KEY([CustomWidgetId])
REFERENCES [dbo].[CustomWidgets] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetApiDetails] CHECK CONSTRAINT [FK_CustomWidgetApiDetails_CustomWidget]
GO
