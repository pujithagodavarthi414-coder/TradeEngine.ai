CREATE TABLE UserStoryType (
Id UNIQUEIDENTIFIER NOT NULL,
CompanyId [uniqueidentifier]  NULL,
UserStoryTypeName NVARCHAR(500) NOT NULL,
[CreatedDateTime] DATETIMEOFFSET NOT NULL,
[CreatedByUserId] [uniqueidentifier] NOT NULL,
[UpdatedDateTime] DATETIMEOFFSET NULL,
[UpdatedByUserId] [uniqueidentifier] NULL,
[InActiveDateTime] DATETIMEOFFSET NULL,
[ShortName] NVARCHAR(50) NULL, 
[IsBug] BIT NULL, 
[IsUserStory] BIT NULL, 
[TimeStamp] TIMESTAMP, 
[IsFillForm] BIT NULL, 
[IsQaRequired] BIT NULL, 
[IsLogTimeRequired] BIT NULL,
[IsAction] BIT NULL,
[IsApproveOrDecline] BIT NULL,
[Color] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_UserStoryType] PRIMARY KEY ([Id])
)
GO

CREATE NONCLUSTERED INDEX [IX_UserStoryType_InActiveDateTime_IsBug]
ON [dbo].[UserStoryType] ([InActiveDateTime],[IsBug])
INCLUDE ([Id])
GO