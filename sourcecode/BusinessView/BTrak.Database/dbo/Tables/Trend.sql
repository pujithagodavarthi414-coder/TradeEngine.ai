CREATE TABLE [dbo].[Trend]
(
	[Id] UNIQUEIDENTIFIER NOT NULL
	,GenericFormSubmittedId UNIQUEIDENTIFIER NOT NULL
	,GenericFormKeyId UNIQUEIDENTIFIER NOT NULL
	,TrendValue NVARCHAR(800)
	,[CreatedDateTime] [datetime] NOT NULL
	,[CreatedByUserId] [uniqueidentifier] NOT NULL
	,InActiveDateTime DATETIME NULL
	,[UpdatedDateTime] [datetime] NULL
    ,[UpdatedByUserId] [uniqueidentifier] NULL
	,[TimeStamp] TimeStamp NOT NULL,
CONSTRAINT [PK_Trend] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

