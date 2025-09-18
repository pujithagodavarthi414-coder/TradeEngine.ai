CREATE TABLE [dbo].[ExamCategory](
	[Id] [uniqueidentifier] NOT NULL,
	CompanyId [uniqueidentifier]  NULL,
	[CategoryName] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_ExamCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_ExamCategory_CategoryName_CompanyId] UNIQUE ([CategoryName], [CompanyId])
)