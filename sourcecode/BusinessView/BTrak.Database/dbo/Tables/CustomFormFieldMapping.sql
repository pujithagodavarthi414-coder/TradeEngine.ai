﻿CREATE TABLE [dbo].[CustomFormFieldMapping]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [FormReferenceId] UNIQUEIDENTIFIER NULL, 
    [FormDataJson] NVARCHAR(MAX) NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [FormId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL
 CONSTRAINT [PK_CustomFormFieldMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY], 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomFormFieldMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomField_FormKey_CustomFormFieldId] FOREIGN KEY(FormId)
REFERENCES [dbo].[CustomField] ([Id])
GO

ALTER TABLE [dbo].[CustomFormFieldMapping] CHECK CONSTRAINT [FK_CustomField_FormKey_CustomFormFieldId]
GO

