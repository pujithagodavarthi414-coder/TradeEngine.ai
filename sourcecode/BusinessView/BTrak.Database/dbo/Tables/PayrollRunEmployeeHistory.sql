CREATE  TABLE [dbo].[PayrollRunEmployeeHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollRunEmployeeId] [uniqueidentifier] NOT NULL,
	[OldAmount] [decimal](18, 4)  NULL,
	[UpdatedAmount] [decimal](18, 4)  NULL,
	[UpdatedBy] [uniqueidentifier] NOT NULL,
	[Comment] [nvarchar](500) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollRunEmployeeHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollRunEmployeeHistory]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunEmployeeHistory_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployeeHistory] CHECK CONSTRAINT [FK_PayrollRunEmployeeHistory_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[PayrollRunEmployeeHistory]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunEmployeeHistory_User_PayrollRunEmployeeId] FOREIGN KEY([PayrollRunEmployeeId])
REFERENCES [dbo].[PayrollRunEmployee] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunEmployeeHistory] CHECK CONSTRAINT [FK_PayrollRunEmployeeHistory_User_PayrollRunEmployeeId]
GO
