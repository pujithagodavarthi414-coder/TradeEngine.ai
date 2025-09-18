CREATE PROCEDURE [dbo].[USP_GetSprintUserStories]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SprintId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @UserStoryId UNIQUEIDENTIFIER = NULL,
   @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @IsParked BIT = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @UserStoryName NVARCHAR(250) = NULL,
   @UserStoryIdsXml XML = NULL,
   @ProjectIds XML = NULL,
   @OwnerUserIds XML = NULL,
   @SprintResponsiblePersonIds XML = NULL,
   @UserStoryStatusIds XML = NULL,
   @SprintStatusIds XML = NULL,
   @SprintName NVARCHAR(250) = NULL,
   @DeadLineDateFrom DATETIMEOFFSET = NULL,
   @DeadLineDateTo DATETIMEOFFSET = NULL,
   @IsArchivedSprint BIT = NULL,
   @IsParkedSprint BIT = NULL,
   @IncludeArchived BIT = NULL,
   @IncludeParked BIT = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(50)=NULL,
   @PageSize INT = NULL,
   @PageNumber INT = NULL,
   @WorkItemTags XML = NULL,
   @IsOnTrack BIT = NULL,
   @CreatedDateFrom DATETIMEOFFSET = NULL,
   @CreatedDateTo DATETIMEOFFSET = NULL,
   @UpdatedDateFrom DATETIMEOFFSET = NULL,
   @UpdatedDateTo DATETIMEOFFSET = NULL,
   @DeadLineDate DATETIMEOFFSET = NULL,
   @VersionName NVARCHAR(500) = NULL,
   @UserStoryTypeIds XML = NULL,
   @BugCausedUserIds XML= NULL,
   @DependencyUserIds XML= NULL,
   @BugPriorityIds XML= NULL,
   @ProjectFeatureIds XML= NULL,
   @IsActiveSprints    BIT = NULL,
   @IsBacklogSprints   BIT = NULL,
   @IsReplanSprints    BIT = NULL,
   @IsDeleteSprints    BIT = NULL,
   @IsCompletedSprints BIT = NULL,
   @IsNotOnTrack BIT = NULL,
   @SprintStartDate DATETIME = NULL,
   @SprintEndDate DATETIME = NULL,
   @SprintUniqueName NVARCHAR(500) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	 DECLARE @IsAutoLog BIT =  (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%') 
     DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
	 DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
	 DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
	 DECLARE @EnableStartStop BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%')

         
     IF (@HavePermission = '1')
     BEGIN
         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@SprintId = '00000000-0000-0000-0000-000000000000') SET @SprintId = NULL

         IF(@SearchText = '') SET @SearchText = NULL

		 IF(@UserStoryName = '') SET @UserStoryName = NULL

		 IF(@VersionName = '')SET @VersionName = NULL

		 IF(@UserStoryName IS NOT NULL)SET @UserStoryName =  '%'+ @UserStoryName + '%' 
		   IF(@VersionName IS NOT NULL)SET @VersionName =  '%'+ @VersionName + '%' 


		 IF (@IsArchived IS NULL) SET @IsArchived = 0

		 IF (@IsParked IS NULL) SET @IsParked = 0

        CREATE TABLE #UserStory
            (
                Id UNIQUEIDENTIFIER
            )
      IF (@UserStoryIdsXml IS NOT NULL)
          BEGIN
            INSERT INTO #UserStory(Id)
            SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
            FROM @UserStoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
     END

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

		   CREATE TABLE #ParentWorkItems
		   (
		   Id UNIQUEIDENTIFIER
		   )

		   
		   INSERT INTO #ParentWorkItems
		   SELECT US2.ParentUserStoryId FROM UserStory US2 INNER JOIN Sprints S ON S.Id = US2.SprintId
		                                                   LEFT JOIN #UserStoryType UST ON UST.Id = US2.UserStoryTypeId
				                                           LEFT JOIN #BugPriorityId BP ON UST.Id = US2.BugPriorityId
				                                           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US2.Id  AND BCU.InActiveDateTime IS  NULL
				                                           LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
				                                           LEFT JOIN #DependencyOnUser DU ON DU.Id= US2.DependencyUserId
														   LEFT JOIN #ProjectFeatures PFF ON PFF.Id = US2.ProjectFeatureId
														   LEFT JOIN #UserStoryStatusIds USS ON USS.Id = US2.UserStoryStatusId
														   LEFT JOIN #ProjectIds P ON P.Id  = US2.ProjectId
														   
										  WHERE (@OwnerUserIds IS NULL OR (OwnerUserId IN (SELECT Id FROM #OwnerUserIds) OR (US2.OwnerUserId IS NULL AND '00000000-0000-0000-0000-000000000000' IN (SELECT Id FROM #OwnerUserIds WHERE Id = '00000000-0000-0000-0000-000000000000'))))
                                            AND (@UserStoryStatusIds IS NULL OR UserStoryStatusId IN (SELECT Id FROM #UserStoryStatusIds))
										   	AND (@UserStoryTypeIds IS NULL OR UST.Id IS NOT NULL)
							                AND (@BugPriorityIds IS NULL OR BP.Id IS NOT NULL)
							                AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL)
							                AND (@DependencyUserIds IS NULL OR DU.Id IS NOT NULL)
											AND (@ProjectFeatureIds IS NULL OR PFF.Id IS NOT NULL)
											AND (@ProjectIds IS NULL OR P.Id IS NOT NULL)
											AND (@UserStoryName IS NULL OR US2.UserStoryName LIKE  @UserStoryName)
											AND (@SprintName IS NULL OR S.SprintName LIKE @SprintName)
											AND (@CreatedDateFrom IS NULL OR CAST(US2.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE))
							                AND (@CreatedDateTo IS NULL OR CAST(US2.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE))
							                AND (@UpdatedDateFrom IS NULL OR CAST(US2.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE))
							                AND (@UpdatedDateTo IS NULL OR CAST(US2.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE))
							                
											AND (@DeadLineDateFrom IS NULL OR CAST(US2.DeadLineDate AS DATE) <= CAST(@DeadLineDateFrom AS DATE))
							                AND (@DeadLineDateTo IS NULL OR CAST(US2.DeadLineDate AS DATE) <= CAST(@DeadLineDateTo AS DATE))
										    AND (@WorkItemTags IS NULL OR  EXISTS (SELECT [Value] FROM [dbo].[ufn_stringsplit](US2.Tag,',') WHERE [Value] In (SELECT Tag FROM #WorkItemTags)))
											AND  (US2.UserStoryName LIKE @UserStoryName  OR @UserStoryName IS NULL)
											AND  (US2.[VersionName] LIKE  @VersionName OR @VersionName IS NULL)
										GROUP BY US2.ParentUserStoryId

          SELECT US.OwnerUserId
                 ,OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS OwnerName
                 ,OU.ProfileImage AS OwnerProfileImage
                 ,DU.ProfileImage AS DependencyProfileImage
                 ,DU.FirstName + ' ' + ISNULL(DU.SurName,'') AS DependencyName
                 ,US.[EstimatedTime]
                 ,US.[UserStoryName]
                 ,US.[DependencyUserId]
                 ,US.[Order]
                 ,US.[UserStoryStatusId]
                 ,US.Id AS UserStoryId
                 ,US.UserStoryTypeId
                 ,US.TimeStamp
				 ,US.UserStoryUniqueName
				 ,US.CreatedDateTime
                 ,P.Id AS ProjectId
                 ,S.Id AS SprintId
				 ,S.SprintStartDate
				 ,S.SprintEndDate
				 ,S.IsReplan
				 ,P.ProjectName
				 ,@EnableSprints AS IsSprintsConfiguration
				 ,@EnableTestRepo AS IsEnableTestRepo
				 ,@EnableBugBoards AS IsEnableBugBoards
				 ,@EnableStartStop AS IsEnableStartStop
                 ,S.SprintName
				 ,S.SprintStartDate
				 ,S.InActiveDateTime AS SprintInActiveDateTime
				 ,S.IsComplete
				 ,S.SprintEndDate
				 ,S.SprintUniqueName
				 ,US.[Description]
				 ,UST.UserStoryTypeName
				 ,UST.Color AS UserStoryTypeColor
				 ,UST.IsLogTimeRequired
				 ,UST.IsQaRequired
				 ,USS.Status AS UserStoryStatusName
				 ,USS.StatusHexValue AS UserStoryStatusColor
				 ,US.InActiveDateTime AS UserStoryArchivedDateTime
				 ,US.ParkedDateTime AS UserStoryParkedDateTime
				 ,US.ParentUserStoryId
				 ,US1.UserStoryName ParentUserStoryName
				 ,S1.SprintName ParentSprintName
				 ,S1.Id  ParentUserStoryGoalId
				 ,US.SprintEstimatedTime
				 ,USS.TaskStatusId
				 ,TS.[Order] AS TaskStatusOrder
				 ,US.Tag
				 ,US.ParentUserStoryId
				 ,US.GoalId
				 ,US.BugPriorityId
				 ,BP.PriorityName AS BugPriority
				 ,BP.Color AS BugPriorityColor
				 ,BP.Icon
                 ,BP.[Description] AS BugPriorityDescription
				 ,OU.ProfileImage AS OwnerProfileImage
				 ,BU.UserId AS BugCausedUserId
                 ,BUU.FirstName + ' '  + ISNULL(BUU.SurName,'') AS BugCausedUserName
                 ,BUU.ProfileImage AS BugCausedUserProfileImage
				 ,PF.ProjectFeatureName
				 ,US.TestSuiteSectionId
				 ,US.TestCaseId
				 ,US.ProjectFeatureId
				 ,US.VersionName
				 ,STUFF(( SELECT  '','' + U.FirstName + CONCAT(' ',U.SurName) + ' : ' + CONVERT(NVARCHAR,ROUND(SUM(UST.SpentTimeInMin) * 1.0 / 60.0,0)) + ' hr'
                                                     FROM [UserStorySpentTime] UST
                                                          INNER JOIN [User] U ON U.Id = UST.UserId
		                                             WHERE UST.UserStoryId = US.Id
													 GROUP BY U.FirstName ,U.SurName,U.Id
                                                     FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS UserSpentTime
				 ,G.GoalShortName
				 ,(SELECT SUM(ISNULL(US1.EstimatedTime,0)) FROM UserStory US1 WHERE ParentUserStoryId = US.Id AND US1.SprintId = US.SprintId  
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (US1.InActiveDateTime IS NOT NULL OR US1.ArchivedDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (US1.InActiveDateTime IS NULL AND US1.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR (@IsParked = 1 AND US1.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US1.ParkedDateTime IS NULL))
							                                 AND P.InactiveDateTime IS NULL) TotalEstimatedTime
				,(SELECT SUM(ISNULL(US11.SprintEstimatedTime,0)) FROM UserStory US11 WHERE ParentUserStoryId = US.Id AND US11.SprintId = US.SprintId  
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (US11.InActiveDateTime IS NOT NULL OR US11.ArchivedDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (US11.InActiveDateTime IS NULL AND US11.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR (@IsParked = 1 AND US11.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US11.ParkedDateTime IS NULL))
							                                 AND P.InactiveDateTime IS NULL) TotalSprintEstimatedTime
				 ,BT.BoardTypeUIId
				 ,BT.Id AS BoardTypeId
				 ,BTW.WorkFlowId
				 ,BT.IsBugBoard
				 ,BT.IsSuperAgileBoard
				 ,BT.IsDefault
				 ,S.TestSuiteId
				 ,1 AS IsFromSprints
				 ,US.RAGStatus
				 ,TSS.SectionName AS TestSuiteSectionName,
				  @IsAutoLog AS IsAutoLog
				   ,(select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) AutoLog,

						 (select top(1) CAST(USPt.StartTime AS DATETIME)  from UserStorySpentTime USPt
						 where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy) StartTime,
						 (select top(1) CAST(USPt.EndTime AS DATETIME)  from UserStorySpentTime USPt
						where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy) EndTime
				 ,(SELECT COUNT(1)
										  FROM [UserStory] US2 WITH (NOLOCK)  
										       INNER JOIN UserStoryType UST  WITH(NOLOCK) ON UST.Id = US2.UserStoryTypeId 
											              AND UST.InActiveDateTime IS NULL 
														  AND US2.InactiveDateTime IS NULL AND US2.[ArchivedDateTime] IS NULL AND US2.[ParkedDateTime] IS NULL
											   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US2.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
										       INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId AND TS.[Order] NOT IN (4,6)
											   INNER JOIN [Sprints]S WITH(NOLOCK) ON S.Id = US2.SprintId AND S.InActiveDateTime IS NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
											   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US2.TestCaseId AND TC.InActiveDateTime IS NULL
											   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US2.BugPriorityId AND BP.InactiveDateTime IS NULL
										       LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US2.ParentUserStoryId AND US1.InActiveDateTime IS NULL
										       LEFT JOIN [Sprints]S1 WITH(NOLOCK) ON S1.Id = US1.SprintId AND S1.InActiveDateTime IS NULL AND (S1.IsComplete IS NULL OR S1.IsComplete = 0)
										       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US2.TestCaseId AND USS.InActiveDateTime IS NULL
                                                WHERE US.Id = US2.ParentUserStoryId  AND (S.Id <> S1.Id) AND (US2.TestCaseId IS NULL OR USS.TestCaseId IS NOT NULL)) AS BugsCount
				 ,TotalCount = COUNT(1) OVER()
				 ,(SELECT USINNER.Id AS userStoryId,
				          USINNER.UserStoryName AS userStoryName,
						  P.ProjectName As projectName,
						  P.IsDateTimeConfiguration,
						  @EnableSprints AS isSprintsConfiguration,
						  @EnableTestRepo AS isEnableTestRepo,
						  @EnableBugBoards AS isEnableBugBoard,
						  P.Id As projectId,
						  S.Id AS sprintId,
						  S.IsReplan AS isReplan,
						  G.GoalShortName AS goalShortName,
						  S.SprintStartDate AS sprintStartDate,
				          S.SprintEndDate AS sprintEndDate,
						  1 AS isFromSprints,
						  DUINNER.FirstName + ' ' + ISNULL(DUINNER.SurName,'') AS dependencyName,
						  OUINNER.FirstName + ' ' + ISNULL(OUINNER.SurName,'')AS ownerName,
						  ISNULL(USInner.EstimatedTime,0) estimatedTime,
						  USINNER.TimeStamp AS timeStamp,
						  USINNER.ParentUserStoryId AS parentUserStoryId,
						  USINNER.InActiveDateTime AS userStoryArchivedDateTime,
						  USINNER.ParkedDateTime AS userStoryParkedDateTime,
						  USINNER.CreatedDateTime,
						  USSINNER.[Status] AS userStoryStatusName,
						  USSINNER.StatusHexValue AS userStoryStatusColor,
						  USINNER.UserStoryTypeId AS userStoryTypeId,
						  USSINNER.TaskStatusId AS taskStatusId,
						  TSINNER.[Order] AS taskStatusOrder,
						  USINNER.UserStoryStatusId AS userStoryStatusId,
						  USINNER.OwnerUserId AS ownerUserId,
						  USINNER.DependencyUserId AS dependencyUserId,
						  OUINNER.ProfileImage AS ownerProfileImage,
						  USInner.[Order] AS [order],
						  USINNER.Tag AS tag,
						  USTINNER.UserStoryTypeName AS userStoryTypeName,
						  USTINNER.Color AS userStoryTypeColor,
						  USINNER.UserStoryUniqueName AS userStoryUniqueName,
						  USINNER.SprintEstimatedTime AS sprintEstimatedTime,
				          @EnableBugBoards AS isEnableBugBoards,
				          @EnableStartStop AS isEnableStartStop,
						  BT.BoardTypeUIId AS boardTypeUIId,
				          BT.Id  AS boardTypeId,
				          BTW.WorkFlowId AS workFlowId,
						  BT.IsBugBoard AS isBugBoard,
						  BT.IsSuperAgileBoard AS isSuperAgileBoard,
						  BP.PriorityName AS bugPriority,
				          BP.Color AS bugPriorityColor,
						  USINNER.TestSuiteSectionId AS testSuiteSectionId,
				          USINNER.TestCaseId AS testCaseId,
                          BP.[Description] AS bugPriorityDescription,
				          BUINNER.UserId AS bugCausedUserId,
				          PFINNER.ProjectFeatureName AS projectFeatureName,
						  S.TestSuiteId AS testSuiteId,
						  TSSINNER.SectionName AS testSuiteSectionName,
						  USINNER.RAGStatus AS rAGStatus,
						  @IsAutoLog AS isAutoLog,
						  USINNER.VersionName AS versionName,
						    (SELECT COUNT(1)
										  FROM [UserStory]US2 WITH (NOLOCK)  
										       INNER JOIN UserStoryType UST  WITH(NOLOCK) ON UST.Id = US2.UserStoryTypeId 
											              AND UST.InActiveDateTime IS NULL 
														  AND US2.InactiveDateTime IS NULL AND US2.[ArchivedDateTime] IS NULL AND US2.[ParkedDateTime] IS NULL
											   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US2.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
										       INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId AND TS.[Order] NOT IN (4,6)
											   INNER JOIN [Sprints]S WITH(NOLOCK) ON S.Id = US2.SprintId AND S.InActiveDateTime IS NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
											   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US2.TestCaseId AND TC.InActiveDateTime IS NULL
											   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US2.BugPriorityId AND BP.InactiveDateTime IS NULL
										       LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US2.ParentUserStoryId AND US1.InActiveDateTime IS NULL
										       LEFT JOIN [Sprints]S1 WITH(NOLOCK) ON S1.Id = US1.SprintId AND S1.InActiveDateTime IS NULL AND (S1.IsComplete IS NULL OR S1.IsComplete = 0)
										       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US2.TestCaseId AND USS.InActiveDateTime IS NULL
                                                WHERE USInner.Id = US2.ParentUserStoryId AND (S.Id <> S1.Id) AND (US2.TestCaseId IS NULL OR USS.TestCaseId IS NOT NULL)) AS bugsCount,
												
						 (select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) autoLog,

						 (select top(1) CAST(USPt.StartTime AS DATETIME)  from UserStorySpentTime USPt
						 where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy) startTime,
						 (select top(1) CAST(USPt.EndTime AS DATETIME)  from UserStorySpentTime USPt
						where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy) endTime
						
				    FROM [dbo].[UserStory]USINNER
					     INNER JOIN [UserStoryType]USTINNER WITH(NOLOCK) ON USTINNER.Id = USINNER.UserStoryTypeId
						 LEFT JOIN [UserStoryStatus] USSINNER WITH (NOLOCK) ON USSINNER.Id = USINNER.UserStoryStatusId 
                         LEFT JOIN [TaskStatus] TSINNER WITH (NOLOCK) ON  TSINNER.Id = USSINNER.TaskStatusId
						 LEFT JOIN [dbo].[User] OUINNER WITH (NOLOCK) ON OUINNER.Id = USINNER.OwnerUserId 
                         LEFT JOIN [dbo].[User] DUINNER WITH (NOLOCK) ON DUINNER.Id = USINNER.DependencyUserId 
						 LEFT JOIN [dbo].[BugCausedUser] BUINNER WITH (NOLOCK) ON BUINNER.UserStoryId = USINNER.Id AND BUINNER.InActiveDateTime IS NULL
				         LEFT JOIN [dbo].[ProjectFeature] PFINNER WITH (NOLOCK) ON PFINNER.Id = USINNER.ProjectFeatureId
				         LEFT JOIN [dbo].[BugPriority] BPINNER WITH (NOLOCK) ON BPINNER.Id = USINNER.BugPriorityId
						 LEFT JOIN [TestSuite]TS2INNER ON TS2INNER.Id = S.TestSuiteId AND TS2INNER.InActiveDateTime IS NULL
			             LEFT JOIN [dbo].[TestSuiteSection] TSSINNER WITH (NOLOCK)  ON TSSINNER.Id = USINNER.TestSuiteSectionId AND TSSINNER.InActiveDateTime IS NULL AND TS2INNER.Id = TSSINNER.TestSuiteId
						 WHERE P.CompanyId = @CompanyId 
						 AND (@SprintId IS NULL OR USINNER.SprintId = @SprintId)
						 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND USINNER.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND USINNER.InActiveDateTime IS NULL))
			             AND (@IsParked IS NULL OR (@IsParked = 1 AND USINNER.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND USINNER.ParkedDateTime IS NULL))
				         AND  P.InactiveDateTime IS NULL
						 AND USINNER.ParentUserStoryId = US.Id AND USINNER.SprintId = US.SprintId
						 ORDER BY USINNER.[Order] ASC
						 FOR JSON PATH,ROOT('ChildUserStories')) AS SubUserStories
						 ,@IsAutoLog AS IsAutoLog
						 ,(select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) AutoLog,
								  (select top(1) CAST(USPt.StartTime AS DATETIME)  from UserStorySpentTime USPt
						 where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy) StartTime,
						 (select top(1) CAST(USPt.EndTime AS DATETIME)  from UserStorySpentTime USPt
						where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy) EndTime
          FROM  UserStory US
                INNER JOIN Sprints S ON S.Id = US.SprintId 
                INNER JOIN Project P ON P.Id = S.ProjectId AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL AND P.IsSprintsConfiguration = 1
				            AND P.Id IN (SELECT ProjectId  FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
				INNER JOIN BoardType BT ON BT.Id = S.BoardTypeId
				LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = BT.Id
                LEFT JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId
				INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
				LEFT JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
                LEFT JOIN [User] OU ON OU.Id = US.OwnerUserId 
                LEFT JOIN [User] DU ON DU.Id = US.DependencyUserId 
				LEFT JOIN [dbo].[BugCausedUser] BU WITH (NOLOCK) ON BU.UserStoryId = US.Id AND BU.InActiveDateTime IS NULL
				LEFT JOIN [dbo].[User] BUU WITH (NOLOCK) ON BUU.Id = BU.UserId
				LEFT JOIN [dbo].[ProjectFeature] PF WITH (NOLOCK) ON PF.Id = US.ProjectFeatureId
				LEFT JOIN [dbo].[BugPriority] BP WITH (NOLOCK) ON BP.Id = US.BugPriorityId
				LEFT JOIN [dbo].[Goal]G WITH (NOLOCK) ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN [TestSuite]TS2 ON TS2.Id = S.TestSuiteId AND TS2.InActiveDateTime IS NULL
			    LEFT JOIN [dbo].[TestSuiteSection] TSS WITH (NOLOCK)  ON TSS.Id = US.TestSuiteSectionId AND TSS.InActiveDateTime IS NULL AND TS2.Id = TSS.TestSuiteId
				LEFT JOIN UserStory US1 ON US1.Id= US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
				LEFT JOIN Sprints  S1 ON S1.Id = US1.SprintId
                LEFT JOIN #UserStory UsInner ON UsInner.Id = US.Id
				LEFT JOIN #UserStoryType UST1 ON UST1.Id = US.UserStoryTypeId
				LEFT JOIN #BugPriorityId BP1 ON BP1.Id = US.BugPriorityId
				LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id  AND BCU.InActiveDateTime IS  NULL
				LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
				LEFT JOIN #DependencyOnUser DU1 ON DU1.Id= US.DependencyUserId
				LEFT JOIN #ProjectFeatures PFF ON PFF.Id = US.ProjectFeatureId
				LEFT JOIN #UserStoryStatusIds USS1 ON USS1.Id = US.UserStoryStatusId
				LEFT JOIN #ParentWorkItems PW ON PW.Id = US.Id
				LEFT JOIN #ProjectIds P1 ON P1.Id = US.ProjectId
				LEFT JOIN #SprintResponsiblePersonIds SPR ON SPR.Id = S.SprintResponsiblePersonId
        WHERE  ((US.ParentUserStoryId IS NULL AND @UserStoryId IS NULL AND @ParentUserStoryId IS NULL AND @ProjectId IS NULL) 
		         OR (@UserStoryId IS NOT NULL AND @UserStoryId = US.Id) 
				 OR (@ParentUserStoryId IS NOT NULL AND US.ParentUserStoryId = @ParentUserStoryId)
				 OR (@ProjectId IS NOT NULL OR @ProjectId = S.ProjectId))
		      AND (@SprintId IS NULL OR @SprintId = S.Id)
			AND (@sprintUniqueName IS NULL OR US.UserStoryUniqueName = @sprintUniqueName)
			  AND (@UserStoryTypeIds IS NULL OR UST1.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@BugPriorityIds IS NULL OR BP1.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@DependencyUserIds IS NULL OR DU1.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@UserStoryStatusIds IS NULL OR USS1.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@ProjectIds IS NULL OR P1.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@SprintResponsiblePersonIds IS NULL OR SPR.Id IS NOT NULL)
			  AND (@SprintStartDate IS NULL OR CAST(S.SprintStartDate AS date) >= CAST(@SprintStartDate AS date))
			  AND (@sprintUniqueName IS NULL OR US.UserStoryUniqueName = @sprintUniqueName)
			  AND (@DeadLineDateFrom IS NULL OR CAST(US.DeadLineDate AS DATE) <= CAST(@DeadLineDateFrom AS DATE)  )
			  AND (@DeadLineDateTo IS NULL OR CAST(US.DeadLineDate AS DATE) <= CAST(@DeadLineDateTo AS DATE) OR PW.Id IS NOT NULL)
			  AND (@CreatedDateFrom IS NULL OR CAST(US.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE) OR PW.Id IS NOT NULL)
			  AND (@CreatedDateTo IS NULL OR CAST(US.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE) OR PW.Id IS NOT NULL)
			  AND (@UpdatedDateFrom IS NULL OR CAST(US.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE) OR PW.Id IS NOT NULL)
			  AND (@UpdatedDateTo IS NULL OR CAST(US.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE) OR PW.Id IS NOT NULL)
			  AND  (@VersionName IS NULL OR US.[VersionName] LIKE  @VersionName OR PW.Id IS NOT NULL)
			  AND (@UserStoryName IS NULL OR @UserStoryName = US.UserStoryName)
			  AND ((ISNULL(@IsActiveSprints,0) = 0 OR (S.InActiveDateTime IS  NULL AND ISNULL(S.IsReplan,0) = 0 AND S.SprintStartDate IS NOT NULL)) 
			     AND (ISNULL(@IsReplanSprints,0) = 0 OR S.IsReplan = 1) 
				 AND (ISNULL(@IsBacklogSprints,0) = 0 OR S.SprintStartDate IS NULL)
				 AND (ISNULL(@IsDeleteSprints,0) = 0 OR S.InActiveDateTime IS NULL)
				 AND (ISNULL(@IsCompletedSprints,0) = 0 OR S.IsComplete = 1))
			  AND (@ProjectFeatureIds IS NULL OR PFF.Id IS NOT NULL OR PW.Id IS NOT NULL)
			  AND (@SprintName IS NULL OR S.SprintName LIKE @SprintName OR PW.Id IS NOT NULL)
			  AND (@OwnerUserIds IS NULL OR PW.Id IS NOT NULL OR (US.OwnerUserId IN (SELECT Id FROM #OwnerUserIds) OR (US.OwnerUserId IS NULL AND '00000000-0000-0000-0000-000000000000' IN (SELECT Id FROM #OwnerUserIds WHERE Id = '00000000-0000-0000-0000-000000000000'))))
              AND (@UserStoryIdsXml IS NULL OR UsInner.Id IS NOT NULL)
              AND (@IsArchived IS NULL OR (@IsArchived = 1 AND US.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND US.InActiveDateTime IS NULL))
			  AND (@IsParked IS NULL OR (@IsParked = 1 AND US.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US.ParkedDateTime IS NULL))
              AND (@SearchText IS NULL OR US.UserStoryName LIKE @SearchText
                                       OR OU.FirstName + ' ' + ISNULL(OU.SurName,'') LIKE @SearchText
                                       OR S.SprintName LIKE @SearchText)

    END
     ELSE
        RAISERROR(@HavePermission,11,1)
     END TRY
     BEGIN CATCH
           THROW
    END CATCH
END

