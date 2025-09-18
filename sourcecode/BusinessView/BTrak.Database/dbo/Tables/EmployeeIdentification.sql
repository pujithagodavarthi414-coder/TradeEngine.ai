CREATE TABLE [dbo].[EmployeeIdentification](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[IdentificationNumber] [nvarchar](800) NOT NULL,
	[Description] [nvarchar](800) NOT NULL,
	[StartDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeIdentification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_EmployeeIdentification_EmployeeId] UNIQUE ([EmployeeId])
)
GO
ALTER TABLE [dbo].[EmployeeIdentification]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeIdentification_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeIdentification] CHECK CONSTRAINT [FK_Employee_EmployeeIdentification_EmployeeId]
GO