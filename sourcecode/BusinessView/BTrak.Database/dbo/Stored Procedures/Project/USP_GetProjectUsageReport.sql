CREATE PROCEDURE [dbo].[USP_GetProjectUsageReport]
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
    
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SELECT U.Id UserId,
	       U.FirstName + ' ' + ISNULL(U.SurName,'') UserName,
		   P.Id ProjectId,
	       P.ProjectName,
		   G.Id GoalId,
		   G.GoalName,
		   G.OnboardProcessDate StartDate,
		   G.EndDate,
		   G.GoalEstimatedTime GoalEstimatedHours,
		   US.Id UserStoryId,
		   US.UserStoryName,
		   ISNULL(US.EstimatedTime,0) UserStoryAllocatedHours,
		   ISNULL(UsedHours.SpentTime,0) UserStoryUsedHours,
		   ISNULL(US.EstimatedTime,0) - ISNULL(UsedHours.SpentTime,0) UserStoryBalanceHours
	INTO #ProjectUsageTable
	FROM UserStory US
	     INNER JOIN Goal G ON G.Id = US.GoalId
		 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
		 INNER JOIN Project P ON P.Id = G.ProjectId
		 LEFT JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		 LEFT JOIN (SELECT UST.UserStoryId, ROUND((SUM(UST.SpentTimeInMin)*1.0)/60.0,1) SpentTime
		            FROM UserStory US 
						 INNER JOIN Goal G ON G.Id = US.GoalId
						 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
		                 INNER JOIN Project P ON P.Id = G.ProjectId
						 INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						 LEFT JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		            WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  AND G.InActiveDateTime IS NULL
						  AND (GS.IsActive = 1 OR G.GoalName = 'Adhoc Goal')
						  AND P.InActiveDateTime IS NULL
						  AND P.CompanyId = @CompanyId
						  AND (CAST(ISNULL(G.OnboardProcessDate,ISNULL(G.EndDate,@DateFrom)) AS DATE) >= @DateFrom AND CAST(ISNULL(G.OnboardProcessDate,ISNULL(G.EndDate,@DateFrom)) AS DATE) <= @DateTo
						       OR CAST(ISNULL(G.EndDate,ISNULL(G.OnboardProcessDate,@DateTo)) AS DATE) <= @DateFrom AND CAST(ISNULL(G.EndDate,ISNULL(G.OnboardProcessDate,@DateTo)) AS DATE) >= @DateTo)
						  AND (@UserIds IS NULL OR US.OwnerUserId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@UserIds)))
						  AND (@GoalIds IS NULL OR US.GoalId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@GoalIds)))
						  AND (@ProjectIds IS NULL OR G.ProjectId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@ProjectIds)))
					GROUP BY UST.UserStoryId) UsedHours ON UsedHours.UserStoryId = US.Id
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
		  AND G.InActiveDateTime IS NULL
		  AND (GS.IsActive = 1 OR G.GoalName = 'Adhoc Goal')
		  AND P.InActiveDateTime IS NULL
		  AND P.CompanyId = @CompanyId
	      AND (CAST(ISNULL(G.OnboardProcessDate,ISNULL(G.EndDate,@DateFrom)) AS DATE) >= @DateFrom AND CAST(ISNULL(G.OnboardProcessDate,ISNULL(G.EndDate,@DateFrom)) AS DATE) <= @DateTo
			   OR CAST(ISNULL(G.EndDate,ISNULL(G.OnboardProcessDate,@DateTo)) AS DATE) <= @DateFrom AND CAST(ISNULL(G.EndDate,ISNULL(G.OnboardProcessDate,@DateTo)) AS DATE) >= @DateTo)
		  AND (@UserIds IS NULL OR US.OwnerUserId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@UserIds)))
		  AND (@GoalIds IS NULL OR US.GoalId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@GoalIds)))
		  AND (@ProjectIds IS NULL OR G.ProjectId IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@ProjectIds)))

	SELECT *,
	       GoalNonAllocatedHours + GoalNonUsedHours GoalPendingHours,
		   ProjectNonAllocatedHours + ProjectNonUsedHours ProjectPendingHours
	FROM (
	SELECT PUT.ProjectId,
	       ProjectName,
		   PUT.GoalId,
		   GoalName,
		   StartDate,
		   EndDate,
		   ISNULL(GoalEstimatedHours,0) GoalEstimatedHours,
		   ISNULL(GoalDetails.GoalAllocatedHours,0) GoalAllocatedHours,
		   ISNULL(GoalDetails.GoalUsedHours,0) GoalUsedHours,
		   ISNULL(GoalEstimatedHours,0) - ISNULL(GoalDetails.GoalAllocatedHours,0) GoalNonAllocatedHours,
		   ISNULL(GoalDetails.GoalAllocatedHours,0) - ISNULL(GoalDetails.GoalUsedHours,0) GoalNonUsedHours,
		   ISNULL(ProjectEstimatedDetails.ProjectEstimatedHours,0) ProjectEstimatedHours,
		   ISNULL(ProjectDetails.ProjectAllocatedHours,0) ProjectAllocatedHours,
		   ISNULL(ProjectDetails.ProjectUsedHours,0) ProjectUsedHours,
		   ISNULL(ProjectEstimatedDetails.ProjectEstimatedHours,0) - ISNULL(ProjectDetails.ProjectAllocatedHours,0) ProjectNonAllocatedHours,
		   ISNULL(ProjectDetails.ProjectAllocatedHours,0) - ISNULL(ProjectDetails.ProjectUsedHours,0) ProjectNonUsedHours,
		   CASE WHEN CEILING((ISNULL((ABS(GoalDetails.GoalAllocatedHours)),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) 
		   + ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0))) = 0 then 0
           ELSE CEILING(((ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)) * 1.0/
		   (ISNULL((ABS(GoalDetails.GoalAllocatedHours)),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) + 
		   ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)))*100) End  AS GoalAllocatedHoursPercentage,

		   CASE WHEN (ISNULL((ABS(GoalDetails.GoalAllocatedHours)),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) + 
		   ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)) = 0 then 0
           ELSE CEILING(((ISNULL(ABS(GoalDetails.GoalUsedHours),0)) * 1.0/(ISNULL((ABS(GoalDetails.GoalAllocatedHours)),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) 
		   + ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)))*100) End  AS GoalUsedHoursPercentage,

		   CASE WHEN (ISNULL((ABS(GoalDetails.GoalAllocatedHours)),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)) = 0 then 0
           ELSE  CEILING(((ISNULL(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0),0)) * 1.0/
		   (ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) 
		   + ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)))*100) End  AS GoalNonAllocatedHoursPercentage,

		   CASE WHEN (ISNULL((ABS(GoalDetails.GoalAllocatedHours)),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) 
		   +  ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)) = 0 then 0
           ELSE  CEILING(((ISNULL(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0),0)) * 1.0/
		   (ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) + ISNULL(ABS(GoalDetails.GoalUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalEstimatedHours),0) - ISNULL(ABS(GoalDetails.GoalAllocatedHours),0)),0) +
		   ISNULL(ABS(ISNULL(ABS(GoalDetails.GoalAllocatedHours),0) - ISNULL(ABS(GoalDetails.GoalUsedHours),0)),0)))*100) End  AS GoalNonUsedHoursPercentage,

		 
		   CASE WHEN (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)) = 0 then 0
           ELSE CEILING(((ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)) *1.0/
		   (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		    ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) +
		    ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)))*100) End  AS ProjectAllocatedHoursPercentage,

		   CASE WHEN CEILING((ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) +
		    ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0))) = 0 then 0
           ELSE  CEILING(((ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)) *1.0/
		   (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) 
		   + ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)))*100) End  AS ProjectUsedHoursPercentage,


		   CASE WHEN (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) +
		    ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)) = 0 then 0
           ELSE  CEILING(((ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0)) *1.0/
		   (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) 
		   + ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)))*100) End  AS ProjectNonAllocatedHoursPercentage,


		   CASE WHEN (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) +
		    ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)) = 0 then 0
           ELSE CEILING(((ISNULL(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0),0)) *1.0/
		   (ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) + ISNULL(ABS(ProjectDetails.ProjectUsedHours),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectEstimatedDetails.ProjectEstimatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0)),0) +
		   ISNULL(ABS(ISNULL(ABS(ProjectDetails.ProjectAllocatedHours),0) - ISNULL(ABS(ProjectDetails.ProjectUsedHours),0)),0)))*100) End  AS ProjectNonUsedHoursPercentage
	FROM #ProjectUsageTable PUT
	     LEFT JOIN (SELECT GoalId, SUM(UserStoryAllocatedHours) GoalAllocatedHours, SUM(UserStoryUsedHours) GoalUsedHours
		            FROM #ProjectUsageTable
					WHERE UserId IS NOT NULL
					GROUP BY GoalId) GoalDetails ON GoalDetails.GoalId = PUT.GoalId
		 LEFT JOIN (SELECT ProjectId, SUM(UserStoryAllocatedHours) ProjectAllocatedHours, SUM(UserStoryUsedHours) ProjectUsedHours
		            FROM #ProjectUsageTable
					WHERE UserId IS NOT NULL
					GROUP BY ProjectId) ProjectDetails ON ProjectDetails.ProjectId = PUT.ProjectId
		LEFT JOIN (SELECT ProjectId, SUM(GoalEstimatedHours) ProjectEstimatedHours
		            FROM (SELECT DISTINCT ProjectId, GoalId, GoalEstimatedHours FROM #ProjectUsageTable) T
					GROUP BY ProjectId) ProjectEstimatedDetails ON ProjectEstimatedDetails.ProjectId = PUT.ProjectId
	GROUP BY PUT.ProjectId,ProjectName,
		     PUT.GoalId,GoalName,
		     StartDate,
		     EndDate,
		     GoalEstimatedHours,
			 GoalDetails.GoalAllocatedHours,
			 GoalDetails.GoalUsedHours,
			 ProjectDetails.ProjectAllocatedHours,
			 ProjectDetails.ProjectUsedHours,
			 ProjectEstimatedDetails.ProjectEstimatedHours
	) T
	ORDER BY ProjectName,
		     GoalName,
		     StartDate,
		     EndDate,
		     GoalEstimatedHours

END
GO