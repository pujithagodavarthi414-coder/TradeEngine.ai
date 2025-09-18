CREATE TABLE [dbo].[PayrollStatus]
(
	[Id] [uniqueidentifier] NOT NULL,
    [CompanyId] [uniqueidentifier] NULL,
    [PayrollStatusName] [nvarchar](800) NOT NULL,
	[PayRollStatusColour] [nvarchar](50) NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
	[IsArchived] bit default 0
CONSTRAINT [PK_PayrollStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollStatus]  WITH CHECK ADD  CONSTRAINT [FK_PayrollStatus_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollStatus] CHECK CONSTRAINT [FK_PayrollStatus_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[PayrollStatus]  WITH CHECK ADD  CONSTRAINT [FK_PayrollStatus_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollStatus] CHECK CONSTRAINT [FK_PayrollStatus_User_UpdatedByUserId]
GO