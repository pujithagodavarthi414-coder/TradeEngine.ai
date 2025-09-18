CREATE TABLE [dbo].[EmployeeFields](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[FieldName] [nvarchar](250) NULL,
	Hide BIT NULL,
	Edit BIT NULL,
	Mandatory BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeFields] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO