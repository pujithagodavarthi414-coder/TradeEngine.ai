CREATE TABLE [dbo].[ResetPassword](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ResetGuid] [uniqueidentifier] NOT NULL,
	[OTP] INT NULL,
	[IsExpired] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_ResetPassword] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[ResetPassword]  WITH CHECK ADD  CONSTRAINT [FK_User_ResetPassword_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ResetPassword] CHECK CONSTRAINT [FK_User_ResetPassword_UserId]