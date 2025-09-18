CREATE TABLE [dbo].[BoardTypeUi](
    [Id] [uniqueidentifier] NOT NULL,
    [BoardTypeUiName] [nvarchar](250) NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime] DATETIMEOFFSET NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
    [BoardTypeUiView] [nvarchar](800) NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_BoardTypeUi] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]
GO