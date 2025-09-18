CREATE TABLE [dbo].[CallOutcome]
(
	[OutcomeCode] NVARCHAR(50) NOT NULL, 
    [OutcomeName] NVARCHAR(MAX) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	CONSTRAINT [PK_CallOutcome] PRIMARY KEY CLUSTERED 
	(
		[OutcomeCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
