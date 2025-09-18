CREATE TABLE [dbo].[ObservationType](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[ObservationName] [nvarchar](500) NOT NULL,
	[CreatedDateTime] [datetimeoffset](7) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset](7) NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetimeoffset](7) NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_ObservationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObservationType]  WITH CHECK ADD  CONSTRAINT [FK_ObservationType_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[ObservationType] CHECK CONSTRAINT [FK_ObservationType_Company]
GO

ALTER TABLE [dbo].[ObservationType]  WITH CHECK ADD  CONSTRAINT [FK_ObservationType_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ObservationType] CHECK CONSTRAINT [FK_ObservationType_User]
GO

ALTER TABLE [dbo].[ObservationType]  WITH CHECK ADD  CONSTRAINT [FK_ObservationType_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ObservationType] CHECK CONSTRAINT [FK_ObservationType_User1]
GO