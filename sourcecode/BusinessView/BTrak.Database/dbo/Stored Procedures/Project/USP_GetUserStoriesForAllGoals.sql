-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the User Stories For All Goals Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoriesForAllGoals] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoriesForAllGoals]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @GoalId UNIQUEIDENTIFIER = NULL,
  @ProjectId XML = NULL,
  @OwnerUserId XML = NULL,
  @GoalResponsiblePersonId XML = NULL,
  @UserStoryStatusId XML = NULL,
  @GoalStatusId XML = NULL,
  @Tags NVARCHAR(MAX) = NULL,
  @GoalName NVARCHAR(250) = NULL,
  @DeadLineDateFrom DATETIMEOFFSET = NULL,
  @DeadLineDateTo DATETIMEOFFSET = NULL,
  @IsRed BIT = NULL,
  @IsWarning BIT = NULL,
  @IsTracked BIT = NULL,
  @IsProductive BIT = NULL,
  @IsArchivedGoal BIT = NULL,
  @IsParkedGoal BIT = NULL,
  @IncludeArchived BIT = NULL,
  @IncludeParked BIT = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(50)=NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @WorkItemTags XML = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsOnTrack BIT = NULL,
  @CreatedDateFrom DATETIMEOFFSET = NULL,
  @CreatedDateTo DATETIMEOFFSET = NULL,
  @UpdatedDateFrom DATETIMEOFFSET = NULL,
  @UpdatedDateTo DATETIMEOFFSET = NULL,
  @DeadLineDate DATETIMEOFFSET = NULL,
  @UserStoryName NVARCHAR(500) = NULL,
  @VersionName NVARCHAR(500) = NULL,
  @UserStoryTypeIds XML = NULL,
  @BugCausedUserIds XML= NULL,
  @DependencyUserIds XML= NULL,
  @BugPriorityIds XML= NULL,
  @ProjectFeatureIds XML= NULL,
  @IsNotOnTrack BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
           DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		   DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

          
           IF(@Tags = '') SET @Tags = NULL

           IF(@IsOnTrack IS NULL) SET @IsOnTrack = 0

		   IF(@IsNotOnTrack IS NULL) SET @IsNotOnTrack = 0

		   IF(@VersionName = '')SET @VersionName = NULL

		   IF(@UserStoryName = '')SET @UserStoryName =  NULL

		   IF(@UserStoryName IS NOT NULL)SET @UserStoryName =  '%'+ @UserStoryName + '%' 
		   IF(@VersionName IS NOT NULL)SET @VersionName =  '%'+ @VersionName + '%' 

           DECLARE @IsBothTracked BIT = CASE WHEN @IsOnTrack = 1 AND @IsNotOnTrack = 1 THEN 1 ELSE 0 END

           IF(@IsBothTracked = 1)
            SELECT @IsOnTrack = 0,@IsNotOnTrack = 0

           DECLARE @Currentdate DATETIME = GETDATE()
           
           CREATE TABLE #ProjectIds
           (
                Id UNIQUEIDENTIFIER
           )
           
           CREATE TABLE #GoalResponsiblePersonIds
           (
                Id UNIQUEIDENTIFIER
           )

           CREATE TABLE #OwnerUserIds
           (
                Id UNIQUEIDENTIFIER
           )

           CREATE TABLE #UserStoryStatusIds
           (
                Id UNIQUEIDENTIFIER
           )

           CREATE TABLE #GoalStatusIds
           (
                Id UNIQUEIDENTIFIER
           )

		   CREATE TABLE #UserStoryType
           (
                Id UNIQUEIDENTIFIER
           )

		    CREATE TABLE #BugCausedUser
           (
                Id UNIQUEIDENTIFIER
           )

		    CREATE TABLE #BugPriorityId
           (
                Id UNIQUEIDENTIFIER
            )

			 CREATE TABLE #DependencyOnUser
           (
                Id UNIQUEIDENTIFIER
            )
			 CREATE TABLE #ProjectFeatures
           (
                Id UNIQUEIDENTIFIER
            )

			 CREATE TABLE #WorkItemTags
           (
                Tag NVARCHAR(1000)
            )

           IF(@ProjectId IS NOT NULL)
           BEGIN
                
                INSERT INTO #ProjectIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @ProjectId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END
		    IF(@DependencyUserIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #DependencyOnUser(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @DependencyUserIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		   IF(@BugPriorityIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #BugPriorityId(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @BugPriorityIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END
		    IF(@BugCausedUserIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #BugCausedUser(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @BugCausedUserIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		   IF(@UserStoryTypeIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #UserStoryType(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @UserStoryTypeIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END
		     IF(@ProjectFeatureIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #ProjectFeatures(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @ProjectFeatureIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END
           IF(@OwnerUserId IS NOT NULL)
           BEGIN
                
                INSERT INTO #OwnerUserIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @OwnerUserId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

           IF(@GoalResponsiblePersonId IS NOT NULL)
           BEGIN
                
                INSERT INTO #GoalResponsiblePersonIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @GoalResponsiblePersonId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

           IF(@UserStoryStatusId IS NOT NULL)
           BEGIN
                
                INSERT INTO #UserStoryStatusIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @UserStoryStatusId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

           IF(@GoalStatusId IS NOT NULL)
           BEGIN
                
                INSERT INTO #GoalStatusIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @GoalStatusId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		   IF(@WorkItemTags IS NOT NULL)
           BEGIN
                
                INSERT INTO #WorkItemTags(Tag)
                SELECT X.Y.value('(text())[1]', 'NVARCHAR(250)') 
                FROM @WorkItemTags.nodes('/GenericListOfString/ListItems/string') X(Y)

           END

		   
           IF(@IncludeArchived IS NULL) SET @IncludeArchived = 0

           IF(@IncludeParked IS NULL) SET @IncludeParked = 0

           CREATE TABLE #GoalIdsFilter 
           (
                Id UNIQUEIDENTIFIER,
				WorkItemsCount INT
           )

		   CREATE TABLE #GoalUserStoryFilter
		   (
			Id UNIQUEIDENTIFIER,
			UserStoryId UNIQUEIDENTIFIER NULL
		   )

		   INSERT INTO #GoalUserStoryFilter(Id, UserStoryId)
		   SELECT DISTINCT G.Id, US.Id
           FROM 
                (SELECT G.Id,G.BoardTypeId,G.Tag FROM [dbo].[Goal] G INNER JOIN Project PP ON PP.Id = G.ProjectId
                        LEFT JOIN #GoalResponsiblePersonIds GRP ON GRP.Id = G.GoalResponsibleUserId 
                        LEFT JOIN #GoalStatusIds GS ON GS.Id = G.GoalStatusId
                        LEFT JOIN #ProjectIds P ON P.Id = G.ProjectId
                WHERE (@GoalId IS NULL OR G.Id = @GoalId)
                       AND (@GoalResponsiblePersonId IS NULL OR GRP.Id IS NOT NULL)
                       AND (@GoalStatusId IS NULL OR GS.Id IS NOT NULL)
                       AND (@ProjectId IS NULL OR P.Id IS NOT NULL)
					   --AND (@Tags IS NULL OR G.Tag LIKE  '%'+ @Tags + '%')
                       AND (@GoalName IS NULL OR (G.GoalName LIKE '%'+ @GoalName + '%' OR G.GoalShortName LIKE '%'+ @GoalName + '%'))
                       AND (@IsRed IS NULL OR G.GoalStatusColor = '#ff141c')
					   AND (ISNULL(@IsTracked,0)= 0 OR (G.IsToBeTracked = @IsTracked AND @IsTracked= 1))
					   AND  (ISNULL(@IsProductive,0)= 0 OR (G.IsProductiveBoard = @IsProductive AND @IsProductive= 1))
                       AND (@IsArchivedGoal IS NULL OR (@IsArchivedGoal = 1 AND ( G.InActiveDateTime IS NOT NULL)) OR (@IsArchivedGoal = 0 AND G.InActiveDateTime IS NULL))
                       AND (@IsParkedGoal IS NULL OR (@IsParkedGoal = 1 AND (G.ParkedDateTime IS NOT NULL)) OR (@IsParkedGoal = 0 AND G.ParkedDateTime IS NULL ))
                ) G
                LEFT JOIN [dbo].[UserStory] US ON US.GoalId = G.Id 
                LEFT JOIN [dbo].[UserStoryStatus] UST ON UST.Id = US.UserStoryStatusId
				LEFT JOIN (SELECT US2.ParentUserStoryId,GoalId 
                           FROM UserStory US2 INNER JOIN UserStoryStatus USS2 ON USS2.Id = US2.UserStoryStatusId
						                      LEFT JOIN #UserStoryType UST ON UST.Id = US2.UserStoryTypeId
						                      LEFT JOIN #BugPriorityId BP ON BP.Id = US2.BugPriorityId
											  LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US2.Id AND BCU.InActiveDateTime IS NULL
						                      LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
						                      LEFT JOIN #DependencyOnUser DU ON DU.Id= US2.DependencyUserId
											  LEFT JOIN #ProjectFeatures PF ON PF.Id = US2.ProjectFeatureId
                           WHERE (OwnerUserId IN (SELECT Id FROM #OwnerUserIds) OR @OwnerUserId IS NULL) 
				            AND (@UserStoryStatusId IS NULL OR  US2.UserStoryStatusId IN (SELECT Id FROM #UserStoryStatusIds) OR @UserStoryStatusId IS NULL)
				            AND  (@WorkItemTags IS NULL OR REPLACE(US2.Tag, ' ', '' )  IN (SELECT REPLACE(Tag, ' ', '' ) FROM #WorkItemTags))
				            AND  ((@IncludeArchived = 1) OR (@IncludeArchived = 0 AND US2.InActiveDateTime IS NULL))
                            AND  ((@IncludeParked = 1) OR (@IncludeParked = 0 AND US2.ParkedDateTime IS NULL))
				            AND  (@DeadLineDateFrom IS NULL OR US2.DeadLineDate >= @DeadLineDateFrom)
							AND (@CreatedDateFrom IS NULL OR CAST(US2.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE))
							AND (@CreatedDateTo IS NULL OR CAST(US2.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE))
							AND (@UpdatedDateFrom IS NULL OR CAST(US2.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE))
							AND (@UpdatedDateTo IS NULL OR CAST(US2.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE))
							AND (@DeadLineDate IS NULL OR CAST(US2.DeadlineDate AS DATE) = CAST(@DeadLineDate AS DATE))
							AND  (US2.UserStoryName LIKE   @UserStoryName  OR @UserStoryName IS NULL)
							AND  (US2.VersionName LIKE  @VersionName OR @VersionName IS NULL)
							AND (@UserStoryTypeIds IS NULL OR UST.Id IS NOT NULL)
							AND (@BugPriorityIds IS NULL OR BP.Id IS NOT NULL)
							AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL)
							AND (@DependencyUserIds IS NULL OR DU.Id IS NOT NULL)
							AND (@ProjectFeatureIds IS NULL OR PF.Id IS NOT NULL)
							AND (@DeadLineDate IS NULL OR CAST(US2.DeadlineDate AS DATE) = CAST(@DeadLineDate AS DATE))
                            AND (@IsBothTracked = 0 OR
                                 (@IsBothTracked = 1 AND USS2.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' AND US2.DeadLineDate IS NOT NULL)
                                  --OR (@IsNotOnTrack = 0 OR (US.DeadLineDate < GETDATE() AND (UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')))
                                  --OR (@IsOnTrack = 0 OR (US.DeadLineDate >= GETDATE() AND (UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')))
                                )
                            AND (@IsNotOnTrack = 0 OR (CONVERT(DATE,US2.DeadLineDate) < CONVERT(DATE,GETDATE()) 
                                                       AND (USS2.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
                                                       AND US2.DeadLineDate IS NOT NULL
                                                       ))
                            AND (@IsOnTrack = 0 OR (CONVERT(DATE,US2.DeadLineDate) >= CONVERT(DATE,GETDATE()) 
                                                    AND (USS2.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
                                                    AND US2.DeadLineDate IS NOT NULL
                                        ))
                            AND  (@DeadLineDateTo IS NULL OR US2.DeadLineDate <= @DeadLineDateTo)
							AND  (@IsWarning IS NULL OR (US2.EstimatedTime IS NULL OR US2.DeadLineDate IS NULL OR US2.OwnerUserId IS NULL))
							GROUP BY US2.ParentUserStoryId,GoalId)US3 ON US.Id = US3.ParentUserStoryId AND US3.GoalId = US.GoalId
				INNER JOIN [dbo].[BoardType] BT ON BT.Id = G.BoardTypeId
                LEFT JOIN #OwnerUserIds OU ON OU.Id = US.OwnerUserId   
				LEFT JOIN #UserStoryType UST1 ON UST1.Id = US.UserStoryTypeId
				LEFT JOIN #BugPriorityId BP ON BP.Id = US.BugPriorityId
				LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id AND BCU.InActiveDateTime IS NULL
				LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
				LEFT JOIN #DependencyOnUser DU ON DU.Id= US.DependencyUserId
			    LEFT JOIN #ProjectFeatures PF ON PF.Id = US.ProjectFeatureId
				LEFT JOIN #WorkItemTags WT ON WT.Tag IN (SELECT value FROM STRING_SPLIT(US.Tag, ','))
				--LEFT JOIN ((SELECT ParentUserStoryId,GoalId FROM UserStory US2 WHERE ))
                LEFT JOIN #UserStoryStatusIds USS ON USS.Id = US.UserStoryStatusId  
                WHERE (@UserStoryStatusId IS NULL OR USS.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
                AND (@OwnerUserId IS NULL OR OU.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND (@UserStoryTypeIds IS NULL OR UST1.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND (@BugPriorityIds IS NULL OR BP.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND (@DependencyUserIds IS NULL OR DU.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND (@ProjectFeatureIds IS NULL OR PF.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND (@WorkItemTags IS NULL OR WT.Tag IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
			    AND (@CreatedDateFrom IS NULL OR CAST(US.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE) OR US3.ParentUserStoryId IS NOT NULL)
				AND (@CreatedDateTo IS NULL OR CAST(US.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE) OR US3.ParentUserStoryId IS NOT NULL)
				AND (@DeadLineDate IS NULL OR CAST(US.DeadlineDate AS DATE) = CAST(@DeadLineDate AS DATE) OR US3.ParentUserStoryId IS NOT NULL)
				AND (@UpdatedDateFrom IS NULL OR CAST(US.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE) OR US3.ParentUserStoryId IS NOT NULL)
				AND (@UpdatedDateTo IS NULL OR CAST(US.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE) OR US3.ParentUserStoryId IS NOT NULL)
				AND (@Tags IS NULL OR G.Tag LIKE '%'+ @Tags + '%')
                AND (@IsBothTracked = 0 OR
                     (@IsBothTracked = 1 AND UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' AND US.DeadLineDate IS NOT NULL)
                      --OR (@IsNotOnTrack = 0 OR (US.DeadLineDate < GETDATE() AND (UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')))
                      --OR (@IsOnTrack = 0 OR (US.DeadLineDate >= GETDATE() AND (UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')))
                    )
                AND (@IsNotOnTrack = 0 OR (CONVERT(DATE,US.DeadLineDate) < CONVERT(DATE,GETDATE()) 
                                           AND (UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
                                           AND US.DeadLineDate IS NOT NULL
                                           ))
                AND (@IsOnTrack = 0 OR (CONVERT(DATE,US.DeadLineDate) >= CONVERT(DATE,GETDATE()) 
                                        AND (UST.TaskStatusId <> 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
                                        AND US.DeadLineDate IS NOT NULL
                                        ))
                AND ( US3.ParentUserStoryId IS NOT NULL OR ((@IncludeArchived = 1) OR (@IncludeArchived = 0 AND US.InActiveDateTime IS NULL)))
                AND ( US3.ParentUserStoryId IS NOT NULL OR ((@IncludeParked = 1) OR (@IncludeParked = 0 AND US.ParkedDateTime IS NULL)))
                AND (@UserStoryId IS NULL OR US.Id = @UserStoryId)
				AND  (US.UserStoryName LIKE  @UserStoryName OR @UserStoryName IS NULL OR US3.ParentUserStoryId IS NOT NULL)
				AND  (US.VersionName LIKE  @VersionName OR @VersionName IS NULL OR US3.ParentUserStoryId IS NOT NULL)
                AND ( US3.ParentUserStoryId IS NOT NULL OR @DeadLineDateFrom IS NULL OR US.DeadLineDate >= @DeadLineDateFrom)
                AND ( US3.ParentUserStoryId IS NOT NULL OR @DeadLineDateTo IS NULL OR US.DeadLineDate <= @DeadLineDateTo)
                AND ((@IsWarning IS NULL OR (US.EstimatedTime IS NULL OR US.DeadLineDate IS NULL OR US.OwnerUserId IS NULL))OR US3.ParentUserStoryId IS NOT NULL)
				AND ((@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULl)))OR US3.ParentUserStoryId IS NOT NULL)

			INSERT INTO #GoalIdsFilter(Id,WorkItemsCount)
			SELECT G.Id,COUNT(CASE WHEN G.UserStoryId IS NOT NULL THEN 1 END)FilteredWorkItemsCount
				FROM #GoalUserStoryFilter AS G
				GROUP BY G.Id
                              
           IF (@GoalName = '') SET @GoalName = NULL

		   IF (@Tags = '') SET @Tags = NULL
           
           IF (@IsRed = 0) SET @IsRed = NULL
           
           IF (@IsWarning = 0) SET @IsWarning = NULL
           
           IF(@SortDirection IS NULL ) SET @SortDirection = 'ASC'
           
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

           IF(@IncludeArchived = 1) SET @IsArchivedGoal = NULL

           IF(@IncludeParked = 1) SET @IsParkedGoal = NULL
           
           IF(@PageSize IS NULL ) SET @PageSize = 2147483647
           
           IF(@PageNumber IS NULL ) SET @PageNumber = 1
           
           SELECT  G.Id GoalId,
                   G.ProjectId,
                   P.ProjectName,
                   G.BoardTypeId,
                   G.BoardTypeApiId,
                  -- G.ArchivedDateTime,
                   G.InActiveDateTime,
                   G.GoalBudget,
                   G.GoalName,
                   G.GoalStatusId,
                   G.GoalShortName,
                   G.GoalResponsibleUserId,
                   GRU.FirstName + ' ' + GRU.SurName GoalResponsibleUserName,
                   GRU.ProfileImage GoalResponsibleProfileImage,
                   CASE WHEN G.GoalStatusColor IS NULL THEN '#b7b7b7' ELSE G.GoalStatusColor END AS GoalStatusColor,
                   (SELECT MAX (DeadLineDate) FROM UserStory US 
                    WHERE US.GoalId = G.Id
                          AND ParkedDateTime IS NULL AND ArchivedDateTime IS NULL 
                          AND InactiveDateTime IS NULL GROUP BY GoalId) AS GoalDeadLine ,
                   (SELECT SUM (US.EstimatedTime) FROM UserStory US 
                    WHERE US.GoalId = G.Id AND ParkedDateTime IS NULL 
                          AND ArchivedDateTime IS NULL AND InactiveDateTime IS NULL GROUP BY GoalId)  AS GoalEstimatedTime,     
                   --G.IsArchived,
                   CASE WHEN EXISTS(SELECT 1 FROM UserStory US WHERE US.GoalId = G.Id AND US.ArchivedDateTime IS NULL 
                                  AND  US.ParkedDateTime IS NULL AND ((US.EstimatedTime IS NULL OR US.EstimatedTime = 0.00) OR US.DeadLineDate IS NULL OR OwnerUserId IS NULL) 
                                  AND US.InActiveDateTime IS NULL
                                  AND ISNULL(BT.IsBugBoard,0) <> 1) 
                      THEN 1 ELSE 0 END IsWarning,
				   GInner.WorkItemsCount ,
                   G.IsLocked,
                   G.IsProductiveBoard,
                   G.IsToBeTracked,
                   G.OnboardProcessDate,
                   --G.IsParked,
                   G.IsApproved,
                   G.ParkedDateTime,
                   G.[Version],
                   G.GoalResponsibleUserId,
                   U.FirstName + ' ' + ISNULL(U.SurName,'') AS GoalResponsibleUserFullName,
                   U.ProfileImage,
                   G.ConfigurationId,
                   G.ConsiderEstimatedHoursId,
                   G.CreatedDateTime,
                   G.CreatedByUserId,
                   TS.Id TestSuiteId,
                   TS.TestSuiteName,
                   BT.BoardTypeName,
                   BT.BoardTypeUIId AS BoardTypeUiId,
                   BT.IsBugBoard,
                   BT.IsSuperAgileBoard,
                   BT.IsDefault,
                   BTW.WorkflowId,
                   WF.WorkFlow AS WorkFlowName,
                   G.GoalUniqueName,
				   P.IsDateTimeConfiguration,
				   @EnableSprints AS IsSprintsConfiguration,
				   @EnableTestRepo AS IsEnableTestRepo,
                   CASE WHEN G.ParkedDateTime IS NULL THEN 0 ELSE 1 END AS IsParked,
                      (SELECT COUNT(1) FROM UserStory US 
				                  JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
								  JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] NOT IN (4,6))
								  WHERE ((US.GoalId = G.Id AND BT.IsBugBoard = 1) OR (US.GoalId = G.Id  AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
								   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
								   AND US.ArchivedDateTime IS NULL) ActiveUserStoryCount,
                  G.[TimeStamp],
				  G.Tag,
                  TotalCount = COUNT(1) OVER()
              FROM [dbo].[Goal] G WITH (NOLOCK)
                   INNER JOIN #GoalIdsFilter GInner ON GInner.Id = G.Id 
                   INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = G.ProjectId
                               AND P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                            WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy) 
			                   AND P.ProjectName <> 'Adhoc project'
                               AND P.InactiveDateTime IS NULL
                   INNER JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = G.BoardTypeId
                   INNER JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId
                   INNER JOIN [dbo].[BoardType] BT ON BT.Id = G.BoardTypeId
                   LEFT JOIN  [dbo].[TestSuite]TS ON TS.Id = G.TestSuiteId AND TS.InActiveDateTime IS NULL
                   LEFT JOIN [User] GRU ON G.GoalResponsibleUserId = GRU.Id AND GRU.InActiveDateTime IS NULL
                   LEFT JOIN [User] U WITH (NOLOCK) ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
             WHERE P.CompanyId = @CompanyId
			 	AND (@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULl)))
             ORDER BY 
             CASE WHEN @SortDirection = 'ASC' THEN
                   CASE WHEN(@SortBy = 'ProjectName') THEN P.ProjectName
                        WHEN @SortBy = 'GoalShortName' THEN G.GoalShortName
                        WHEN @SortBy = 'GoalResponsibleUserFullName' THEN U.FirstName +' '+ISNULL(U.SurName,'')
                        WHEN @SortBy = 'CreatedDateTime' THEN CAST(G.CreatedDateTime AS SQL_VARIANT)
                  WHEN @SortBy = 'OnBoardProcessDate' THEN CAST(G.OnboardProcessDate AS SQL_VARIANT)
                    END
                END ASC,
             CASE WHEN @SortDirection = 'DESC' THEN
                    CASE WHEN(@SortBy = 'ProjectName') THEN P.ProjectName
                        WHEN @SortBy = 'GoalShortName' THEN G.GoalShortName
                        WHEN @SortBy = 'GoalResponsibleUserFullName' THEN U.FirstName +' '+ISNULL(U.SurName,'')
                        WHEN @SortBy = 'CreatedDateTime' THEN CAST(G.CreatedDateTime AS SQL_VARIANT) 
                  WHEN @SortBy = 'OnBoardProcessDate' THEN CAST(G.OnboardProcessDate AS SQL_VARIANT)
                    END
             END DESC
        OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
        FETCH NEXT @PageSize ROWS ONLY

       END TRY  
       BEGIN CATCH 
        
             THROW

      END CATCH
END