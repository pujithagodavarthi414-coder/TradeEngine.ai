CREATE TABLE [dbo].[MenuCategory](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[TimeStamp] TIMESTAMP,
    [InactiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_MenuCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
), 
    CONSTRAINT [AK_MenuCategory_MenuCategoryName] UNIQUE ([Name]))
GO

ALTER TABLE [dbo].[MenuCategory]  WITH CHECK ADD  CONSTRAINT [FK_User_MenuCategory_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[MenuCategory] CHECK CONSTRAINT [FK_User_MenuCategory_CreatedByUserId]
GO