CREATE TABLE [dbo].[WorkFlowType](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkFlowTypeName] [nvarchar](250) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL
 CONSTRAINT [PK_WorkFlowType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]
GO