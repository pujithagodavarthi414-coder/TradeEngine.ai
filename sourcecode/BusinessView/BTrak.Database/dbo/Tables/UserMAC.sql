CREATE TABLE [dbo].[UserMAC](
	[Id] [uniqueidentifier] NOT NULL,
	[MACAddress] [nvarchar](20) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AssetId] [uniqueidentifier] NULL,
	[DateFrom] [datetime] NULL,
	[DateTo] [datetime] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_UserMAC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserMAC]  WITH CHECK ADD  CONSTRAINT [FK_User_UserMAC_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserMAC] CHECK CONSTRAINT [FK_User_UserMAC_UserId]
GO