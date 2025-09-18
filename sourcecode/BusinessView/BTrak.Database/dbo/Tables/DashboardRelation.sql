CREATE TABLE [dbo].[DashboardRelation](
	[DashboardRelationId] [uniqueidentifier] NOT NULL,
	[ParentDashboardId] [uniqueidentifier] NULL,
	[ChildDashboardId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL, 
    CONSTRAINT [PK_DashboardRelation] PRIMARY KEY ([DashboardRelationId])
) ON [PRIMARY]
GO

