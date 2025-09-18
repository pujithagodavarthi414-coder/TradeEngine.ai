CREATE TABLE [dbo].[UserReference]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	[ReferenceId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TimeStamp NOT NULL
  CONSTRAINT [PK_UserReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserReference]  WITH NOCHECK ADD  CONSTRAINT [FK_User_UserReference_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FormAccessibility] CHECK CONSTRAINT [FK_User_UserReference_UserId]
GO
