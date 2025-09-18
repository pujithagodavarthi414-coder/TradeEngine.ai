CREATE TABLE [dbo].[CardType](
[Id] [uniqueidentifier] NOT NULL,
[CardTypeName] [nvarchar](200)  NOT NULL,
[CreatedByUserId] [uniqueidentifier] NOT NULL,
[CreatedDateTime] [datetime] NOT NULL,
[UpdatedByUserId] [uniqueidentifier] NULL,
[UpdatedDateTime] [datetime] NULL,
[InActiveDateTime] [datetime] NULL,
[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_CardType] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
