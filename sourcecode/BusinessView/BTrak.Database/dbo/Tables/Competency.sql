CREATE TABLE [dbo].[Competency](
	[Id] [uniqueidentifier] NOT NULL,
	[CompetencyName] [nvarchar](250) NOT  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    CONSTRAINT [PK_[Competency] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO