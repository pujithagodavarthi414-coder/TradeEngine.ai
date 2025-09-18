CREATE TABLE [dbo].[CompanyModule](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[ModuleId] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
    [IsArchived] [bit] NULL,
	[IsEnabled] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CompanyModule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CompanyModule]  WITH NOCHECK ADD  CONSTRAINT [FK_Module_CompanyModule_ModuleId] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[Module] ([Id])
GO

ALTER TABLE [dbo].[CompanyModule] CHECK CONSTRAINT [FK_Module_CompanyModule_ModuleId]
GO

CREATE INDEX [IX_CompanyModule_CompanyId_ModuleId_InActiveDateTime] 
ON [dbo].[CompanyModule] ([CompanyId], [ModuleId], [InActiveDateTime])
GO

CREATE INDEX [IX_CompanyModule_CompanyId_ModuleId] 
ON [dbo].[CompanyModule] ([CompanyId], [ModuleId])
GO