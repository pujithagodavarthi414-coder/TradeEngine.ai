CREATE TABLE [dbo].[UserStorySubType](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[UserStorySubTypeName] [nvarchar](250) NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStorySubType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserStorySubType]  WITH CHECK ADD  CONSTRAINT [FK_Company_UserStorySubType_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[UserStorySubType] CHECK CONSTRAINT [FK_Company_UserStorySubType_CompanyId]
GO