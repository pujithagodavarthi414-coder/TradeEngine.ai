CREATE TABLE [dbo].[PortDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(800) NOT NULL,
    [PortCategoryId] UNIQUEIDENTIFIER NULL,
    [CreatedDateTime] DATETIME NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [InActiveDateTime] DATETIME NULL,
	[UpdatedDateTime] DATETIME NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [TimeStamp] TIMESTAMP
)
GO


ALTER TABLE [dbo].[PortDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_PortCategory_PortDetails_PortCategoryId] FOREIGN KEY([PortCategoryId])
REFERENCES [dbo].[PortCategory] ([Id])
GO

ALTER TABLE [dbo].[PortDetails] CHECK CONSTRAINT [FK_PortCategory_PortDetails_PortCategoryId]
GO