CREATE TABLE [dbo].[EmployeeTaxAllowances](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[TaxAllowanceId]  [uniqueidentifier] NOT NULL,
	[InvestedAmount] [decimal](10,4) NULL,
	[ApprovedDateTime] [datetime]  NULL,
	[ApprovedByEmployeeId] [uniqueidentifier]  NULL,
	[IsAutoApproved] [bit] NOT NULL DEFAULT 0,
	[IsOnlyEmployee] [bit] NOT NULL DEFAULT 0,
	[IsRelatedToHRA] [bit] NULL DEFAULT 0,
	[IsApproved] [bit] NULL DEFAULT 0,
	[OwnerPanNumber] NVARCHAR(100) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[Comments] NVARCHAR(1000),
	[RelatedToMetroCity] [bit] NULL DEFAULT 0,
    CONSTRAINT [PK_EmployeeTaxAllowances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeTaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTaxAllowances_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTaxAllowances] CHECK CONSTRAINT [FK_EmployeeTaxAllowances_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeTaxAllowances]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTaxAllowances_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTaxAllowances] CHECK CONSTRAINT [FK_EmployeeTaxAllowances_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[EmployeeTaxAllowances]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeTaxAllowances_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeTaxAllowances] CHECK CONSTRAINT [FK_EmployeeTaxAllowances_Employee_EmployeeId]
GO