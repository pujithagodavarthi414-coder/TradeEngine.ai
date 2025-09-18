CREATE TABLE [dbo].[ProbationConfiguration]
(
    [Id] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(250) NOT NULL, 
	[SelectedRoles] NVARCHAR(MAX) NULL,
	[IsDraft] BIT NOT NULL,
    [FormJson] NVARCHAR(MAX) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDatetime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDatetime] DATETIME NULL,
	[InActiveDatetime] DATETIME NULL, 
	[TimeStamp] TimeStamp NOT NULL,
)
