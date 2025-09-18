CREATE TABLE [dbo].[CompanySettings](
	[Id] [uniqueidentifier] NOT NULL,
	[Key] [nvarchar](500) NOT NULL,
	[Value] [nvarchar](MAX) NOT NULL,
	[Description] [nvarchar](MAX) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
    [InactiveDateTime] DATETIME NULL, 
	[IsVisible] BIT DEFAULT 1 NULL, 
    CONSTRAINT [PK_CompanySettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],

) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CompanySettings]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_CompanySettings_CompanyId] FOREIGN KEY(CompanyId)
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[CompanySettings] CHECK CONSTRAINT [FK_Company_CompanySettings_CompanyId]
GO

CREATE INDEX IX_CompanySettings_CompanyId ON [dbo].[CompanySettings]([CompanyId])
INCLUDE([Id],[Key],[Value],[Description],[InActiveDateTime],[CreatedDateTime],[CreatedByUserId],[TimeStamp])
GO