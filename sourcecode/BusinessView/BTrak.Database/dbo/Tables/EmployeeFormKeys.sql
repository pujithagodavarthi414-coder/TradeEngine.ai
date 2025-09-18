CREATE TABLE [dbo].[EmployeeFormKeys]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	CustomFieldsId UNIQUEIDENTIFIER NOT NULL,
	[Key] NVARCHAR(250),
	[Label] NVARCHAR(500) NULL,
	IsDefault BIT NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	InActiveDateTime DATETIME NULL,
	[TimeStamp] TimeStamp NOT NULL
CONSTRAINT [PK_EmployeeFormKeys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
