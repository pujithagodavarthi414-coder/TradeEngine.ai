CREATE TABLE [dbo].[CustomApplication](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomApplicationName] [nvarchar](250) NOT NULL,
	[PublicMessage] [nvarchar](500) NULL,
	[Description] [nvarchar](MAX) NULL, 
	[IsPublished] [bit] NULL,
	[IsApproveNeeded] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [IsPdfRequired] BIT NULL, 
    [IsRedirectToEmails] BIT NULL, 
    [WorkflowIds] NVARCHAR(MAX) NULL, 
    [Allowannonymous] BIT NULL, 
    [ToEmails] NVARCHAR(MAX) NULL, 
    [ToRoleIds] NVARCHAR(MAX) NULL, 
    [Subject] NVARCHAR(MAX) NULL, 
    [Message] NVARCHAR(MAX) NULL, 
	IsRecordLevelPermissionEnabled BIT,
	RecordLevelPermissionFieldName NVARCHAR(500),
    [ConditionalEnum] INT NULL,
	ConditionsJson NVARCHAR(MAX) NULL,
	StageScenariosJson NVARCHAR(MAX) NULL,
	[ApproveSubject] NVARCHAR(MAX) NULL,
	[ApproveMessage] NVARCHAR(MAX) NULL
    CONSTRAINT [PK_CustomApplication] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO