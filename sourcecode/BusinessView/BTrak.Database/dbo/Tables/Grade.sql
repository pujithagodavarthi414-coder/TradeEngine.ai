CREATE TABLE [dbo].[Grade](
	[Id] [uniqueidentifier] NOT NULL,
	[GradeName] [nvarchar](250)  NULL,
	[GradeOrder] INT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Grade] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO