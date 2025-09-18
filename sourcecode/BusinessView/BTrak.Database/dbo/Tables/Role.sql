CREATE TABLE [dbo].[Role](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleAuthenticationId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[RoleName] [nvarchar](800) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [IsDeveloper] BIT NULL, 
    [IsAdministrator] BIT NULL, 
	[TimeStamp] TIMESTAMP,
    [InactiveDateTime] DATETIME NULL, 
	[IsHidden] BIT NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

CREATE NONCLUSTERED INDEX [IX_Role_CompanyId]
ON [dbo].[Role] ([CompanyId])
GO
