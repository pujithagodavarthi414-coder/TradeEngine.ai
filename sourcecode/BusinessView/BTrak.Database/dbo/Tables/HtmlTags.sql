CREATE TABLE [dbo].[HtmlTags]
(
	[Id] [uniqueidentifier] NOT NULL,
	[HtmlTagName] [nvarchar](250) NOT NULL,
	[HtmlTemplateId] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
)
