CREATE TABLE [dbo].[AuditReport](
	[Id] [uniqueidentifier] NOT NULL,	
	[AuditReportName] [nvarchar](250) NOT NULL,
	[AuditReportDescription] [nvarchar](800) NULL,			
	[AuditConductId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP NOT NULL,	
	[CompanyId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_AuditReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AuditReport]  WITH CHECK ADD  CONSTRAINT [FK_AuditReport_AuditConduct] FOREIGN KEY([AuditConductId])
REFERENCES [dbo].[AuditConduct] ([Id])
GO

ALTER TABLE [dbo].[AuditReport] CHECK CONSTRAINT [FK_AuditReport_AuditConduct]
GO

