CREATE  TABLE [dbo].[EmployeeBonus](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Bonus] [decimal](18, 4) NULL,
	[GeneratedDate] [datetime]  NULL,
	[PayrollRunEmployeeId][uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsArchived] bit,
	[IsApproved] bit,
	[IsCtcType] [bit] NULL DEFAULT 0,
	[PayRollComponentId] [uniqueidentifier] NULL,
	[Percentage] [decimal](18,4) NULL,
	[IsPaid] BIT NULL,
	[IsProcessed] BIT NULL
    CONSTRAINT [PK_EmployeeBonus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeBonus]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeBonus_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeBonus] CHECK CONSTRAINT [FK_EmployeeBonus_Employee_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeBonus]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeBonus_PayrollRunEmployee_PayrollRunEmployeeId] FOREIGN KEY([PayrollRunEmployeeId])
REFERENCES [dbo].[PayrollRunEmployee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeBonus] CHECK CONSTRAINT [FK_EmployeeBonus_PayrollRunEmployee_PayrollRunEmployeeId]
GO

ALTER TABLE [dbo].[EmployeeBonus]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBonus_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeBonus] CHECK CONSTRAINT [FK_EmployeeBonus_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeBonus]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBonus_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[EmployeeBonus] CHECK CONSTRAINT [FK_EmployeeBonus_User_UpdatedByUserId]
GO
