CREATE TABLE [dbo].[JobOpeningStatus]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [Status] NVARCHAR(50) NOT NULL, 
    [Order] INT NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 [StatusColour] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_[JobOpeningStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[JobOpeningStatus]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningStatus_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningStatus] CHECK CONSTRAINT [FK_JobOpeningStatus_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[JobOpeningStatus]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningStatus_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningStatus] CHECK CONSTRAINT [FK_JobOpeningStatus_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[JobOpeningStatus]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningStatus_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningStatus] CHECK CONSTRAINT [FK_JobOpeningStatus_Company_CompanyId]
GO