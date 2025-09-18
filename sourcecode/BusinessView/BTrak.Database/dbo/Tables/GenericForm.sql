CREATE TABLE [dbo].[GenericForm](
	[Id] [uniqueidentifier] NOT NULL,
	[FormTypeId] [uniqueidentifier] NULL,
	[DataSourceId] [uniqueidentifier] NULL,
	[FormName] [nvarchar](250) NOT NULL,
	[FormJson] [nvarchar](MAX) NOT NULL,
	[WorkflowTrigger] [nvarchar](MAX) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
	[CompanyModuleId] [uniqueidentifier] NULL
 CONSTRAINT [PK_GenericForm] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE NONCLUSTERED INDEX IX_GenericForm_FormTypeId
ON [dbo].[GenericForm] ([FormTypeId])
INCLUDE ([Id],[FormName],[FormJson],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[TimeStamp])
GO

CREATE NONCLUSTERED INDEX [IX_GenericForm_InActiveDateTime]
ON [dbo].[GenericForm] ([InActiveDateTime])
INCLUDE ([Id],[FormTypeId])
GO