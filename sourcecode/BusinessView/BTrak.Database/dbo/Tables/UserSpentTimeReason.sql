CREATE TABLE [dbo].[UserSpentTimeReason](
	[Id] [uniqueidentifier] NOT NULL,
	[Comment] [nvarchar](MAX) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_UserSpentTimeReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[UserSpentTimeReason]  WITH CHECK ADD  CONSTRAINT [FK_User_UserSpentTimeReason_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserSpentTimeReason] CHECK CONSTRAINT [FK_User_UserSpentTimeReason_UserId]
GO
