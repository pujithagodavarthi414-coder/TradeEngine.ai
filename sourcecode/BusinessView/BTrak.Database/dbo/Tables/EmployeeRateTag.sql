CREATE TABLE [dbo].[EmployeeRateTag]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[RateTagEmployeeId] UNIQUEIDENTIFIER NOT NULL, 
	[RateTagId] UNIQUEIDENTIFIER NOT NULL, 
	[CompanyId] UNIQUEIDENTIFIER NULL,
	[RateTagName] NVARCHAR(250) NULL,
    [RateTagCurrencyId] UNIQUEIDENTIFIER NULL,
	[RateTagForId] UNIQUEIDENTIFIER NULL,
	[RateTagStartDate] DATETIME NULL,
	[RateTagEndDate] DATETIME NULL,
	[Priority] INT NULL,
    [RatePerHour] decimal(18,2),
    [RatePerHourMon] decimal(18,2),
    [RatePerHourTue] decimal(18,2),
    [RatePerHourWed] decimal(18,2),
    [RatePerHourThu] decimal(18,2),
    [RatePerHourFri] decimal(18,2),
    [RatePerHourSat] decimal(18,2),
    [RatePerHourSun] decimal(18,2),
	IsOverrided BIT,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[GroupPriority] INT NULL,
	[RoleId] [uniqueidentifier] NULL,
	[BranchId] [uniqueidentifier] NULL
CONSTRAINT [PK_EmployeeRateTag] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[EmployeeRateTag]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeRateTag_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_Company_CompanyId]
GO

ALTER TABLE [dbo].[EmployeeRateTag]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRateTag_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[EmployeeRateTag]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRateTag_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeRateTag]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRateTag_RateTag_RateTagCurrencyId] FOREIGN KEY([RateTagCurrencyId])
REFERENCES [dbo].[SYS_Currency] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_RateTag_RateTagCurrencyId]
GO
ALTER TABLE [dbo].[EmployeeRateTag]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRateTag_Employee_RateTagEmployeeId] FOREIGN KEY([RateTagEmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_Employee_RateTagEmployeeId]
GO
ALTER TABLE [dbo].[EmployeeRateTag]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRateTag_Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_Role_RoleId]
GO
ALTER TABLE [dbo].[EmployeeRateTag]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRateTag_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[EmployeeRateTag] CHECK CONSTRAINT [FK_EmployeeRateTag_Branch_BranchId]
GO