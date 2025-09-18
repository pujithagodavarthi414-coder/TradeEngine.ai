CREATE TABLE [dbo].[UserStoryReplanType](
	[Id] [uniqueidentifier] NOT NULL,
	[ReplanTypeName] [nvarchar](800) NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
    [IsEstimatedTimeChange] BIT NULL, 
    [IsDeadLineChange] BIT NULL, 
	[IsStartDateChange] BIT NULL, 
    [IsUserStoryChange] BIT NULL, 
    [IsDependencyChange] BIT NULL, 
    [IsOwnerChange] NCHAR(10) NULL, 
	[TimeStamp] TIMESTAMP,
    [IsEstimatedTimeInSpChange] BIT NULL, 
    CONSTRAINT [PK_UserStoryReplanType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO