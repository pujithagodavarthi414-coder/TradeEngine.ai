CREATE TABLE [dbo].[CustomAppSubQueryType](
	[Id] [uniqueidentifier] NOT NULL,
	[SubQueryType] [nvarchar](50) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier]  NULL,
	[UpdatedDateTime] [datetime]  NULL,
	[InActiveDateTime] [datetimeoffset](7) NULL,
	[TimeStamp] [timestamp]  NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
