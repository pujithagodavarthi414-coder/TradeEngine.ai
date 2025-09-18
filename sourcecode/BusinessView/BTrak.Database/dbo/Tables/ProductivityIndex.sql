CREATE TABLE [dbo].[ProductivityIndex]
(
	UserId UNIQUEIDENTIFIER,
	[CompanyId] UNIQUEIDENTIFIER,
	ProjectId UNIQUEIDENTIFIER,
	UserStoryId UNIQUEIDENTIFIER,
	UserProjectKey NVARCHAR(100),
	ProductivityIndex FLOAT,
	AvgActivityTrackerProductivity FLOAT,
	AvgSpentTime FLOAT,
	GRPIndex FLOAT,
	ReopenedUserStoresCount INT,
	PercentageOfBouncedUserStories FLOAT,
	UserStoriesBouncedBackOnceCount INT,
	UserStoriesBouncedBackMoreThanOnceCount INT,
	AvgReplan FLOAT,
	PercentageOfQAApprovedUserStories FLOAT,
	CompletedUserStoriesCount INT,
	[Date] DATE,
	CreatedDateTime DATE
)
