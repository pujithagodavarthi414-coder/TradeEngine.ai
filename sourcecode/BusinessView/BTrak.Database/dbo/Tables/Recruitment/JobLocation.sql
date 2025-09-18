CREATE TABLE [dbo].[JobLocation]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    BranchId UNIQUEIDENTIFIER NOT NULL, 
	JobOpeningId UNIQUEIDENTIFIER,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_JobLocation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[JobLocation]  WITH CHECK ADD  CONSTRAINT [FK_JobLocation_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobLocation] CHECK CONSTRAINT [FK_JobLocation_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[JobLocation]  WITH CHECK ADD  CONSTRAINT [FK_JobLocation_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobLocation] CHECK CONSTRAINT [FK_JobLocation_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[JobLocation]  WITH CHECK ADD  CONSTRAINT [FK_JobLocation_JobOpening_JobOpeningId] FOREIGN KEY([JobOpeningId])
REFERENCES [dbo].[JobOpening] ([Id])
GO

ALTER TABLE [dbo].[JobLocation] CHECK CONSTRAINT [FK_JobLocation_JobOpening_JobOpeningId]
GO

ALTER TABLE [dbo].[JobLocation]  WITH CHECK ADD  CONSTRAINT [FK_JobLocation_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[JobLocation] CHECK CONSTRAINT [FK_JobLocation_Branch_BranchId]
GO