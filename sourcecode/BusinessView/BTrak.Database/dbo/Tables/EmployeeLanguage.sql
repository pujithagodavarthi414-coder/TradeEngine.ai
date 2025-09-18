CREATE TABLE [dbo].[EmployeeLanguage](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[LanguageId] [uniqueidentifier] NOT NULL,
	[FluencyId] [uniqueidentifier] NULL,
	[CanRead] BIT NULL DEFAULT 0,
	[CanWrite] BIT NULL DEFAULT 0,
	[CanSpeak] BIT NULL DEFAULT 0,
	[CompetencyId] [uniqueidentifier] NOT NULL,
	[Comments] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeLanguage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[EmployeeLanguage]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeLanguage_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLanguage] CHECK CONSTRAINT [FK_Employee_EmployeeLanguage_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeLanguage]  WITH NOCHECK ADD  CONSTRAINT [FK_Competency_EmployeeLanguage_CompetencyId] FOREIGN KEY([CompetencyId])
REFERENCES [dbo].[Competency] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLanguage] CHECK CONSTRAINT [FK_Competency_EmployeeLanguage_CompetencyId]
GO

--ALTER TABLE [dbo].[EmployeeLanguage]  WITH NOCHECK ADD  CONSTRAINT [FK_Fluency_EmployeeLanguage_FluencyId] FOREIGN KEY([FluencyId])
--REFERENCES [dbo].[Fluency] ([Id])
--GO

--ALTER TABLE [dbo].[EmployeeLanguage] CHECK CONSTRAINT [FK_Fluency_EmployeeLanguage_FluencyId]
--GO

ALTER TABLE [dbo].[EmployeeLanguage]  WITH NOCHECK ADD  CONSTRAINT [FK_Language_EmployeeLanguage_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
GO

ALTER TABLE [dbo].[EmployeeLanguage] CHECK CONSTRAINT [FK_Language_EmployeeLanguage_LanguageId]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeLanguage_EmployeeId
ON [dbo].[EmployeeLanguage] (  EmployeeId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO