CREATE TABLE [dbo].[InterviewProcess]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [InterviewProcessName] NVARCHAR(500) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_InterviewProcess] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[InterviewProcess]  WITH CHECK ADD  CONSTRAINT [FK_InterviewProcess_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewProcess] CHECK CONSTRAINT [FK_InterviewProcess_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[InterviewProcess]  WITH CHECK ADD  CONSTRAINT [FK_InterviewProcess_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[InterviewProcess] CHECK CONSTRAINT [FK_InterviewProcess_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[InterviewProcess]  WITH CHECK ADD  CONSTRAINT [FK_InterviewProcess_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[InterviewProcess] CHECK CONSTRAINT [FK_InterviewProcess_Company_CompanyId]
GO