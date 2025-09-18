CREATE PROCEDURE [dbo].[USP_ResourceUsageReport]
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
    
	DECLARE @NoOfDays INT, @NoOfHours NUMERIC(10,1)

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	;WITH DateRange([Date]) AS
	(
		SELECT @DateFrom [Date]
		UNION ALL
		SELECT DATEADD(DAY,1,[Date]) FROM DateRange
		WHERE [Date] < @DateTo
	)

	SELECT @NoOfDays = COUNT(1) FROM DateRange WHERE DATENAME(WEEKDAY,[Date]) NOT IN ('Saturday','Sunday') OPTION (MAXRECURSION 0)

	SELECT @NoOfHours = @NoOfDays * 8.0

	SELECT DISTINCT(US.Id),
	       IIF(UCreated.id <> u.id, UCreated.Id, u.Id) UserId, 
		   IIF(UCreated.id <> u.id, UCreated.FirstName + ' ' + ISNULL(UCreated.SurName,''), U.FirstName + ' ' + ISNULL(U.SurName,'') ) UserName, 
		   P.Id ProjectId,
	       P.ProjectName,
		   G.Id GoalId,
		   G.GoalName,
		   US.Id UserStoryId,
		   US.UserStoryName,
		   ISNULL(US.EstimatedTime,0) UserStoryAllocatedHours,
		   ISNULL(UsedHours.SpentTime,0) UserStoryUsedHours,
		   ISNULL(US.EstimatedTime,0) - ISNULL(UsedHours.SpentTime,0) UserStoryBalanceHours
	INTO #ResourceUsageTable
	FROM UserStory US
	     LEFT JOIN UserStorySpentTime UST ON US.Id = UST.UserStoryId
	     LEFT JOIN Goal G ON G.Id = US.GoalId
		 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
		 LEFT JOIN Project P ON P.Id = G.ProjectId
		 LEFT JOIN [User] U ON U.Id =  US.OwnerUserId
		 LEFT JOIN [User] UCreated ON UCreated.Id = UST.CreatedByUserId
		 AND (CAST(UST.CreatedDateTime AS DATE) BETWEEN @DateFrom AND @DateTo)
		 LEFT JOIN (SELECT UST.UserStoryId, UST.CreatedByUserId, ROUND((SUM(UST.SpentTimeInMin)*1.0)/60.0,1) SpentTime
		            FROM UserStory US 
						 INNER JOIN Goal G ON G.Id = US.GoalId
						 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
		                 INNER JOIN Project P ON P.Id = G.ProjectId 
						 INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						 INNER JOIN [User] U ON U.Id = UST.CreatedByUserId
		            WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  AND G.InActiveDateTime IS NULL
						  AND (GS.IsActive = 1 OR G.GoalName = 'Adhoc Goal')
						  AND P.InActiveDateTime IS NULL
						  AND U.InActiveDateTime IS NULL
						  AND U.IsActive = 1
						  AND P.CompanyId = @CompanyId
						  AND (CAST(ISNULL(US.StartDate,ISNULL(US.DeadlineDate,@DateFrom)) AS DATE) BETWEEN @DateFrom AND @DateTo
						       OR CAST(ISNULL(US.DeadlineDate,ISNULL(US.StartDate,@DateTo)) AS DATE) BETWEEN @DateFrom AND @DateTo)
						  AND (@UserIds IS NULL OR IIF(UST.CreatedByUserId <> US.OwnerUserId, UST.CreatedByUserId, US.OwnerUserId) IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@UserIds)))
						  AND (@GoalIds IS NULL OR US.GoalId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@GoalIds)))
						  AND (@ProjectIds IS NULL OR G.ProjectId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@ProjectIds)))
						  AND (CAST(UST.DateFrom AS DATE) BETWEEN @DateFrom AND @DateTo
						       OR CAST(UST.DateTo AS DATE) BETWEEN @DateFrom AND @DateTo)
					GROUP BY UST.UserStoryId,UST.CreatedByUserId) UsedHours ON UsedHours.UserStoryId = US.Id AND UsedHours.CreatedByUserId = UST.CreatedByUserId
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
		  AND G.InActiveDateTime IS NULL
		  AND (GS.IsActive = 1 OR G.GoalName = 'Adhoc Goal')
		  AND P.InActiveDateTime IS NULL
		  AND U.InActiveDateTime IS NULL
		  AND U.IsActive = 1
		  AND P.CompanyId = @CompanyId
	      AND (CAST(ISNULL(US.StartDate,ISNULL(US.DeadlineDate,@DateFrom)) AS DATE) BETWEEN @DateFrom AND @DateTo
			   OR CAST(ISNULL(US.DeadlineDate,ISNULL(US.StartDate,@DateTo)) AS DATE) BETWEEN @DateFrom AND @DateTo)
		  AND (@UserIds IS NULL OR IIF(UST.CreatedByUserId <> US.OwnerUserId, UST.CreatedByUserId, US.OwnerUserId) IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@UserIds)))
		  AND (@GoalIds IS NULL OR US.GoalId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@GoalIds)))
		  AND (@ProjectIds IS NULL OR G.ProjectId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@ProjectIds)))

	SELECT RUT.UserId,
	       UserName,
		   RUT.ProjectId,
	       ProjectName,
		   RUT.GoalId,
		   GoalName,
		   UserStoryId,
		   UserStoryName,
		   UserStoryAllocatedHours,
		   UserStoryUsedHours,
		   UserStoryBalanceHours,
		   GoalDetails.GoalAllocatedHours,
		   GoalDetails.GoalUsedHours,
		   GoalDetails.GoalBalanceHours,
		   ProjectDetails.ProjectAllocatedHours,
		   ProjectDetails.ProjectUsedHours,
		   ProjectDetails.ProjectBalanceHours,
		   UserDetails.UserAllocatedHours,
		   UserDetails.UserUsedHours,
		   UserDetails.UserBalanceHours,
		   IIF(@NoOfHours = 0, 0, CAST(ROUND((UserDetails.UserAllocatedHours/@NoOfHours) * 100,0) AS NUMERIC(10,1))) ResourceUtilizationPercentage,
           --IIF(UserDetails.UserAllocatedHours = 0, 0, CAST(ROUND(((UserDetails.UserLoggedApprovedHours + UserDetails.UserEstimatedApprovedHours)/UserDetails.UserAllocatedHours) * 100,0) AS NUMERIC(10,1))) CompletionPercentage,
		   ISNULL(@NoOfHours,0) NoOfHours,
		   IIF(@NoOfHours = 0, 0, ISNULL(@NoOfHours,0) - UserUsedHours)  ResourceAvailable
	FROM #ResourceUsageTable RUT
	     LEFT JOIN (SELECT GoalId, SUM(UserStoryAllocatedHours) GoalAllocatedHours, SUM(UserStoryUsedHours) GoalUsedHours, SUM(UserStoryBalanceHours) GoalBalanceHours
		            FROM #ResourceUsageTable
					GROUP BY GoalId) GoalDetails ON GoalDetails.GoalId = RUT.GoalId
		 LEFT JOIN (SELECT ProjectId, SUM(UserStoryAllocatedHours) ProjectAllocatedHours, SUM(UserStoryUsedHours) ProjectUsedHours, SUM(UserStoryBalanceHours) ProjectBalanceHours
		            FROM #ResourceUsageTable
					GROUP BY ProjectId) ProjectDetails ON ProjectDetails.ProjectId = RUT.ProjectId
		 LEFT JOIN (SELECT UserId, SUM(UserStoryAllocatedHours) UserAllocatedHours, SUM(UserStoryUsedHours) UserUsedHours, SUM(UserStoryBalanceHours) UserBalanceHours
		 --,SUM(LoggedApprovedHours) UserLoggedApprovedHours,SUM(EstimatedApprovedHours) UserEstimatedApprovedHours
		            FROM #ResourceUsageTable
					GROUP BY UserId) UserDetails ON UserDetails.UserId = RUT.UserId
	ORDER BY UserName,
	         ProjectName,
		     GoalName,
		     UserStoryName

END
GO