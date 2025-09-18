-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-08 00:00:00.000'
-- Purpose      To Get the Productivity Index For Developers By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetProductivityIndexForDevelopers_New] @OperationsPerformedBy='8EBCC84D-CC59-4D52-9CD1-87BEE2441BF2',@Type='Month',@Date='2019-09-03',@SortDirection = 'DESC',@SortBy = 'avgSpentTime',@PageSize=100

CREATE PROCEDURE [dbo].[USP_GetProductivityIndexForDevelopers_New]
(
   @Type VARCHAR(100) = NULL,
   @Date DATETIME = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @SearchText VARCHAR(500) = NULL,
   @SortBy NVARCHAR(250) = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @OwnerUserId UNIQUEIDENTIFIER = NULL,
   @IsReportingOnly BIT = NULL,
   @IsMyself BIT = NULL,
   @IsFromDrilldown BIT = 0,
   @IsAll BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@Type = '') SET @Type = NULL
		
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		IF(@Type IS NULL AND @DateFrom IS NULL AND @DateTo IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Date period')

		END
		ELSE IF(@Date IS NULL AND @DateFrom IS NULL AND @DateTo IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Date')
		
		END
		ELSE
		BEGIN
	  

            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
			
			    IF(@SortDirection IS NULL )
				BEGIN
					SET @SortDirection = 'DESC'
				END
				
				DECLARE @OrderByColumn NVARCHAR(250) 

				IF(@SortBy IS NULL)
				BEGIN

					SET @SortBy = 'ProductivityIndex'

				END
				ELSE
				BEGIN

					SET @SortBy = @SortBy

				END

				DECLARE @Currentdate DATETIME = GETDATE()

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				 DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                    FROM CompanyModule CM 
                                                         INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                         INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'B424B603-1997-4E6F-8E32-82AD90097950' --Manage app filters
                                                                    AND CM.CompanyId = @CompanyId
												 GROUP BY FeatureId)
       
                  DECLARE @HaveAdvancedPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
	              
	              
                  IF(@HaveAdvancedPermission = 0)
                  BEGIN
                  
                   SET @IsReportingOnly = 1 
		           SET @IsAll = 0
		           SET @IsMyself = 0
	              
                  END
				  IF(@IsFromDrilldown = 1)
				  BEGIN

				   SET @IsReportingOnly = 0
		           SET @IsAll = 1
		           SET @IsMyself = 0

				  END

				  CREATE TABLE #EmployeeReportedMembers
				  (
				  ChildId UNIQUEIDENTIFIER
				  )
				  
				  IF(@IsAll = 0)
				  BEGIN

				  INSERT INTO #EmployeeReportedMembers
		         SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)

				  END

				--DECLARE @DateFrom DATETIME,@DateTo DATETIME

				DECLARE @UserId UNIQUEIDENTIFIER = NULL

				IF(@Type = 'Month')
				BEGIN

				   SELECT @DateFrom = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)

				   SELECT @DateTo = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))

				END
				ELSE IF(@Type = 'Week')
				BEGIN

				   SELECT @DateTo = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))

				   SELECT @DateFrom = DATEADD(dd, -(DATEPART(dw, @DateTo)-1), CAST(@DateTo AS DATE))

				END
				IF(@DateTo >= CONVERT(DATE,GETUTCDATE()))
				BEGIN

				   SELECT @DateTo = CONVERT(DATE,GETUTCDATE())

				END

				SET @DateFrom = CONVERT(DATE,@DateFrom)

				SET @DateTo = CONVERT(DATE,@DateTo)

				SET @SearchText = '%'+ @SearchText+'%'

			   CREATE TABLE #ProductiveHours 
			   (
			   		UserId UNIQUEIDENTIFIER,
			   		UserStoryId UNIQUEIDENTIFIER,
			   		EstimatedTime NUMERIC(10,2),
			   		GoalId UNIQUEIDENTIFIER,
			   		UserStoryReplanCount NUMERIC(10,2),
			   		GRPIndex FLOAT,
			   		ReopenedCount INT,
			   		CompletedUserStoresCountByUserId INT,
			   		QAApprovedUserStoriesCountByUserId INT,
			   		ReopenedUserStoresCountByUserId INT,
			   		UserStoriesBouncedBackOnceCountByUserId INT,
			   		UserStoriesBouncedBackMoreThanOnceCountByUserId INT,
			   		ISForQA INT
			   )
			
			INSERT INTO #ProductiveHours(UserId,UserStoryId,EstimatedTime,ISForQA)
			SELECT PIN.UserId,PIN.UserStoryId,SUM(PIN.ProductivityIndex),0
			FROM ProductivityIndex PIN 
			WHERE PIN.CompanyId = @CompanyId
			     AND PIN.[Date] BETWEEN @DateFrom AND @DateTo
				 AND PIN.UserStoryId IS NOT NULL 
			GROUP BY PIN.UserId,PIN.UserStoryId --,PIN.ProductivityIndex

			UPDATE #ProductiveHours SET GoalId = US.GoalId
			FROM #ProductiveHours PH 
			     INNER JOIN UserStory US ON US.Id = PH.UserStoryId

			UPDATE #ProductiveHours SET ReopenedCount = PHInner.ReopenedCount
			FROM #ProductiveHours PH
			     LEFT JOIN (SELECT COUNT(UW.UserStoryId) ReopenedCount,UW.UserStoryId FROM #ProductiveHours PH 
			     INNER JOIN UserStoryWorkflowStatusTransition UW ON PH.UserStoryId = UW.UserStoryId 
			     INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
			     INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
			                AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
			     INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
			                AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
			GROUP BY UW.UserStoryId) PHInner ON PH.UserStoryId = PHInner.UserStoryId 
			
			UPDATE #ProductiveHours SET CompletedUserStoresCountByUserId = CompletedUserStorycount,
			                            QAApprovedUserStoriesCountByUserId = QAApprovedUserStories,
			                            ReopenedUserStoresCountByUserId = ISNULL(ReopenedUserStoresCount,0),
			                            UserStoriesBouncedBackOnceCountByUserId = UserStoriesBouncedBackOnceCount,
			                            UserStoriesBouncedBackMoreThanOnceCountByUserId = ISNULL(ReopenedUserStoresCount,0) - UserStoriesBouncedBackOnceCount
			FROM #ProductiveHours PH
			     INNER JOIN (SELECT UserId,
			                        COUNT(UserStoryId) CompletedUserStorycount,
			                        SUM(ISForQA) AS QAApprovedUserStories,
								    COUNT(CASE WHEN ReopenedCount > 0 THEN 1 ELSE NULL END) AS ReopenedUserStoresCount,
								    COUNT(CASE WHEN ReopenedCount = 1 THEN 1 ELSE NULL END) AS UserStoriesBouncedBackOnceCount
			                 FROM #ProductiveHours
			                 GROUP BY UserId) PHInner ON PHInner.UserId = PH.UserId
				  
			UPDATE #ProductiveHours SET UserStoryReplanCount = ISNULL(ReplanCount,0)
			FROM #ProductiveHours PH
			     INNER JOIN (SELECT COUNT(USR.UserStoryId) AS ReplanCount,USR.UserStoryId
			                 FROM #ProductiveHours PH
			                      LEFT JOIN UserStoryReplan USR ON USR.UserStoryId = PH.UserStoryId
			                 GROUP BY USR.UserStoryId) PHInner ON PHInner.UserStoryId = PH.UserStoryId 
							  
			INSERT INTO #ProductiveHours(UserId)
			SELECT U.Id 
			FROM [User] U  
			WHERE U.InactiveDateTime IS NULL 
			      AND U.IsActive = 1 
				  AND NOT EXISTS(SELECT 1 FROM #ProductiveHours WHERE UserId = U.Id)

			UPDATE #ProductiveHours SET GRPIndex = ISNULL(PIDInner.GRPIndex,0)
			FROM #ProductiveHours PID
			     LEFT JOIN (SELECT GoalResponsibleUserId, SUM(PUS.EstimatedTime) GRPIndex
			                FROM #ProductiveHours PUS
			                     INNER JOIN Goal G ON G.Id = PUS.GoalId AND G.GoalResponsibleUserId <> PUS.UserId
			                GROUP BY GoalResponsibleUserId) PIDInner ON PIDInner.GoalResponsibleUserId = PID.UserId

			SELECT UserId
			       ,UserName
			       ,UserProfileImage
				   ,ProductivityIndex
				   ,AvgActivityTrackerProductivity
				   ,AvgSpentTime
				   ,GRPIndex
				   --,ReopenCount
				   ,ReopenedUserStoresCount
				   ,PercentageOfBouncedUserStories
				   ,UserStoriesBouncedBackOnceCount
				   ,UserStoriesBouncedBackMoreThanOnceCount
				   ,AvgReplan
				   ,PercentageOfQAApprovedUserStories
				   ,CompletedUserStoriesCount
				   ,COUNT(1) OVER() AS TotalCount 
			FROM (
			SELECT U.Id AS UserId,
                   U.FirstName + ' ' + ISNULL(U.SurName,'')  AS UserName,
                   U.ProfileImage  AS UserProfileImage,
                   SUM(PID.EstimatedTime) ProductivityIndex,
				   ATP.ProductiveTime AvgActivityTrackerProductivity,
				   ST.SpenTime AvgSpentTime,
                   PID.GRPIndex,
                   --PID.ReopenedCount ReopenCount,
                   PID.CompletedUserStoresCountByUserId AS CompletedUserStoriesCount,
                   PID.ReopenedUserStoresCountByUserId AS ReopenedUserStoresCount,
                   CAST((CASE WHEN CompletedUserStoresCountByUserId = 0 THEN 0 ELSE (PID.ReopenedUserStoresCountByUserId*1.0/CompletedUserStoresCountByUserId*1.0)*100  END) AS NUMERIC(10,2)) PercentageOfBouncedUserStories,
                   UserStoriesBouncedBackOnceCountByUserId UserStoriesBouncedBackOnceCount,
                   UserStoriesBouncedBackMoreThanOnceCountByUserId UserStoriesBouncedBackMoreThanOnceCount,
                   CAST((SUM(UserStoryReplanCount))*1.00 AS NUMERIC(10,2)) AvgReplan,
                   --CAST((CASE WHEN CompletedUserStoresCountByUserId = 0 THEN 0 ELSE (PID.QAApprovedUserStoriesCountByUserId*1.0/CompletedUserStoresCountByUserId*1.0)*100 END) AS NUMERIC(10,2)) PercentageOfQAApprovedUserStories,
				   0 AS PercentageOfQAApprovedUserStories
            FROM  [dbo].[User] U
				 INNER JOIN [Employee] E ON E.UserId = U.Id AND U.CompanyId = @CompanyId And U.InActiveDateTime IS NULL AND U.IsActive = 1
				 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
				 	        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 	        AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
				 LEFT JOIN #ProductiveHours PID ON U.Id =  PID.UserId 
				 LEFT JOIN (SELECT UserId,AVG(AvgActivityTrackerProductivity) ProductiveTime FROM ProductivityIndex PIN GROUP BY UserId) ATP ON ATP.UserId = PID.UserId
				 LEFT JOIN (SELECT UserId,AVG(AvgSpentTime) SpenTime FROM ProductivityIndex PIN GROUP BY UserId) ST ON ST.UserId = PID.UserId 
				 WHERE @OwnerUserId IS NULL OR U.Id = @OwnerUserId
				           AND (((@IsReportingOnly = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
						   (@OperationsPerformedBy,@CompanyId) WHERE (ChildId <>  @OperationsPerformedBy OR @HaveAdvancedPermission = 0))) 
							 OR (@IsMyself = 1 AND U.Id = @OperationsPerformedBy) 
							 OR @IsAll = 1 ))

              GROUP BY U.Id,U.FirstName,U.SurName,U.ProfileImage,GRPIndex,CompletedUserStoresCountByUserId,UserStoriesBouncedBackOnceCountByUserId,PID.ReopenedUserStoresCountByUserId,
                       UserStoriesBouncedBackMoreThanOnceCountByUserId,ATP.ProductiveTime,ST.SpenTime
					   --,QAApprovedUserStoriesCountByUserId
			  ) T
			  WHERE (@SearchText IS NULL 
				       OR UserName LIKE @SearchText
				       OR GRPIndex LIKE @SearchText
				       OR CompletedUserStoriesCount LIKE @SearchText
				       OR UserStoriesBouncedBackOnceCount LIKE @SearchText
					   OR AvgReplan LIKE @SearchText
				       OR UserStoriesBouncedBackMoreThanOnceCount LIKE @SearchText
					   OR PercentageOfBouncedUserStories LIKE @SearchText
					   OR PercentageOfQAApprovedUserStories LIKE @SearchText)
					       AND (((@IsReportingOnly = 1 AND T.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
						   (@OperationsPerformedBy,@CompanyId) WHERE (ChildId <>  @OperationsPerformedBy OR @HaveAdvancedPermission = 0))) 
							 OR (@IsMyself = 1 AND T.UserId  = @OperationsPerformedBy) 
							 OR @IsAll = 1 ))

				ORDER BY 
				CASE WHEN @SortDirection = 'ASC' THEN
				CASE WHEN @SortBy = 'productivityIndex' THEN CAST(ProductivityIndex AS SQL_VARIANT)
				     WHEN @SortBy = 'avgActivityTrackerProductivity' THEN CAST(AvgActivityTrackerProductivity AS SQL_VARIANT)
					 WHEN @SortBy = 'avgSpentTime' THEN CAST(AvgSpentTime AS SQL_VARIANT)
				     WHEN @SortBy = 'userName' THEN UserName
				     WHEN @SortBy = 'grpIndex' THEN CAST(GRPIndex AS SQL_VARIANT)
				     --WHEN @SortBy = 'ReopenCount' THEN Cast(ReopenCount AS SQL_VARIANT) 
				     --WHEN @SortBy = 'ReopenedUserStoresCount' THEN CAST(ReopenedUserStoriesCount AS SQL_VARIANT)   
					 --WHEN @SortBy = 'QAApprovedUserStoriesCount' THEN CAST(QAApprovedUserStoriesCount AS SQL_VARIANT)
				     WHEN @SortBy = 'completedUserStoriesCount' THEN CAST(CompletedUserStoriesCount AS SQL_VARIANT) 
				     WHEN @SortBy = 'userStoriesBouncedBackOnceCount' THEN CAST(UserStoriesBouncedBackOnceCount AS SQL_VARIANT)  
				     WHEN @SortBy = 'userStoriesBouncedBackMoreThanOnceCount' THEN CAST(UserStoriesBouncedBackMoreThanOnceCount AS SQL_VARIANT)  
					 WHEN @SortBy = 'avgReplan' THEN CAST(AvgReplan AS SQL_VARIANT) 
					 WHEN @SortBy = 'percentageOfBouncedUserStories' THEN CAST(PercentageOfBouncedUserStories AS SQL_VARIANT)  
					 WHEN @SortBy = 'percentageOfQAApprovedUserStories' THEN CAST(PercentageOfQAApprovedUserStories AS SQL_VARIANT)   
					 END 
				END ASC,
				CASE WHEN @SortDirection = 'DESC' THEN
				CASE WHEN @SortBy = 'productivityIndex' THEN CAST(ProductivityIndex AS SQL_VARIANT)
				     WHEN @SortBy = 'avgActivityTrackerProductivity' THEN CAST(AvgActivityTrackerProductivity AS SQL_VARIANT)
					 WHEN @SortBy = 'avgSpentTime' THEN CAST(AvgSpentTime AS SQL_VARIANT)
				     WHEN @SortBy = 'userName' THEN UserName
				     WHEN @SortBy = 'grpIndex' THEN CAST(GRPIndex AS SQL_VARIANT)
				     --WHEN @SortBy = 'ReopenCount' THEN Cast(ReopenCount AS SQL_VARIANT) 
				     --WHEN @SortBy = 'ReopenedUserStoresCount' THEN CAST(ReopenedUserStoriesCount AS SQL_VARIANT)   
					 --WHEN @SortBy = 'QAApprovedUserStoriesCount' THEN CAST(QAApprovedUserStoriesCount AS SQL_VARIANT)
				     WHEN @SortBy = 'completedUserStoriesCount' THEN CAST(CompletedUserStoriesCount AS SQL_VARIANT) 
				     WHEN @SortBy = 'userStoriesBouncedBackOnceCount' THEN CAST(UserStoriesBouncedBackOnceCount AS SQL_VARIANT)  
				     WHEN @SortBy = 'userStoriesBouncedBackMoreThanOnceCount' THEN CAST(UserStoriesBouncedBackMoreThanOnceCount AS SQL_VARIANT)  
					 WHEN @SortBy = 'avgReplan' THEN CAST(AvgReplan AS SQL_VARIANT) 
					 WHEN @SortBy = 'percentageOfBouncedUserStories' THEN CAST(PercentageOfBouncedUserStories AS SQL_VARIANT)  
					 WHEN @SortBy = 'percentageOfQAApprovedUserStories' THEN CAST(PercentageOfQAApprovedUserStories AS SQL_VARIANT)   
					 END 
	 			END DESC
				OFFSET ((@PageNo - 1) * @PageSize) ROWS 

				FETCH NEXT @PageSize ROWS ONLY

		    END
			--ELSE
					--RAISERROR (@HavePermission,11, 1)

		END

	END TRY 
	BEGIN CATCH 
		
		 THROW

	END CATCH

END