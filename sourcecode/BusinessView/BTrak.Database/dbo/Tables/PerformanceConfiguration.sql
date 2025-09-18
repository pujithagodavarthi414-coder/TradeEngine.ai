CREATE TABLE [dbo].[PerformanceConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(250) NOT NULL, 
	[SelectedRoles] NVARCHAR(MAX) NULL,
	[IsDraft] BIT NOT NULL,
    [FormJson] NVARCHAR(MAX) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDatetime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDatetime] DATETIME NULL,
	[InActiveDatetime] DATETIME NULL, 
	[TimeStamp] TimeStamp NOT NULL,
    CONSTRAINT [PK_PerformanceConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PerformanceConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceConfiguration_User1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceConfiguration] CHECK CONSTRAINT [FK_PerformanceConfiguration_User1]
GO

ALTER TABLE [dbo].[PerformanceConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceConfiguration_User2] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PerformanceConfiguration] CHECK CONSTRAINT [FK_PerformanceConfiguration_User2]
GO