CREATE TABLE [dbo].[DashboardConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[DashboardId] [uniqueidentifier] NOT NULL,
	[DefaultDashboardRoles] [nvarchar](MAX) NULL,
	[ViewRoles] [nvarchar](MAX) NULL,
	[EditRoles] [nvarchar](MAX) NULL,
	[DeleteRoles] [nvarchar](MAX) NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DashboardConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_DashboardConfiguration_Workspace] FOREIGN KEY ([DashboardId]) REFERENCES [Workspace]([Id]), 
    CONSTRAINT [FK_DashboardConfiguration_Company] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id])
) ON [PRIMARY]
GO