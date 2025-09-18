CREATE TABLE [dbo].[LeaveComment](
	[Id] [uniqueidentifier] NOT NULL,
	[LeaveApplicationId] [uniqueidentifier] NOT NULL,
	[ParentLeaveCommentId] [uniqueidentifier] NULL,
	[Comment] [nvarchar](800) NULL,
	[CommentedDateTime] [datetime] NOT NULL,
	[CommentedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_LeaveComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[LeaveComment]  WITH CHECK ADD  CONSTRAINT [FK_LeaveComment_LeaveComment_ParentLeaveCommentId] FOREIGN KEY([ParentLeaveCommentId])
REFERENCES [dbo].[LeaveComment] ([Id])
GO

ALTER TABLE [dbo].[LeaveComment] CHECK CONSTRAINT [FK_LeaveComment_LeaveComment_ParentLeaveCommentId]
GO