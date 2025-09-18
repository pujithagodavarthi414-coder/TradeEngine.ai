CREATE TABLE [dbo].[MainUseCase]
(
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
    [MainUseCaseName] [NVARCHAR](1000) NOT NULL,
    [CreatedDateTime] [DATETIME] NOT NULL,
    [VersionNumber]	[INT] NULL DEFAULT 1,
    [InActiveDateTime] [DATETIME] NULL,
    [OriginalId] [UNIQUEIDENTIFIER] NULL,
	[AsAtInActiveDateTime] DATETIME NULL,
    [TimeStamp]	[TIMESTAMP]	
 CONSTRAINT [PK_MainUseCase] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
     
)
GO

ALTER TABLE [dbo].[MainUseCase]  WITH NOCHECK ADD CONSTRAINT [FK_MainUseCase_MainUseCase_OriginalId] FOREIGN KEY ([OriginalId])
REFERENCES [dbo].[MainUseCase] ([Id])
GO

ALTER TABLE [dbo].[MainUseCase] CHECK CONSTRAINT [FK_MainUseCase_MainUseCase_OriginalId]
GO