CREATE TABLE [dbo].[InterviewTypeRoleCofiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    RoleId UNIQUEIDENTIFIER NOT NULL, 
	InterviewTypeId UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_InterviewTypeRoleCofiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeRoleCofiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration] CHECK CONSTRAINT [FK_InterviewTypeRoleCofiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[InterviewTypeRoleCofiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeRoleCofiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration] CHECK CONSTRAINT [FK_InterviewTypeRoleCofiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeRoleCofiguration_Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration] CHECK CONSTRAINT [FK_InterviewTypeRoleCofiguration_Role_RoleId]
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration]  WITH CHECK ADD  CONSTRAINT [FK_InterviewTypeRoleCofiguration_InterviewType_InterviewTypeId] FOREIGN KEY([InterviewTypeId])
REFERENCES [dbo].[InterviewType] ([Id])
GO

ALTER TABLE [dbo].[InterviewTypeRoleCofiguration] CHECK CONSTRAINT [FK_InterviewTypeRoleCofiguration_InterviewType_InterviewTypeId]
GO