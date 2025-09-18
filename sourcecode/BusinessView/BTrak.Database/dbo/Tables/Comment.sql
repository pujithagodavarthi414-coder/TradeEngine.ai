CREATE TABLE [dbo].[Comment](
	[Id] [uniqueidentifier] NOT NULL,
	[CommentedByUserId] [uniqueidentifier] NOT NULL,
	[ReceiverId] [uniqueidentifier] NULL,
	[Comment] [nvarchar](MAX) NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[ParentCommentId] [uniqueidentifier] NULL,
	[Adminflag] [bit] NULL,
	[CompanyId] [uniqueidentifier] NULL,
    [CommentFeatureId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP,
    [CreatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE NONCLUSTERED INDEX [IX_Comment_ReceiverId]
ON [dbo].[Comment] ([ReceiverId])
GO