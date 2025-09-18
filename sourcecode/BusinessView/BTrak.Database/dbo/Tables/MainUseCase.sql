CREATE TABLE [dbo].[MainUseCase]
(
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
    [MainUseCaseName] [NVARCHAR](1000) NOT NULL,
    [CreatedDateTime] [DATETIME] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [DATETIME] NULL,
    [TimeStamp]	[TIMESTAMP]	
 CONSTRAINT [PK_MainUseCase] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
     
)
GO