CREATE TABLE [dbo].[NumberFormat]
(
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
    [DisplayText] [NVARCHAR](100) NULL,
    [CreatedDateTime] [DATETIME] NOT NULL,
    [InActiveDateTime] [DATETIME] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp]	[TIMESTAMP]	
 CONSTRAINT [PK_NumberFormat] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO