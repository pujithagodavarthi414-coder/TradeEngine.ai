CREATE TABLE [dbo].[MenuItem](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Tooltip] [nvarchar](150) NOT NULL,
	[Icon] [nvarchar](150) NOT NULL,
	[State] [nvarchar](150) NOT NULL,
	[MenuCategoryId] [uniqueidentifier] NOT NULL,
	[OrderNumber] [int] NOT NULL,
	[ParentMenuItemId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,	
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[IsSystemLevel] BIT NULL,
	[IsActive] BIT NULL
    CONSTRAINT [PK_MenuItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
), 
)
GO

ALTER TABLE [dbo].[MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_User_MenuItem_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[MenuItem] CHECK CONSTRAINT [FK_User_MenuItem_CreatedByUserId]
GO
ALTER TABLE [dbo].[MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_MenuCategory_MenuItem_MenuCategoryId] FOREIGN KEY([MenuCategoryId])
REFERENCES [dbo].[MenuCategory] ([Id])
GO

ALTER TABLE [dbo].[MenuItem] CHECK CONSTRAINT [FK_MenuCategory_MenuItem_MenuCategoryId]