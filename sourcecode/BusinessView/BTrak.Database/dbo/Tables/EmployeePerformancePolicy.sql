CREATE TABLE [dbo].[EmployeePerformancePolicy](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[PayPolicyId] [uniqueidentifier] NOT NULL,
	[FromDate] [datetime]  NULL,
	[ToDate] [datetime]  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [PK_EmployeePerformancePolicy] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeePerformancePolicy_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy] CHECK CONSTRAINT [FK_EmployeePerformancePolicy_Employee_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeePerformancePolicy_PayPolicy_PayPolicyId] FOREIGN KEY([PayPolicyId])
REFERENCES [dbo].[PayPolicy] ([Id])
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy] CHECK CONSTRAINT [FK_EmployeePerformancePolicy_PayPolicy_PayPolicyId]
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePerformancePolicy_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy] CHECK CONSTRAINT [FK_EmployeePerformancePolicy_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeePerformancePolicy]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePerformancePolicy_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeePerformancePolicy] CHECK CONSTRAINT [FK_EmployeePerformancePolicy_User_UpdatedByUserId]
GO