CREATE TABLE [dbo].[WorkFlow](
	[Id] [uniqueidentifier] NOT NULL,
	[Workflow] [nvarchar](250) NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_WorkFlow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO
CREATE NONCLUSTERED INDEX IX_WorkFlow_Workflow_CompanyId_InActiveDateTime
ON [dbo].[WorkFlow] ([Workflow],[CompanyId],[InActiveDateTime])
