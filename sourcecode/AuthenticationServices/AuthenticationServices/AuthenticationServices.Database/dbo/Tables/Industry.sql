CREATE TABLE [dbo].[Industry]
(
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
    [IndustryName] [NVARCHAR](1000) NOT NULL,
    [CreatedDateTime] [DATETIME] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [DATETIME] NULL,
    [TimeStamp]	[TIMESTAMP],
 CONSTRAINT [PK_Industry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO