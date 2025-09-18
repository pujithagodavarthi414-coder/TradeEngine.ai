CREATE PROCEDURE [dbo].[USP_GetProjectAndResourceUsageReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@Date DATETIME = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@IsResourceUsage BIT
)
AS
BEGIN

	IF(@Date IS NOT NULL) SELECT @DateFrom = @Date, @DateTo = @Date

	IF(@Date IS NULL AND @DateFrom IS NULL AND @DateTo IS NULL) SELECT @DateFrom = DATEADD(mm, DATEDIFF(mm,0,GETDATE()), 0), @DateTo = CAST(GETDATE() AS DATE)

	IF(@IsResourceUsage = 1)
	BEGIN

		CREATE TABLE #ResourceUsage
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
			ResourceUtilizationPercentage FLOAT,
			CompletionPercentage FLOAT,
			NoOfHours FLOAT,
			ResourceAvailable FLOAT
		)

		INSERT INTO #ResourceUsage
		EXEC [dbo].[USP_ResourceUsageReport] @UserId,@ProjectId,NULL,@DateFrom,@DateTo,NULL,NULL,NULL,NULL,@OperationsPerformedBy

		SELECT UserName [User name],
		       ProjectName [Project name],
			   GoalName [Goal name],
			   UserStoryName [Userstory name],
			   UserStoryAllocatedHours [Userstory allocated hours],
			   UserStoryUsedHours [Userstory Used hours],
			   UserStoryBalanceHours [Userstory Balance hours],
			   GoalAllocatedHours [Goal allocated hours],
			   GoalUsedHours [Goal allocated hours],
			   GoalBalanceHours [Goal balance hours],
			   ProjectAllocatedHours [Project allocated hours],
			   ProjectUsedHours [Project used hours],
			   ProjectBalanceHours [Project balance hours],
			   UserAllocatedHours [User allocated hours],
			   UserUsedHours [User used hours],
			   UserBalanceHours [User balance hours],
			   ResourceUtilizationPercentage [Resource utilization percentage],
			   CompletionPercentage [Completion percentage],
			   ResourceAvailable [Resource available]
		FROM #ResourceUsage

	END
	ELSE IF(@IsResourceUsage = 0)
	BEGIN

	     CREATE TABLE #ProjectUsage
		 (
			ProjectId UNIQUEIDENTIFIER,
			ProjectName NVARCHAR(500),
			GoalId UNIQUEIDENTIFIER,
			GoalName NVARCHAR(500),
			StartDate DATETIME,
			EndDate DATETIME,
			GoalEstimatedHours FLOAT,
			GoalAllocatedHours FLOAT,
			GoalUsedHours FLOAT,
			GoalNonAllocatedHours FLOAT,
			GoalNonUsedHours FLOAT,
			ProjectEstimatedHours FLOAT,
			ProjectAllocatedHours FLOAT,
			ProjectUsedHours FLOAT,
			ProjectNonAllocatedHours FLOAT,
			ProjectNonUsedHours FLOAT,
			GoalAllocatedHoursPercentage FLOAT,
			GoalUsedHoursPercentage FLOAT,
			GoalNonAllocatedHoursPercentage FLOAT,
			GoalNonUsedHoursPercentage FLOAT,
			ProjectAllocatedHoursPercentage FLOAT,
			ProjectUsedHoursPercentage FLOAT,
			ProjectNonAllocatedHoursPercentage FLOAT,
			ProjectNonUsedHoursPercentage FLOAT,
			GoalPendingHours FLOAT,
			ProjectPendingHours FLOAT
		)
	
		INSERT INTO #ProjectUsage
		EXEC [dbo].[USP_GetProjectUsageReport] @UserId,@ProjectId,NULL,@DateFrom,@DateTo,NULL,NULL,NULL,NULL,@OperationsPerformedBy

		SELECT ProjectName [Project name],
		       GoalName [Goal name],
			   CONVERT(varchar, StartDate, 106) [Start date],
			   CONVERT(varchar, EndDate, 106) [End date],
			   GoalEstimatedHours [Goal estimated hours],
			   GoalAllocatedHours [Goal Allocated Hours],
			   GoalUsedHours [Goal used hours],
			   GoalNonAllocatedHours [Goal non allocated hours],
			   GoalNonUsedHours [Goal non used hours],
			   ProjectEstimatedHours [Project estimated hours],
			   ProjectAllocatedHours [Project allocated hours],
			   ProjectUsedHours [Project used hours],
			   ProjectNonAllocatedHours [Project non allocated hours],
			   ProjectNonUsedHours [Project non used hours],
			   GoalPendingHours [Goal pending hours],
			   ProjectPendingHours [Project pending hours]
		FROM #ProjectUsage

	END

END
GO