CREATE TABLE [dbo].[PayGrade]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [PayGradeName] [nvarchar](800) NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
)
GO