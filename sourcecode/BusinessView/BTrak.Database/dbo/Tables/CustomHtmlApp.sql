CREATE TABLE [dbo].[CustomHtmlApp]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [CustomHtmlAppName] NVARCHAR(250) NOT NULL, 
    [Description] NVARCHAR(4000) NULL,
	[Version] NVARCHAR(50) NULL,
    [HtmlCode] NVARCHAR(MAX) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NULL, 
    [FileUrls] NVARCHAR(MAX) NULL,
    SubQueryType NVARCHAR(MAX),
    SubQuery NVARCHAR(MAX)
)
GO

ALTER TABLE [dbo].[CustomHtmlApp] 
ADD CONSTRAINT UK_CustomHtmlApp_CustomHtmlAppName_CompanyId UNIQUE ([CustomHtmlAppName], [CompanyId])
GO