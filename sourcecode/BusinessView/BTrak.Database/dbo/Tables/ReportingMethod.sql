CREATE TABLE [dbo].[ReportingMethod]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [ReportingMethodType] NVARCHAR(50) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InactiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    CONSTRAINT [PK_ReportingMethod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
