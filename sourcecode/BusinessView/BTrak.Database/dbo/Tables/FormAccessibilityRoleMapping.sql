CREATE TABLE [dbo].[FormAccessibilityRoleMapping]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [FormId] UNIQUEIDENTIFIER NOT NULL, 
    [RoleId] UNIQUEIDENTIFIER NULL, 
    [MapType] NVARCHAR(50) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UptedByUserId] [uniqueidentifier] NULL

CONSTRAINT [PK_FormAccessibilityRoleMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY], 
    [InActiveDatetime] DATETIME NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[FormAccessibilityRoleMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_GenericForm_FormAccessibilityRoleMapping_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[GenericForm] ([Id])
GO

ALTER TABLE [dbo].[FormAccessabilityRoleMapping] CHECK CONSTRAINT [FK_GenericForm_FormAccessibilityRoleMapping_FormId]
GO

ALTER TABLE [dbo].[FormAccessibilityRoleMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_Role_FormAccessabilityRoleMapping_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[FormAccessabilityRoleMapping] CHECK CONSTRAINT [FK_Role_FormAccessabilityRoleMapping_RoleId]
GO
