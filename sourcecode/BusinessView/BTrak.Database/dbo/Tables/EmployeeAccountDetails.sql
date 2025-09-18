CREATE TABLE [dbo].[EmployeeAccountDetails]
(
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[PFNumber] NVARCHAR(100) NULL,
	[UANNumber] NVARCHAR(100) NULL,
	[ESINumber] NVARCHAR(100) NULL,
	[PANNumber] NVARCHAR(100) NULL,
	[CreatedDateTime] DateTime NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_EmployeeAccountDetails] PRIMARY KEY ([Id]),
)
GO
ALTER TABLE [dbo].[EmployeeAccountDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_EmployeeAccountDetails_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeAccountDetails] CHECK CONSTRAINT [FK_Employee_EmployeeAccountDetails_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeAccountDetails]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeAccountDetails_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeAccountDetails] CHECK CONSTRAINT [FK_EmployeeAccountDetails_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeAccountDetails]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeAccountDetails_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeAccountDetails] CHECK CONSTRAINT [FK_EmployeeAccountDetails_User_UpdatedByUserId]
GO