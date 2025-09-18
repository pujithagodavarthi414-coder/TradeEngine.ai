CREATE TABLE [dbo].[RateTagFor]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[CompanyId] [uniqueidentifier] NULL,
    [RateTagForName] NVARCHAR(250) NOT NULL,
	IsAllowance BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP
CONSTRAINT [PK_RateTagFor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[RateTagFor]  WITH NOCHECK ADD CONSTRAINT [FK_RateTagFor_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[RateTagFor] CHECK CONSTRAINT [FK_RateTagFor_Company_CompanyId]
GO

ALTER TABLE [dbo].[RateTagFor]  WITH CHECK ADD  CONSTRAINT [FK_RateTagFor_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagFor] CHECK CONSTRAINT [FK_RateTagFor_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[RateTagFor]  WITH CHECK ADD  CONSTRAINT [FK_RateTagFor_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagFor] CHECK CONSTRAINT [FK_RateTagFor_User_UpdatedByUserId]
GO