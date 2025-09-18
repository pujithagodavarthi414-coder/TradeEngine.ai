CREATE TABLE [dbo].[CustomApplicationWorkflow]
(
	[Id] [uniqueidentifier] NOT NULL 
	,[WorkflowName] NVARCHAR(1000) NULL
	,[WorkflowTrigger] NVARCHAR(2000) NULL
	,[Rulejson] NVARCHAR(MAX) NULL
	,[WorkflowXml] NVARCHAR(MAX) NULL
	,[WorkflowTypeId] UNIQUEIDENTIFIER NULL
	,CreatedbyUserId [uniqueidentifier] NOT NULL
	,CreatedDateTime [datetime] NOT NULL
	,[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL
	,CustomApplicationId [uniqueidentifier] NOT NULL
	,FormId [uniqueidentifier] NULL
 CONSTRAINT [PK_CustomApplicationWorkflow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomApplicationWorkflow]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomApplication_CustomApplicationWorkflow_CustomApplicationId] FOREIGN KEY([CustomApplicationId])
REFERENCES [dbo].[CustomApplication] ([Id])
GO

ALTER TABLE [dbo].[CustomApplicationWorkflow]  CHECK CONSTRAINT [FK_CustomApplication_CustomApplicationWorkflow_CustomApplicationId]
GO

ALTER TABLE [dbo].[CustomApplicationWorkflow]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkFlowType_CustomApplicationWorkflow_WorkflowTypeId] FOREIGN KEY([WorkflowTypeId])
REFERENCES [dbo].[WorkFlowType] ([Id])
GO

ALTER TABLE [dbo].[CustomApplicationWorkflow]  CHECK CONSTRAINT [FK_WorkFlowType_CustomApplicationWorkflow_WorkflowTypeId]
GO