
CREATE TABLE [dbo].[CustomWidgets](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomWidgetName] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](4000) NULL,
	[WidgetQuery] [nvarchar](max) NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[IsEditable]  [bit] NULL,
	[ProcName] NVARCHAR(250) NULL,
    [IsProc] BIT NULL, 
	[ApiUrl] NVARCHAR(MAX) NULL,
    [IsApi] BIT NULL,
    SubQueryType NVARCHAR(MAX),
    SubQuery NVARCHAR(MAX),
	Filters NVARCHAR(MAX) NULL,
    [IsQuery] BIT NULL,
	ColumnFontFamily NVARCHAR(250) NULL,
	ColumnBackgroundColor NVARCHAR(250) NULL,
	ColumnFontColor NVARCHAR(250) NULL,
	HeaderFontColor NVARCHAR(250) NULL,
	HeaderBackgroundColor NVARCHAR(250) NULL,
	RowBackgroundColor NVARCHAR(250) NULL,
    [IsMongoQuery] BIT NULL, 
    [CollectionName] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_CustomWidgets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomWidgets]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomWidgets_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgets] CHECK CONSTRAINT [FK_CustomWidgets_User]
GO

ALTER TABLE [dbo].[CustomWidgets]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomWidgets_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgets] CHECK CONSTRAINT [FK_CustomWidgets_User1]
GO

ALTER TABLE [dbo].[CustomWidgets] 
ADD CONSTRAINT UK_CustomWidgets_CustomWidgetName_CompanyId UNIQUE ([CustomWidgetName], [CompanyId])
GO