CREATE PROCEDURE [dbo].[USP_GetCapacityPlanningBasedOnResourceUsage]
(
	@UserIds NVARCHAR(MAX) = NULL,
	@ProjectIds NVARCHAR(MAX) = NULL,
	@GoalIds NVARCHAR(MAX) = NULL,
	@DateFrom DATE,
	@DateTo DATE = NULL,
	@SortBy NVARCHAR(250) = NULL,
	@SortDirection NVARCHAR(50) = NULL,
	@PageNo INT = 1,
	@PageSize INT = 10,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	CREATE TABLE #CapacityPlanning
	(
		UserId UNIQUEIDENTIFIER,
	    UserName NVARCHAR(500),
		ProjectId UNIQUEIDENTIFIER,
	    ProjectName NVARCHAR(500),
		GoalId UNIQUEIDENTIFIER,
		GoalName NVARCHAR(500),
		UserStoryId UNIQUEIDENTIFIER,
		UserStoryName NVARCHAR(MAX),
		UserStoryAllocatedHours FLOAT,
		UserStoryUsedHours FLOAT,
		UserStoryBalanceHours FLOAT,
		GoalAllocatedHours FLOAT,
		GoalUsedHours FLOAT,
		GoalBalanceHours FLOAT,
		ProjectAllocatedHours FLOAT,
		ProjectUsedHours FLOAT,
		ProjectBalanceHours FLOAT,
		UserAllocatedHours FLOAT,
		UserUsedHours FLOAT,
		UserBalanceHours FLOAT,
		UtilizationPercentage FLOAT,
		NoOfHours FLOAT,
		ResourceAvailable FLOAT
	)

	INSERT INTO #CapacityPlanning
	EXEC [dbo].[USP_ResourceUsageReport] @UserIds,@ProjectIds,@GoalIds,@DateFrom,@DateTo,@SortBy,@SortDirection,@PageNo,@PageSize,@OperationsPerformedBy

	SELECT UserId,
	       UserName,
		   ProjectId,
		   ProjectName,
		   GoalId,
		   GoalName,
		   GoalAllocatedHours,
		   GoalUsedHours,
		   GoalBalanceHours,
		   ProjectAllocatedHours,
		   ProjectUsedHours,
		   ProjectBalanceHours,
		   ProjectBalanceHours,
		   UserAllocatedHours,
		   UserUsedHours,
		   UserBalanceHours,
		   --NoOfHours - UserUsedHours ResourceAvailable,
		   ResourceAvailable
	FROM #CapacityPlanning
	GROUP BY UserId,
			 UserName,
			 ProjectId,
			 ProjectName,
			 GoalId,
			 GoalName,
			 GoalAllocatedHours,
			 GoalUsedHours,
			 GoalBalanceHours,
			 ProjectAllocatedHours,
			 ProjectUsedHours,
			 ProjectBalanceHours,
			 ProjectBalanceHours,
			 UserAllocatedHours,
			 UserUsedHours,
			 UserBalanceHours,
			 NoOfHours,
			 ResourceAvailable
	ORDER BY UserName,
	         ProjectName,
			 GoalName

END
GO
