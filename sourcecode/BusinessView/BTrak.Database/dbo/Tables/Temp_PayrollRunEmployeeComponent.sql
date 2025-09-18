CREATE TABLE [dbo].[Temp_PayrollRunEmployeeComponent](
	[Id] [uniqueidentifier] NOT NULL,
	[ComponentName] [nvarchar](250) NULL,
	[ComponentAmount] [decimal](18,4) NULL,
	ActualComponentAmount [decimal](18,4) NULL,
	OriginalComponentAmount [decimal](18,4) NULL,
	OriginalActualComponentAmount [decimal](18,4) NULL,
	[IsDeduction] [bit] NULL,
	[ComponentId]  [uniqueidentifier] NOT NULL,
	[IsLoanEmi] [bit] NULL,
	[ComponentConfigurationJson]  [nvarchar](MAX) NULL,
	[PayrollRunId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[IsBonus] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Temp_PayrollRunEmployeeComponent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].Temp_PayrollRunEmployeeComponent  WITH NOCHECK ADD CONSTRAINT [FK_Temp_PayrollRunEmployeeComponent_PayrollComponent_ComponentId] FOREIGN KEY([ComponentId])
REFERENCES [dbo].[PayrollComponent] ([Id])
GO

ALTER TABLE [dbo].Temp_PayrollRunEmployeeComponent CHECK CONSTRAINT [FK_Temp_PayrollRunEmployeeComponent_PayrollComponent_ComponentId]
GO


ALTER TABLE [dbo].Temp_PayrollRunEmployeeComponent  WITH CHECK ADD  CONSTRAINT [FK_Temp_PayrollRunEmployeeComponent_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].Temp_PayrollRunEmployeeComponent CHECK CONSTRAINT [FK_Temp_PayrollRunEmployeeComponent_User_CreatedByUserId]
GO
ALTER TABLE [dbo].Temp_PayrollRunEmployeeComponent  WITH CHECK ADD  CONSTRAINT [FK_Temp_PayrollRunEmployeeComponent_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].Temp_PayrollRunEmployeeComponent CHECK CONSTRAINT [FK_Temp_PayrollRunEmployeeComponent_User_UpdatedByUserId]
GO