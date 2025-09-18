CREATE TABLE [dbo].[EmployeeLicence](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[LicenceTypeId] [uniqueidentifier] NOT NULL,
	[LicenceNumber] [nvarchar](500) NOT NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeLicence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[EmployeeLicence]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeLicence_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLicence] CHECK CONSTRAINT [FK_Employee_EmployeeLicence_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeLicence]  WITH CHECK ADD  CONSTRAINT [FK_LicenceType_EmployeeLicence_LicenceTypeId] FOREIGN KEY([LicenceTypeId])
REFERENCES [dbo].[LicenceType] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLicence] CHECK CONSTRAINT [FK_LicenceType_EmployeeLicence_LicenceTypeId]
GO
