-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-12-31 00:00:00.000'
-- Purpose      To Get the User Stories For All Sprints Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoriesForAllSprints] @OperationsPerformedBy='5bf81b4a-7528-4435-b614-7e65e5e29fcd'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoriesForAllSprints]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @SprintId UNIQUEIDENTIFIER = NULL,
  @ProjectIds XML = NULL,
  @OwnerUserIds XML = NULL,
  @SprintResponsiblePersonIds XML = NULL,
  @UserStoryStatusIds XML = NULL,
  @SprintStatusIds XML = NULL,
  @SprintName NVARCHAR(250) = NULL,
  @DeadLineDateFrom DATETIMEOFFSET = NULL,
  @DeadLineDateTo DATETIMEOFFSET = NULL,
  @IsWarning BIT = NULL,
  @IsArchivedSprint BIT = NULL,
  @IsParkedSprint BIT = NULL,
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
  @IsNotOnTrack BIT = NULL,
  @SprintStartDate DATETIME = NULL,
  @IsActiveSprints    BIT = NULL,
  @IsBacklogSprints   BIT = NULL,
  @IsReplanSprints    BIT = NULL,
  @IsDeleteSprints    BIT = NULL,
  @IsCompletedSprints BIT = NULL,
  @SprintEndDate DATETIME = NULL
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

          
           IF(@IsOnTrack IS NULL) SET @IsOnTrack = 0

		   IF(@IsNotOnTrack IS NULL) SET @IsNotOnTrack = 0

		   IF(@VersionName = '')SET @VersionName = NULL

		   IF(@UserStoryName = '')SET @UserStoryName =  NULL

		   IF(@SprintId = '00000000-0000-0000-0000-000000000000')SET @SprintId = NULL

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
           
           CREATE TABLE #SprintResponsiblePersonIds
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

           CREATE TABLE #SprintStatusIds
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

           IF(@ProjectIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #ProjectIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @ProjectIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

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
           IF(@OwnerUserIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #OwnerUserIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @OwnerUserIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

           IF(@SprintResponsiblePersonIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #SprintResponsiblePersonIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @SprintResponsiblePersonIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

           IF(@UserStoryStatusIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #UserStoryStatusIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @UserStoryStatusIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

           IF(@SprintStatusIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #SprintStatusIds(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @SprintStatusIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		   IF(@WorkItemTags IS NOT NULL)
           BEGIN
                
                INSERT INTO #WorkItemTags(Tag)
                SELECT X.Y.value('(text())[1]', 'NVARCHAR(250)') 
                FROM @WorkItemTags.nodes('/GenericListOfString/ListItems/string') X(Y)

           END

		   
           IF(@IncludeArchived IS NULL) SET @IncludeArchived = 0

           IF(@IncludeParked IS NULL) SET @IncludeParked = 0

           CREATE TABLE #SprintIdsFilter 
           (
                Id UNIQUEIDENTIFIER,
				WorkItemsCount INT
           )

		   CREATE TABLE #SprintUserStoryFilter
		   (
			Id UNIQUEIDENTIFIER,
			UserStoryId UNIQUEIDENTIFIER NULL
		   )

		   INSERT INTO #SprintUserStoryFilter(Id, UserStoryId)
		   SELECT DISTINCT S.Id, US.Id
           FROM 
                (SELECT S.Id,S.BoardTypeId FROM [dbo].[Sprints] S INNER JOIN Project PP ON PP.Id = S.ProjectId
				AND IsSprintsConfiguration = 1
				            AND PP.Id IN (SELECT ProjectId  FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
                        LEFT JOIN #SprintResponsiblePersonIds GRP ON GRP.Id = S.SprintResponsiblePersonId 
                       -- LEFT JOIN #SprintStatusIds GS ON GS.Id = S.S
                        LEFT JOIN #ProjectIds P ON P.Id = S.ProjectId
                WHERE (@SprintId IS NULL OR S.Id = @SprintId)
                       AND (@SprintResponsiblePersonIds IS NULL OR GRP.Id IS NOT NULL)
                       AND (@ProjectIds IS NULL OR P.Id IS NOT NULL)
					   AND (@SprintStartDate IS NULL OR CAST(S.SprintStartDate AS DATE) = CAST(@SprintStartDate AS DATE))
					   AND (@SprintEndDate IS NULL OR CAST(S.SprintEndDate AS DATE) = CAST(@SprintEndDate AS DATE))
                       AND (@SprintName IS NULL OR S.SprintName LIKE '%'+ @SprintName + '%')
					   AND ((ISNULL(@IsActiveSprints,0) = 0 OR (S.InActiveDateTime IS  NULL AND ISNULL(S.IsReplan,0) = 0 AND S.SprintStartDate IS NOT NULL)) 
                       AND (ISNULL(@IsReplanSprints,0) = 0 OR S.IsReplan = 1 AND S.InActiveDateTime IS  NULL) 
                       AND (ISNULL(@IsBacklogSprints,0) = 0 OR S.SprintStartDate IS NULL AND S.InActiveDateTime IS  NULL)
                       AND (ISNULL(@IsDeleteSprints,0) = 0 OR S.InActiveDateTime IS NOT NULL)
                       AND (ISNULL(@IsCompletedSprints,0) = 0 OR S.IsComplete = 1 AND S.InActiveDateTime IS  NULL))
                       AND (@IsArchivedSprint IS NULL OR (@IsArchivedSprint = 1 AND ( S.InActiveDateTime IS NOT NULL)) OR (@IsArchivedSprint = 0 AND S.InActiveDateTime IS NULL))
                     
                ) S
                LEFT JOIN [dbo].[UserStory] US ON US.SprintId = S.Id 
                LEFT JOIN [dbo].[UserStoryStatus] UST ON UST.Id = US.UserStoryStatusId
				LEFT JOIN (SELECT US2.ParentUserStoryId,SprintId 
                           FROM UserStory US2 INNER JOIN UserStoryStatus USS2 ON USS2.Id = US2.UserStoryStatusId
						                      LEFT JOIN #UserStoryType UST ON UST.Id = US2.UserStoryTypeId
						                      LEFT JOIN #BugPriorityId BP ON BP.Id = US2.BugPriorityId
											  LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US2.Id AND BCU.InActiveDateTime IS NULL
						                      LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
						                      LEFT JOIN #DependencyOnUser DU ON DU.Id= US2.DependencyUserId
											  LEFT JOIN #ProjectFeatures PF ON PF.Id = US2.ProjectFeatureId
                           WHERE (OwnerUserId IN (SELECT Id FROM #OwnerUserIds) OR @OwnerUserIds IS NULL) 
				            AND (@UserStoryStatusIds IS NULL OR  US2.UserStoryStatusId IN (SELECT Id FROM #UserStoryStatusIds) OR @UserStoryStatusIds IS NULL)
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
							GROUP BY US2.ParentUserStoryId,SprintId)US3 ON US.Id = US3.ParentUserStoryId AND US3.SprintId = US.SprintId
				INNER JOIN [dbo].[BoardType] BT ON BT.Id = S.BoardTypeId
                LEFT JOIN #OwnerUserIds OU ON OU.Id = US.OwnerUserId   
				LEFT JOIN #UserStoryType UST1 ON UST1.Id = US.UserStoryTypeId
				LEFT JOIN #BugPriorityId BP ON BP.Id = US.BugPriorityId
				LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id AND BCU.InActiveDateTime IS NULL
				LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
				LEFT JOIN #DependencyOnUser DU ON DU.Id= US.DependencyUserId
			    LEFT JOIN #ProjectFeatures PF ON PF.Id = US.ProjectFeatureId
				LEFT JOIN #WorkItemTags WT ON WT.Tag IN (SELECT value FROM STRING_SPLIT(US.Tag, ','))
				--LEFT JOIN ((SELECT ParentUserStoryId,SprintId FROM UserStory US2 WHERE ))
                LEFT JOIN #UserStoryStatusIds USS ON USS.Id = US.UserStoryStatusId  
                WHERE (@UserStoryStatusIds IS NULL OR USS.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
                AND (@OwnerUserIds IS NULL OR OU.Id IS NOT NULL OR US3.ParentUserStoryId IS NOT NULL)
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

			INSERT INTO #SprintIdsFilter(Id,WorkItemsCount)
			SELECT G.Id,COUNT(CASE WHEN G.UserStoryId IS NOT NULL THEN 1 END)FilteredWorkItemsCount
				FROM #SprintUserStoryFilter AS G
				GROUP BY G.Id
                              
           IF (@SprintName = '') SET @SprintName = NULL

           IF (@IsWarning = 0) SET @IsWarning = NULL
           
           IF(@SortDirection IS NULL ) SET @SortDirection = 'ASC'
           
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

           IF(@IncludeArchived = 1) SET @IsArchivedSprint = NULL

           IF(@IncludeParked = 1) SET @IsParkedSprint = NULL
           
           IF(@PageSize IS NULL ) SET @PageSize = 2147483647
           
           IF(@PageNumber IS NULL ) SET @PageNumber = 1
           
           SELECT  S.Id SprintId,
                   S.ProjectId,
				   S.SprintName,
                   P.ProjectName,
                   S.BoardTypeId,
                   S.BoardTypeApiId,
                   S.InActiveDateTime,
                   S.SprintResponsiblePersonId,
                   GRU.FirstName + ' ' + GRU.SurName SprintResponsiblePersonName,
                   GRU.ProfileImage SprintResponsibleProfileImage,
                 --  CASE WHEN G.SprintStatusColor IS NULL THEN '#b7b7b7' ELSE G.SprintStatusColor END AS SprintStatusColor,
                   (SELECT SUM (US.EstimatedTime) FROM UserStory US 
                    WHERE US.SprintId = S.Id AND ParkedDateTime IS NULL 
                          AND ArchivedDateTime IS NULL AND InactiveDateTime IS NULL)  AS SprintEstimatedTime,     
                   --G.IsArchived,
                   CASE WHEN EXISTS(SELECT 1 FROM UserStory US WHERE US.SprintId = S.Id AND US.ArchivedDateTime IS NULL 
                                  AND  US.ParkedDateTime IS NULL AND ((US.EstimatedTime IS NULL OR US.EstimatedTime = 0.00) OR US.DeadLineDate IS NULL OR OwnerUserId IS NULL) 
                                  AND US.InActiveDateTime IS NULL
                                  AND ISNULL(BT.IsBugBoard,0) <> 1) 
                      THEN 1 ELSE 0 END IsWarning,
				   GInner.WorkItemsCount ,
                   S.SprintStartDate,
                   --G.IsParked,
                   S.SprintResponsiblePersonId,
                   U.FirstName + ' ' + ISNULL(U.SurName,'') AS SprintResponsibleUserFullName,
                   U.ProfileImage,
                   S.CreatedDateTime,
                   S.CreatedByUserId,
                   TS.Id TestSuiteId,
                   TS.TestSuiteName,
                   BT.BoardTypeName,
                   BT.BoardTypeUIId AS BoardTypeUiId,
                   BT.IsBugBoard,
                   BT.IsSuperAgileBoard,
                   BT.IsDefault,
                   BTW.WorkflowId,
                   WF.WorkFlow AS WorkFlowName,
                   S.SprintUniqueName,
				   S.SprintEndDate,
				   P.IsDateTimeConfiguration,
				   @EnableSprints AS IsSprintsConfiguration,
				   @EnableTestRepo AS IsEnableTestRepo,
                      (SELECT COUNT(1) FROM UserStory US 
				                  JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
								  JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] NOT IN (4,6))
								  WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id
								   AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
								   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
								   AND US.ArchivedDateTime IS NULL) ActiveUserStoryCount,
                  S.[TimeStamp],
				  (SELECT COUNT(1)
                           FROM UserStory US
                          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.CompanyId = @CompanyId
                          INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id
                     WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                             AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                             AND US.ArchivedDateTime IS NULL) UserStoriesCount,

                    (SELECT COUNT(1)
                          FROM UserStory US
                          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
                          INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] IN (4,6))
                     WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                             AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                             AND US.ArchivedDateTime IS NULL) CompletedUserStoriesCount,
                  TotalCount = COUNT(1) OVER()
              FROM [dbo].[Sprints] S WITH (NOLOCK)
                   INNER JOIN #SprintIdsFilter GInner ON GInner.Id = S.Id
                   INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = S.ProjectId
                               AND P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                            WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy) 
			                   AND P.ProjectName <> 'Adhoc project'
                               AND P.InactiveDateTime IS NULL
                   INNER JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = S.BoardTypeId
                   INNER JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId
                   INNER JOIN [dbo].[BoardType] BT ON BT.Id = S.BoardTypeId
                   LEFT JOIN  [dbo].[TestSuite]TS ON TS.Id = S.TestSuiteId AND TS.InActiveDateTime IS NULL
                   LEFT JOIN [User] GRU ON S.SprintResponsiblePersonId = GRU.Id AND GRU.InActiveDateTime IS NULL
                   LEFT JOIN [User] U WITH (NOLOCK) ON U.Id = S.SprintResponsiblePersonId AND U.InActiveDateTime IS NULL
             WHERE P.CompanyId = @CompanyId
			 	AND (@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULl)))
             ORDER BY 
             CASE WHEN @SortDirection = 'ASC' THEN
                   CASE WHEN(@SortBy = 'ProjectName') THEN P.ProjectName
                        WHEN @SortBy = 'SprintName' THEN S.SprintName
                        WHEN @SortBy = 'SprintResponsibleUserFullName' THEN U.FirstName +' '+ISNULL(U.SurName,'')
                        WHEN @SortBy = 'CreatedDateTime' THEN CAST(S.CreatedDateTime AS SQL_VARIANT)
                  WHEN @SortBy = 'OnBoardProcessDate' THEN CAST(S.SprintStartDate AS SQL_VARIANT)
                    END
                END ASC,
             CASE WHEN @SortDirection = 'DESC' THEN
                    CASE WHEN(@SortBy = 'ProjectName') THEN P.ProjectName
                        WHEN @SortBy = 'SprintShortName' THEN S.SprintName
                        WHEN @SortBy = 'SprintResponsibleUserFullName' THEN U.FirstName +' '+ISNULL(U.SurName,'')
                        WHEN @SortBy = 'CreatedDateTime' THEN CAST(S.CreatedDateTime AS SQL_VARIANT)
                  WHEN @SortBy = 'OnBoardProcessDate' THEN CAST(S.SprintStartDate AS SQL_VARIANT)
                    END
             END DESC
        OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
        FETCH NEXT @PageSize ROWS ONLY

       END TRY  
       BEGIN CATCH 
        
             THROW

      END CATCH
END