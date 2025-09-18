CREATE TABLE [dbo].[PayrollRunEmployeeComponentYTD](
	[Id] [uniqueidentifier] NOT NULL,
	[ComponentAmount] [decimal](18,4) NULL,
	[OriginalComponentAmount] [decimal](18,4) NULL,
	[IsDeduction] [bit] NULL,
	[ComponentId]  [uniqueidentifier] NOT NULL,
	ComponentName NVARCHAR(500),
	[PayrollRunId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[Comments] [nvarchar](800) NULL
    CONSTRAINT [PK_PayrollRunEmployeeComponentYTD] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollRunEmployeeComponentYTD]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunEmployeeComponentYTD_PayrollComponent_ComponentId] FOREIGN KEY([ComponentId])
REFERENCES [dbo].[PayrollComponent] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployeeComponentYTD] CHECK CONSTRAINT [FK_PayrollRunEmployeeComponentYTD_PayrollComponent_ComponentId]
GO


ALTER TABLE [dbo].[PayrollRunEmployeeComponentYTD]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunEmployeeComponentYTD_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployeeComponentYTD] CHECK CONSTRAINT [FK_PayrollRunEmployeeComponentYTD_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollRunEmployeeComponentYTD]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunEmployeeComponentYTD_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployeeComponentYTD] CHECK CONSTRAINT [FK_PayrollRunEmployeeComponentYTD_User_UpdatedByUserId]
GO