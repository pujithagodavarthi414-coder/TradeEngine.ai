CREATE TABLE [dbo].[RecentSearch]
(
[Id] uniqueidentifier NOT NULL,
[CreatedByUserId] uniqueidentifier NOT NULL,
[SearchText] nvarchar(max) NOT NULL,
[CreatedDateTime] datetime NOT NULL,
[InActiveDateTime] datetime NULL,
[TimeStamp] timestamp NOT NULL,
[SearchType] [int] NULL,
[ItemId] [uniqueidentifier] NULL
)
GO 

ALTER TABLE [dbo].[RecentSearch]
ADD CONSTRAINT PK_RecentSearch PRIMARY KEY (Id);
