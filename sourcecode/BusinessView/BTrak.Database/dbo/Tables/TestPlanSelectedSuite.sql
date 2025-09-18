CREATE TABLE [dbo].[TestPlanSelectedSuite](
	[Id] [uniqueidentifier] NOT NULL,
	[TestPlanId] [uniqueidentifier] NOT NULL,
	[TestSuiteId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_TestPlanSelectedSuite] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestPlanSelectedSuite]  WITH CHECK ADD  CONSTRAINT [FK_TestPlanSelectedSuite_TestPlan] FOREIGN KEY([TestPlanId])
REFERENCES [dbo].[TestPlan] ([Id])
GO

ALTER TABLE [dbo].[TestPlanSelectedSuite] CHECK CONSTRAINT [FK_TestPlanSelectedSuite_TestPlan]
GO

ALTER TABLE [dbo].[TestPlanSelectedSuite]  WITH CHECK ADD  CONSTRAINT [FK_TestPlanSelectedSuite_TestSuite] FOREIGN KEY([TestSuiteId])
REFERENCES [dbo].[TestSuite] ([Id])
GO

ALTER TABLE [dbo].[TestPlanSelectedSuite] CHECK CONSTRAINT [FK_TestPlanSelectedSuite_TestSuite]
GO