CREATE TABLE [dbo].[TestCase] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [Title]            NVARCHAR (500)   NULL,
    [SectionId]        UNIQUEIDENTIFIER NULL,
    [TemplateId]       UNIQUEIDENTIFIER NULL,
    [TypeId]           UNIQUEIDENTIFIER NULL,
    [Estimate]         INT   NULL,
    [Order]            INT   NULL,
    [References]       NVARCHAR (max)   NULL,
    [Steps]            NVARCHAR (MAX)  NULL,
    [ExpectedResult]   NVARCHAR (MAX)   NULL,
    [CreatedDateTime]  DATETIME         NOT NULL,
    [CreatedByUserId]  UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
    [Mission]          NVARCHAR (MAX)  NULL,
    [Goals]            NVARCHAR (MAX)  NULL,
    [PriorityId]       UNIQUEIDENTIFIER NULL,
    [AutomationTypeId] UNIQUEIDENTIFIER NULL,
    [TestCaseId]       NVARCHAR(100) NULL,
    [TestSuiteId]      UNIQUEIDENTIFIER NULL,
    [PreCondition]     NVARCHAR (MAX)   NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestCase] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestCase_AutomationType] FOREIGN KEY ([AutomationTypeId]) REFERENCES [dbo].[TestCaseAutomationType] ([Id]),
    CONSTRAINT [FK_TestCase_PriorityId] FOREIGN KEY ([PriorityId]) REFERENCES [dbo].[TestCasePriority] ([Id]),
    CONSTRAINT [FK_TestCase_Template] FOREIGN KEY ([TemplateId]) REFERENCES [dbo].[TestCaseTemplate] ([Id]),
    CONSTRAINT [FK_TestCase_TestSuite] FOREIGN KEY ([TestSuiteId]) REFERENCES [dbo].[TestSuite] ([Id]),
    CONSTRAINT [FK_TestCase_Type] FOREIGN KEY ([TypeId]) REFERENCES [dbo].[TestCaseType] ([Id]),
    CONSTRAINT [PK_TestCaseInt] UNIQUE NONCLUSTERED ([Id] ASC), 
);
GO

ALTER TABLE [dbo].[TestCase] WITH NOCHECK ADD CONSTRAINT [FK_TestSuiteSection_TestCase_SectionId] FOREIGN KEY ([SectionId])
REFERENCES [dbo].[TestSuiteSection] ([Id])
GO

ALTER TABLE [dbo].[TestCase] CHECK CONSTRAINT [FK_TestSuiteSection_TestCase_SectionId]
GO

CREATE NONCLUSTERED INDEX IDX_TestCase_InActiveDateTime 
ON [dbo].[TestCase] (  InActiveDateTime ASC  )   
INCLUDE ( SectionId , TestSuiteId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IDX_TestCase_Section_InactiveDateTime 
ON [dbo].[TestCase] (  SectionId ASC  , InActiveDateTime ASC  )   
WHERE  ([InActiveDateTime] IS NULL ) 
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_TestCase_InActiveDateTime 
ON [dbo].[TestCase] (  InActiveDateTime ASC  )   
INCLUDE ( AutomationTypeId , CreatedByUserId , CreatedDateTime , Estimate , UpdatedDateTime ,  PriorityId , SectionId , TemplateId , TestCaseId , TestSuiteId , Title , TypeId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX [IX_TestCase_TestSuiteId_InActiveDateTime]
ON [dbo].[TestCase] ([TestSuiteId],[InActiveDateTime])
INCLUDE ([SectionId])
GO