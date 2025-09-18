CREATE TABLE [dbo].[InterviewLevel](
	[Id] [uniqueidentifier] NOT NULL,
	[InterviewLevelName] [nvarchar](250) NOT NULL,
	[Order] [int] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_InterviewLevel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InterviewLevel]  WITH CHECK ADD  CONSTRAINT [FK_Company_InterviewLevel_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[InterviewLevel] CHECK CONSTRAINT [FK_Company_InterviewLevel_CompanyId]
GO
