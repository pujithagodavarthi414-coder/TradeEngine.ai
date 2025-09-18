CREATE TABLE [dbo].[EventType](
	[Id] [uniqueidentifier] NOT NULL,
	[EventTypeName] [nvarchar](255) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO
