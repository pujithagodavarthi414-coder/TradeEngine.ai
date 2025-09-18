CREATE TABLE [dbo].[EmployeeImmigration](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Document] [varchar](50) NOT NULL,
	[DocumentNumber] [nvarchar](100) NOT NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[EligibleStatus] [nvarchar](100) NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[EligibleReviewDate] [datetime] NULL,
	[Comments] [nvarchar](800) NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeImmigration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[EmployeeImmigration]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeImmigration_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeImmigration] CHECK CONSTRAINT [FK_Employee_EmployeeImmigration_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeImmigration]  WITH CHECK ADD  CONSTRAINT [FK_Country_EmployeeImmigration_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[EmployeeImmigration] CHECK CONSTRAINT [FK_Country_EmployeeImmigration_CountryId]
GO