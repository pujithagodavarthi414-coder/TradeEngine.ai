-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-10-21 00:00:00.000'
-- Purpose      To Get the User Stories Along With Adhoc Work By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_ReportsForAdhocWork] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@PageSize = 100,@DependencyText = 'CurrentUserStories'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ReportsForAdhocWork]
(
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)= NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
    @SearchText NVARCHAR(100) = NULL,
	@DependencyText NVARCHAR(250),
	@EntityId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@OwnerUserId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	BEGIN TRY
	 DECLARE @HavePermission NVARCHAR(500)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		IF(@OwnerUserId = '00000000-0000-0000-0000-000000000000') SET @OwnerUserId = NULL
	
	   IF(@SearchText = '') SET @SearchText = NULL

	   IF(@SortDirection IS NULL)SET @SortDirection = 'ASC'
	
	    SET @SearchText = '%' + @SearchText + '%'

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @AdhocGoalId UNIQUEIDENTIFIER = (SELECT G.Id 
		                                         FROM Goal G
				                                    INNER JOIN Project P On P.Id = G.ProjectId 
						                                       AND P.ProjectName = 'Adhoc Project' AND P.CompanyId = @CompanyId
		                                          WHERE GoalName = 'Adhoc Goal')
		
		IF (@SortBy IS NULL OR @SortBy = '') 
		      SET @SortBy = 'UserStoryName'

        IF (@DependencyText = 'DependencyOnMe') 
		BEGIN
			
			SELECT UserStoryName
			       ,ProjectName
				   ,GoalName
				   ,SprintName
				   ,DependencyName 
				   ,OwnerName
				   ,EstimatedTime
				   ,DeadLineDate
				   ,OwnerUserId
				   ,ProfileImage
				   
				   ,TotalCount = COUNT(1) OVER()
		    FROM [dbo].[Ufn_GetUserStoriesAlongWithAdhocWork](@CompanyId,@OperationsPerformedBy,@EntityId,@AdhocGoalId,@ProjectId)
			WHERE (DependencyUserId = @OperationsPerformedBy) 
			      AND (@SearchText IS NULL 
				       OR (UserStoryName LIKE @SearchText)
                       OR (ProjectName LIKE @SearchText)
                       OR (OwnerName LIKE @SearchText)
                       OR (GoalName LIKE @SearchText)
					   OR (SprintName LIKE @SearchText)
                       OR (DependencyName LIKE @SearchText))
			ORDER BY CASE WHEN @SortDirection = 'ASC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL  THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName
							   WHEN @SortBy = 'SprintName' THEN SprintName
			                   WHEN @SortBy = 'DependencyName' THEN DependencyName 
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC'
			         THEN CASE WHEN @SortBy = 'UserStoryName'  OR @SortBy IS NULL  THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName
							   WHEN @SortBy = 'SprintName' THEN SprintName
			                   WHEN @SortBy = 'DependencyName' THEN DependencyName 
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END DESC
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
         FETCH NEXT @pageSize ROWS ONLY

		END
		ELSE IF (@DependencyText = 'DependencyOnOthers') 
		BEGIN
			
			SELECT UserStoryName
			       ,ProjectName
				   ,GoalName
				   ,SprintName
				   ,DependencyName 
				   ,OwnerName
				   ,EstimatedTime
				   ,DeadLineDate
				   ,OwnerUserId
				   ,DependencyUserId
				   ,TotalCount = COUNT(1) OVER()
		    FROM [dbo].[Ufn_GetUserStoriesAlongWithAdhocWork](@CompanyId,@OperationsPerformedBy,null,@AdhocGoalId,@ProjectId)AW INNER JOIN [dbo].[User] OU ON OU.Id = AW.DependencyUserId
			        INNER JOIN [Employee] E ON E.UserId = OU.Id  
                    INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
			WHERE (DependencyUserId <> @OperationsPerformedBy AND DependencyUserId IS NOT NULL)
			      AND OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)) 
				 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			      AND (@SearchText IS NULL 
				       OR (UserStoryName LIKE @SearchText)
                       OR (ProjectName LIKE @SearchText)
                       OR (OwnerName LIKE @SearchText)
                       OR (GoalName LIKE @SearchText)
                       OR (DependencyName LIKE @SearchText))
			ORDER BY CASE WHEN @SortDirection = 'ASC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName 
			                   WHEN @SortBy = 'SprintName' THEN SprintName
			                   WHEN @SortBy = 'DependencyName' THEN DependencyName
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL  THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName 
			                   WHEN @SortBy = 'SprintName' THEN SprintName
			                   WHEN @SortBy = 'DependencyName' THEN DependencyName
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END DESC
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
         FETCH NEXT @pageSize ROWS ONLY

		END
		ELSE IF (@DependencyText = 'ImminentDeadLine') 
		BEGIN
			
			DECLARE @DateTo DATETIME = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))
       
			DECLARE @DateFrom DATETIME = DATEADD(dd, -(DATEPART(dw, @DateTo)-1), CAST(@DateTo AS DATE))
       
			SELECT * FROM (
			SELECT UserStoryName
			       ,ProjectName
				   ,GoalName
				   ,DependencyName 
				   ,OwnerName
				   ,EstimatedTime
				   ,CASE WHEN GoalId IS NOT NULL AND SprintId IS NOT NULL THEN DeadLineDate
				         WHEN SprintId IS NULL THEN DeadLineDate
						 WHEN GoalId IS NULL THEN SprintEndDate
					END AS DeadLineDate
				   ,CASE WHEN GoalId IS NOT NULL AND SprintId IS NOT NULL THEN TimeZoneAbbreviation
				         WHEN SprintId IS NULL THEN TimeZoneAbbreviation
						 WHEN GoalId IS NULL THEN SprintTimeZoneAbbreviation 
					END AS TimeZoneAbbreviation
				   ,CASE WHEN GoalId IS NOT NULL AND SprintId IS NOT NULL THEN TimeZoneName
				         WHEN SprintId IS NULL THEN TimeZoneName
						 WHEN GoalId IS NULL THEN SprintTimeZoneName 
					END AS TimeZoneName
				   ,GoalId
				   ,SprintName
				   ,SprintStartDate
				   ,SprintEndDate
				   ,SprintId
				   ,OwnerUserId
				   ,ProfileImage
				   ,TotalCount = COUNT(1) OVER()
		    FROM [dbo].[Ufn_GetUserStoriesAlongWithAdhocWork](@CompanyId,@OperationsPerformedBy,@EntityId,@AdhocGoalId,@ProjectId)
			WHERE ((GoalId IS NOT NULL AND CAST(DeadLineDate AS DATE) > CAST(@DateFrom AS DATE) AND CAST(DeadLineDate AS DATE) <=  CAST(@DateTo AS DATE)) OR (SprintId IS NOT NULL AND CAST(SprintEndDate AS DATE) > CAST(@DateFrom AS DATE)))
					AND ((OwnerUserId=@OwnerUserId) OR (@OwnerUserId IS NULL AND OwnerUserId IN  (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))))
			      AND (@SearchText IS NULL 
				       OR (UserStoryName LIKE @SearchText)
                       OR (ProjectName LIKE @SearchText)
                       OR (OwnerName LIKE @SearchText)
                       OR (GoalName LIKE @SearchText)
					   OR (SUBSTRING(CONVERT(VARCHAR, DeadLineDate, 106),1,2) + '-' + SUBSTRING(CONVERT(VARCHAR, DeadLineDate, 106),4,3) + '-'+ CONVERT(VARCHAR,DATEPART(YEAR,DeadLineDate))  LIKE @SearchText) 
					   OR (CONVERT(VARCHAR,DATEPART(DAY,DeadLineDate)) +  '-' + SUBSTRING(CONVERT(VARCHAR, DeadLineDate, 106),4,3) +  '-' + CONVERT(VARCHAR,DATEPART(YEAR,DeadLineDate)) LIKE @SearchText))
			) T
			ORDER BY CASE WHEN @SortDirection = 'ASC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName 
			                   WHEN @SortBy = 'OwnerName' THEN OwnerName 
			                   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL  THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName 
			                   WHEN @SortBy = 'OwnerName' THEN OwnerName 
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END DESC
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
         FETCH NEXT @pageSize ROWS ONLY

		END
		ELSE --IF (@DependencyText = 'ImminentDeadLine') 
		BEGIN
			
			SELECT UserStoryName
			       ,ProjectName
				   ,GoalName
				   ,SprintName
				   ,SprintStartDate
				   ,SprintEndDate
				   ,DependencyName 
				   ,OwnerName
				   ,EstimatedTime
				   ,DeadLineDate
				   ,OwnerUserId
				    ,ProfileImage
				   ,TotalCount = COUNT(1) OVER()
		    FROM [dbo].[Ufn_GetUserStoriesAlongWithAdhocWork](@CompanyId,@OperationsPerformedBy,@EntityId,@AdhocGoalId,@ProjectId)
			WHERE ((@DependencyText = 'CurrentUserStories' AND ((GoalId IS NOT NULL AND CONVERT(DATE,DeadLineDate) =  CONVERT(DATE,GETDATE())) OR (SprintId IS NOT NULL AND  CONVERT(DATE,SprintEndDate) >=  CONVERT(DATE,GETDATE()))) AND OwnerUserId = @OwnerUserId)
			       OR (@DependencyText = 'PreviousUserStories' AND ((GoalId IS NOT NULL AND CONVERT(DATE,DeadLineDate) <  CONVERT(DATE,GETDATE())) OR (SprintId IS NOT NULL AND  CONVERT(DATE,SprintEndDate) <  CONVERT(DATE,GETDATE()))) AND OwnerUserId = @OwnerUserId)
			       OR (@DependencyText = 'FutureUserStories' AND ((GoalId IS NOT NULL AND CONVERT(DATE,DeadLineDate) >  CONVERT(DATE,GETDATE())) OR (SprintId IS NOT NULL AND CONVERT(DATE,SprintEndDate) >  CONVERT(DATE,GETDATE()))) AND OwnerUserId = @OwnerUserId)
				   OR (@DependencyText = 'Current working/Backlog User Stories' AND ((GoalId IS NOT NULL AND DeadLineDate <=  GETDATE() +1) OR (SprintId IS NOT NULL AND SprintEndDate >=  GETDATE() ))			      AND OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))))
			       AND (@SearchText IS NULL 
				       OR (UserStoryName LIKE @SearchText)
                       OR (ProjectName LIKE @SearchText)
                       OR (OwnerName LIKE @SearchText)
                       OR (GoalName LIKE @SearchText)
                       OR (EstimatedTime LIKE @SearchText))
			ORDER BY CASE WHEN @SortDirection = 'ASC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL  THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName 
							   WHEN @SortBy = 'SprintName' THEN SprintName 
			                   WHEN @SortBy = 'OwnerName' THEN OwnerName 
			                   WHEN @SortBy = 'EstimatedTime' THEN CAST(EstimatedTime AS SQL_VARIANT)
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC'
			         THEN CASE WHEN @SortBy = 'UserStoryName' OR @SortBy IS NULL  THEN UserStoryName 
			                   WHEN @SortBy = 'ProjectName' THEN ProjectName 
			                   WHEN @SortBy = 'GoalName' THEN GoalName 
							   WHEN @SortBy = 'SprintName' THEN SprintName 
			                   WHEN @SortBy = 'OwnerName' THEN OwnerName 
			                   WHEN @SortBy = 'EstimatedTime' THEN CAST(EstimatedTime AS SQL_VARIANT) 
							   WHEN @SortBy = 'DeadLineDate' THEN CAST(DeadLineDate AS sql_variant) 
					      END
					 END DESC
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
         FETCH NEXT @pageSize ROWS ONLY

		END
		END
	END TRY
	BEGIN CATCH
	
		THROW

	END CATCH

END
GO