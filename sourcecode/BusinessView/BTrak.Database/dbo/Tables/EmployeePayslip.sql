CREATE  TABLE [dbo].[EmployeePayslip](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[PayslipLink] [nvarchar](max) NULL,
	[GeneratedDate] [datetime]  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_EmployeePayslip] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeePayslip]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeePayslip_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeePayslip] CHECK CONSTRAINT [FK_EmployeePayslip_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeePayslip]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayslip_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeePayslip] CHECK CONSTRAINT [FK_EmployeePayslip_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeePayslip]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayslip_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeePayslip] CHECK CONSTRAINT [FK_EmployeePayslip_User_UpdatedByUserId]
GO