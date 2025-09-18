CREATE TABLE [dbo].[EmployeeContactDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Address1] [nvarchar](500) NULL,
	[Address2] [nvarchar](500) NULL,
	[PostalCode] [nvarchar](100) NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[HomeTelephoneno] [nvarchar](20) NULL,
	[Mobile] [nvarchar](20) NULL,
	[WorkTelephoneno] [nvarchar](20) NULL,
	[WorkEmail] [nvarchar](200) NULL,
	[OtherEmail] [nvarchar](200) NULL,
	[StateId] [uniqueidentifier] NULL,
	[ContactPersonName] [nvarchar](100) NULL,
	[Relationship] [nvarchar](100) NULL,
	[DateOfBirth] [datetime] NULL,
	[EmployeeContactTypeId] [uniqueidentifier] NULL,
	[CreatedDateTime] DateTime NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[RelationshipId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EmployeeContactDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO


ALTER TABLE [dbo].[EmployeeContactDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_EmployeeContactDetails_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeContactDetails] CHECK CONSTRAINT [FK_Employee_EmployeeContactDetails_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeContactDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Country_EmployeeContactDetails_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[EmployeeContactDetails] CHECK CONSTRAINT [FK_Country_EmployeeContactDetails_CountryId]
GO

ALTER TABLE [dbo].[EmployeeContactDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_MasterTable_EmployeeContactDetails_EmployeeContactTypeId] FOREIGN KEY([EmployeeContactTypeId])
REFERENCES [dbo].[MasterTable] ([Id])
GO

ALTER TABLE [dbo].[EmployeeContactDetails] CHECK CONSTRAINT [FK_MasterTable_EmployeeContactDetails_EmployeeContactTypeId]
GO

ALTER TABLE [dbo].[EmployeeContactDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_State_EmployeeContactDetails_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([Id])
GO

ALTER TABLE [dbo].[EmployeeContactDetails] CHECK CONSTRAINT [FK_State_EmployeeContactDetails_StateId]
GO

ALTER TABLE [dbo].[EmployeeContactDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_RelationShip_EmployeeContactDetails_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[RelationShip] ([Id])
GO

ALTER TABLE [dbo].[EmployeeContactDetails] CHECK CONSTRAINT [FK_RelationShip_EmployeeContactDetails_RelationshipId]
GO

