CREATE TABLE [dbo].[PermissionConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[Permission] [nvarchar](100) NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_PermissionConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [AK_PermissionConfiguration_Permission] UNIQUE ([Permission])
) ON [PRIMARY]