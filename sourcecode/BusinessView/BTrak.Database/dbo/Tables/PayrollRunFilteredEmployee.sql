CREATE  TABLE [dbo].[PayrollRunFilteredEmployee](
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollRunId]  [uniqueidentifier] NOT NULL,
	[EmployeeId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollRunFilteredEmployee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].PayrollRunFilteredEmployee  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunFilteredEmployee_PayrollRun_PayrollRunId] FOREIGN KEY([PayrollRunId])
REFERENCES [dbo].[PayrollRun] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmployee CHECK CONSTRAINT [FK_PayrollRunFilteredEmployee_PayrollRun_PayrollRunId]
GO

ALTER TABLE [dbo].PayrollRunFilteredEmployee  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunFilteredEmployee_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmployee CHECK CONSTRAINT [FK_PayrollRunFilteredEmployee_Employee_EmployeeId]
GO


ALTER TABLE [dbo].PayrollRunFilteredEmployee  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunFilteredEmployee_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmployee CHECK CONSTRAINT [FK_PayrollRunFilteredEmployee_User_CreatedByUserId]
GO
ALTER TABLE [dbo].PayrollRunFilteredEmployee  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunFilteredEmployee_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmployee CHECK CONSTRAINT [FK_PayrollRunFilteredEmployee_User_UpdatedByUserId]
GO
