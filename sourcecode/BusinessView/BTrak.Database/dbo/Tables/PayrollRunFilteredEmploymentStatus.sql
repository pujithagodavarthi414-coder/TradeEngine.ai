CREATE TABLE [dbo].[PayrollRunFilteredEmploymentStatus]
(
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollRunId]  [uniqueidentifier] NOT NULL,
	[EmploymentStatusId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollRunFilteredEmploymentStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_PayrollRun_PayrollRunId] FOREIGN KEY([PayrollRunId])
REFERENCES [dbo].[PayrollRun] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus CHECK CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_PayrollRun_PayrollRunId]
GO

ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_EmploymentStatus_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].EmploymentStatus ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus CHECK CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_EmploymentStatus_EmploymentStatusId]
GO


ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus CHECK CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_User_CreatedByUserId]
GO
ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].PayrollRunFilteredEmploymentStatus CHECK CONSTRAINT [FK_PayrollRunFilteredEmploymentStatus_User_UpdatedByUserId]
GO