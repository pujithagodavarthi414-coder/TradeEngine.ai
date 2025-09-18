CREATE TABLE [dbo].[EmployeeEmergencyContact](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[RelationshipId] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](800) NULL,
	[LastName] [nvarchar](800) NULL,
	[OtherRelation] [nvarchar](250) NULL,
	[HomeTelephone] [nvarchar](250) NULL,
	[MobileNo] [nvarchar](250) NOT NULL,
	[WorkTelephone] [nvarchar](250) NULL,
	[IsEmergencyContact] [bit] NOT NULL,
	[IsDependentContact] [bit] NOT NULL,
	[AddressStreetOne] [nvarchar](2500) NULL,
    [AddressStreetTwo] [nvarchar](2500) NULL,
    [StateOrProvinceId] [uniqueidentifier] NULL,
    [ZipOrPostalCode] [nvarchar](100) NULL,
    [CountryId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
  CONSTRAINT [PK_EmployeeEmergencyContact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[EmployeeEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeEmergencyContact_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeEmergencyContact] CHECK CONSTRAINT [FK_Employee_EmployeeEmergencyContact_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_State_EmployeeEmergencyContact_StateOrProvinceId] FOREIGN KEY([StateOrProvinceId])
REFERENCES [dbo].[State] ([Id])
GO

ALTER TABLE [dbo].[EmployeeEmergencyContact] CHECK CONSTRAINT [FK_State_EmployeeEmergencyContact_StateOrProvinceId]
GO


ALTER TABLE [dbo].[EmployeeEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_RelationShip_EmployeeEmergencyContact_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[RelationShip] ([Id])
GO

ALTER TABLE [dbo].[EmployeeEmergencyContact] CHECK CONSTRAINT [FK_RelationShip_EmployeeEmergencyContact_RelationshipId]
GO
ALTER TABLE [dbo].[EmployeeEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_Country_EmployeeEmergencyContact_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[EmployeeEmergencyContact] CHECK CONSTRAINT [FK_Country_EmployeeEmergencyContact_CountryId]
GO

