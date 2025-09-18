CREATE  TABLE [dbo].[EmployeeSalaryCerficate](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[SalaryCertificateLink] [nvarchar](max) NULL,
	[GeneratedDate] [datetime]  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_EmployeeSalaryCerficate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeSalaryCerficate]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeSalaryCerficate_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalaryCerficate] CHECK CONSTRAINT [FK_EmployeeSalaryCerficate_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeSalaryCerficate]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeSalaryCerficate_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalaryCerficate] CHECK CONSTRAINT [FK_EmployeeSalaryCerficate_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeSalaryCerficate]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeSalaryCerficate_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeSalaryCerficate] CHECK CONSTRAINT [FK_EmployeeSalaryCerficate_User_UpdatedByUserId]
GO