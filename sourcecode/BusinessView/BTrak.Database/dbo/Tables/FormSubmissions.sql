CREATE TABLE [dbo].[FormSubmissions]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [GenericFormId] UNIQUEIDENTIFIER NOT NULL, 
    [FormData] NVARCHAR(MAX) NOT NULL, 
    [Status] NVARCHAR(50) NOT NULL, 
    [AssignedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [AssignedToUserId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL
	CONSTRAINT [PK_FormSubmissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    [InActiveDateTime] NCHAR(10) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FormSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_FormSubmissions_User1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FormSubmissions] CHECK CONSTRAINT [FK_FormSubmissions_User1]
GO

ALTER TABLE [dbo].[FormSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_FormSubmissions_User2] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FormSubmissions] CHECK CONSTRAINT [FK_FormSubmissions_User2]
GO

ALTER TABLE [dbo].[FormSubmissions]  WITH CHECK ADD  CONSTRAINT [FK_FormSubmissions_GenericForm] FOREIGN KEY([GenericFormId])
REFERENCES [dbo].[GenericForm] ([Id])
GO

ALTER TABLE [dbo].[FormSubmissions] CHECK CONSTRAINT [FK_FormSubmissions_GenericForm]
GO