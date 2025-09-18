CREATE TABLE [dbo].[ModulePage]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [CompanyModuleId] UNIQUEIDENTIFIER NULL, 
    [PageName] NVARCHAR(250) NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [Timestamp] TIMESTAMP NOT NULL
CONSTRAINT [PK_ModulePage] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    [IsDefault] BIT NULL, 
    [IsNameEdit] BIT NULL, 
)
GO

ALTER TABLE [dbo].[ModulePage]  WITH NOCHECK ADD  CONSTRAINT [FK_ModulePage_CompanyModuleId] FOREIGN KEY([CompanyModuleId])
REFERENCES [dbo].[CompanyModule] ([Id])
GO

ALTER TABLE [dbo].[ModulePage] CHECK CONSTRAINT [FK_ModulePage_CompanyModuleId]
GO