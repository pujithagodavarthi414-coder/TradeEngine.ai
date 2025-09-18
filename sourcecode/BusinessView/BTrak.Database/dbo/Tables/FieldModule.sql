CREATE TABLE [dbo].[FieldModule]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[ModuleId] [uniqueidentifier] NOT NULL,
	[Label] [nvarchar](150) NOT NULL,
	[ApiName] [nvarchar](150) NOT NULL,
	[FieldData] [int] NOT NULL,
	[IsCustom] [bit] NOT NULL,
	[Maximum] [int] NULL,
	[DecimalP] [int] NULL,
	[Rounding] [int] NOT NULL,
	[IsUnique] [bit] NULL,
	[IsEncrypt] [bit] NULL,
	[FormulaE] [nvarchar](150) NULL,
	[FormulaR] [nvarchar](150) NULL,
	[FormulaD] [nvarchar](150) NULL,
	[Prefix] [nvarchar](50) NULL,
	[Suffix] [nvarchar](50) NULL,
	[StartingN] [nvarchar](150) NULL,
	[ParentM] [nvarchar](150) NULL,
	[HeaderLabel] [nvarchar](150) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL, 
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
CONSTRAINT [PK_FieldModule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
Go
