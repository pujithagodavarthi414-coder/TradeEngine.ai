
CREATE TABLE [dbo].[Application](
	[Id] [uniqueidentifier] NOT NULL,
	[ApplicationName] [nvarchar](800) NOT NULL,
	[ApplicationTypeId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[OriginalId] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[AsAtInactiveDateTime] [datetime] NULL
CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationType_Application_ApplicationTypeId] FOREIGN KEY([ApplicationTypeId])
REFERENCES [dbo].[ApplicationType] ([Id])
GO

ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK_ApplicationType_Application_ApplicationTypeId]
GO