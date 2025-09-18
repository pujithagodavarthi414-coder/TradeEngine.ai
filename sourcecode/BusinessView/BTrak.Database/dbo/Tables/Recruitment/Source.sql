CREATE TABLE [dbo].[Source]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[Name] NVARCHAR(500) NOT NULL, 
	[IsReferenceNumberNeeded] BIT NOT NULL, 
	[CompanyId] UNIQUEIDENTIFIER NOT NULL, 
	[CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_[Source] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[Source]  WITH CHECK ADD  CONSTRAINT [FK_Source_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Source] CHECK CONSTRAINT [FK_Source_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[Source]  WITH CHECK ADD  CONSTRAINT [FK_Source_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Source] CHECK CONSTRAINT [FK_Source_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[Source]  WITH CHECK ADD  CONSTRAINT [FK_Source_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[Source] CHECK CONSTRAINT [FK_Source_Company_CompanyId]
GO