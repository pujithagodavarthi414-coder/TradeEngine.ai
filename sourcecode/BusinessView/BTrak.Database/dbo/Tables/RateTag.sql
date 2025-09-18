CREATE TABLE [dbo].[RateTag]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[CompanyId] [uniqueidentifier] NULL,
    [RateTagName] NVARCHAR(250) NOT NULL,
    [RatePerHour] decimal(18,2),
    [RatePerHourMon] decimal(18,2),
    [RatePerHourTue] decimal(18,2),
    [RatePerHourWed] decimal(18,2),
    [RatePerHourThu] decimal(18,2),
    [RatePerHourFri] decimal(18,2),
    [RatePerHourSat] decimal(18,2),
    [RatePerHourSun] decimal(18,2),
	[MinTime] INT NULL,
    [MaxTime] INT NULL,
    [RoleId] UNIQUEIDENTIFIER,
    [BranchId] UNIQUEIDENTIFIER,
    [EmployeeId] UNIQUEIDENTIFIER,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_RateTag] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[RateTag]  WITH NOCHECK ADD CONSTRAINT [FK_RateTag_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[RateTag] CHECK CONSTRAINT [FK_RateTag_Company_CompanyId]
GO

ALTER TABLE [dbo].[RateTag]  WITH CHECK ADD  CONSTRAINT [FK_RateTag_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTag] CHECK CONSTRAINT [FK_RateTag_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[RateTag]  WITH CHECK ADD  CONSTRAINT [FK_RateTag_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTag] CHECK CONSTRAINT [FK_RateTag_User_UpdatedByUserId]
GO