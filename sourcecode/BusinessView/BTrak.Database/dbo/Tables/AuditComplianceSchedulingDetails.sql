CREATE TABLE [dbo].[AuditComplianceSchedulingDetails]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AuditComplianceId] [uniqueidentifier] NOT NULL,
	[CronExpressionId] [uniqueidentifier] NOT NULL,
	[ConductStartDate] DATETIME NULL, 
	[ConductEndDate] DATETIME NULL, 
	[SpanInYears] INT NULL, 
    [SpanInMonths] INT NULL, 
    [SpanInDays] INT NULL, 
    [IsPaused] BIT NULL, 
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [ResponsibleUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_AuditComplianceSchedulingDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AuditComplianceSchedulingDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_AuditConduct_AuditComplianceSchedulingDetails] FOREIGN KEY([AuditComplianceId])
REFERENCES [dbo].[AuditCompliance] ([Id])
GO