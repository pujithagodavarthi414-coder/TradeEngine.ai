CREATE TABLE [dbo].[FormWorkflows](
	[Id] [uniqueidentifier] NOT NULL,
	[FormTypeId] [uniqueidentifier] NOT NULL,
	[WorkflowName] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
