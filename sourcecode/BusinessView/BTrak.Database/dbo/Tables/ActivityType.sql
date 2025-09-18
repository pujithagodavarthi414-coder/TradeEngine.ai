CREATE TABLE [dbo].[CRMActivityType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ActivityCode] nvarchar(50),
	[ActivityName] nvarchar(150),
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL, 
    CONSTRAINT [PK_CRMActivityType] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
