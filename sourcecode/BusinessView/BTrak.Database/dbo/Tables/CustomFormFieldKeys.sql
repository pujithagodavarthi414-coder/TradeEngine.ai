CREATE TABLE [dbo].[CustomFormFieldKeys]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [CustomFieldId] UNIQUEIDENTIFIER NOT NULL, 
    [Key] NVARCHAR(250) NULL, 
    [Label] NVARCHAR(500) NULL, 
    [IsDefault] BIT NOT NULL DEFAULT 0, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NOT NULL 
CONSTRAINT [PK_CustomFormFieldKeys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY], 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomFormFieldKeys]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomField_GenericFormKey_CustomFormFieldId] FOREIGN KEY(CustomFieldId)
REFERENCES [dbo].[CustomField] ([Id])
GO

ALTER TABLE [dbo].[CustomFormFieldKeys] CHECK CONSTRAINT [FK_CustomField_GenericFormKey_CustomFormFieldId]
GO
