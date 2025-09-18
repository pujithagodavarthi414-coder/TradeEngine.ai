CREATE TABLE [dbo].[ApprovalCustomApplicationForms](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomApplicationId] [uniqueidentifier] NOT NULL,
	[ApproverId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ApprovalCustomApplicationForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ApprovalCustomApplicationForms]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalCustomApplicationForms_CustomApplicationForms] FOREIGN KEY([CustomApplicationId])
REFERENCES [dbo].[CustomApplication] ([Id])
GO

ALTER TABLE [dbo].[ApprovalCustomApplicationForms] CHECK CONSTRAINT [FK_ApprovalCustomApplicationForms_CustomApplicationForms]
GO