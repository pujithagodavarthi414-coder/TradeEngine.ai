CREATE TABLE [dbo].[ActivityTrackerDesktop]
(
	[Id] [uniqueidentifier] NOT NULL,
	[DesktopDeviceId] NVARCHAR(250) NULL,
	[DesktopName] NVARCHAR(500) NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[OSName] NVARCHAR(250) NULL,
	[OSVersion] NVARCHAR(150) NULL,
	[Platform] NVARCHAR(150) NULL,
	[TimechampVersion] NVARCHAR(50) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LatestScreenShotId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ActivityTrackerDesktop] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ActivityTrackerDesktop]  WITH CHECK ADD  CONSTRAINT [FK_ActivityTrackerDesktop_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
										
ALTER TABLE [dbo].[ActivityTrackerDesktop] CHECK CONSTRAINT [FK_ActivityTrackerDesktop_Company]
GO