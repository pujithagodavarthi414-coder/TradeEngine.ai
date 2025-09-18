CREATE TABLE [dbo].[RestrictionType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [Restriction] NVARCHAR(50) NULL, 
    [LeavesCount] FLOAT NULL,
	[IsWeekly] BIT NULL, 
    [IsMonthly] BIT NULL, 
    [IsQuarterly] BIT NULL, 
    [IsHalfYearly] BIT NULL, 
    [IsYearly] BIT NULL, 
	[CompanyId] UNIQUEIDENTIFIER NULL,
    [TimeStamp] TIMESTAMP,
	[InActiveDateTime] DATETIME NULL, 					 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
	[UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    CONSTRAINT [PK_RestrictionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO