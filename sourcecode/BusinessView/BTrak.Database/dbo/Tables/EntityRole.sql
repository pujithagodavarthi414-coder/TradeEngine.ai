CREATE TABLE [dbo].[EntityRole]
(
    Id UNIQUEIDENTIFIER NOT NULL,
    EntityRoleName NVARCHAR(250) NOT NULL,
    CompanyId UNIQUEIDENTIFIER NOT NULL,
    CreatedDateTime DATETIME NOT NULL,
    CreatedByUserId UNIQUEIDENTIFIER NOT NULL,
    InActiveDateTime DATETIME NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TimeStamp NOT NULL,
CONSTRAINT [PK_EntityRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EntityRole]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_EntityRole_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[EntityRole] CHECK CONSTRAINT [FK_Company_EntityRole_CompanyId]
GO