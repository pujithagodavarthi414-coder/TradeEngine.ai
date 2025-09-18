CREATE TABLE UserStoryPriority (
Id UNIQUEIDENTIFIER NOT NULL,
PriorityName NVARCHAR(200) NOT NULL,
[CompanyId] [uniqueidentifier] NULL,
[CreatedDateTime] DATETIMEOFFSET NOT NULL,
[CreatedByUserId] [uniqueidentifier] NOT NULL,
[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
[Order] INT NULL, 
[IsHigh] BIT NULL, 
[IsMedium] BIT NULL, 
[IsLow] BIT NULL, 
[InActiveDateTime] DATETIMEOFFSET NULL,
[TimeStamp] TIMESTAMP NULL, 
CONSTRAINT [PK_UserStoryPriority] PRIMARY KEY ([Id]), 
)
GO

ALTER TABLE [dbo].[UserStoryPriority]  WITH CHECK ADD  CONSTRAINT [FK_Company_UserStoryPriority_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[UserStoryPriority] CHECK CONSTRAINT [FK_Company_UserStoryPriority_CompanyId]
GO