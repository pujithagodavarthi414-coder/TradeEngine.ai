CREATE TABLE [dbo].[Module](
	[Id] [uniqueidentifier] NOT NULL,
	[ModuleName] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 [IsSystemModule] BIT NULL, 
    [ModuleDescription] NVARCHAR(MAX) NULL, 
    [ModuleLogo] NVARCHAR(250) NULL, 
    [Tags] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO