CREATE TABLE [dbo].[DefaultWorkFlowForReferenceTypes]
(
    [Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [AuditDefaultWorkflowId] [uniqueidentifier] NULL,
	[ConductDefaultWorkflowId] [uniqueidentifier] NULL,
	[QuestionDefaultWorkflowId] [uniqueidentifier] NULL,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL
)