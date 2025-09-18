-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the User Stories By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_SearchUserStories_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@isArchived = 0,@PageSize = 1000,@IsForUserStoryoverview=1
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchUserStories_New]
(
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectName NVARCHAR(250) = NULL,
    @GoalId UNIQUEIDENTIFIER = NULL,
    @UserStoryName NVARCHAR(250) = NULL,
    @EstimatedTime DATETIME = NULL,
    @DeadLineDate DATETIMEOFFSET = NULL,
    @OwnerUserId UNIQUEIDENTIFIER = NULL,
    @DependencyUserId UNIQUEIDENTIFIER = NULL,
    @Order INT = NULL,
    @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
    @ActualDeadLineDate DATETIME = NULL,
    @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
    @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
    @ProjectFeatureId UNIQUEIDENTIFIER = NULL,
    @IsParked BIT = NULL,
    @IsArchived BIT = NULL,
    @SearchText NVARCHAR(100) = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)= NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @DependencyText NVARCHAR(250) = NULL, -- Filter to returning fewer columns for dashboard reports
    @DeadLineDateFrom DATETIME = NULL,
    @DeadLineDateTo DATETIME = NULL,
	@UserStoryUniqueName NVARCHAR(100) = NULL,
    @IncludeArchived BIT = NULL,
    @IncludeParked BIT = NULL,
	@IsMyWorkOnly BIT = NULL,
	@IsActiveGoalsOnly BIT = NULL,
    @TeamMemberIdsXml  XML =NULL,
	@IsStatusMultiselect BIT = NULL,
	@IsTracked BIT = NULL,
	@IsProductive BIT = NULL,
	@IsGoalsPage BIT = NULL,
	@IsForFilters BIT = NULL,
    @UserStoryStatusIdsXml XML = NULL,
	@UserStoryTagsXml XML = NULL,
	@GoalStatusId UNIQUEIDENTIFIER = NULL,
	@GoalResponsiblePersonId UNIQUEIDENTIFIER = NULL,
	@EntityId UNIQUEIDENTIFIER = NULL,
	@OwnerUserIdsXml XML = NULL,
    @UserStoryIdsXml XML = NULL,  
	@GoalTags NVARCHAR(250) = NULL,
	@IsForUserStoryoverview BIT = NULL, -- Filter to returning fewer columns for user stories overview in the project module
	@GoalName NVARCHAR(500) = NULL,
	@UserStoryTags NVARCHAR(250) = NULL,
    @ProjectIdsXml XML = NULL,
    @GoalStatusIdsXml XML = NULL,
    @GoalResponsiblePersonIdsXml XML = NULL,
	@IsAction BIT = NULL,
	@IsOnTrack BIT = NULL,
	@VersionName NVARCHAR(500) = NULL,
    @UserStoryTypeIdsXml XML = NULL,
    @BugCausedUserIds XML= NULL,
    @DependencyUserIds XML= NULL,
    @BugPriorityIdsXml XML = NULL,
    @ProjectFeatureIds XML= NULL,
	@UpdatedDateFrom DATETIME = NULL,
    @UpdatedDateTo DATETIME = NULL,
	@CreatedDateFrom DATETIME = NULL,
    @CreatedDateTo DATETIME = NULL,
	@IsNotOnTrack BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
        DECLARE @SearchSqlScript NVARCHAR(MAX)
        
		IF(@IsOnTrack IS NULL) SET @IsOnTrack = 0

		IF(@IsNotOnTrack IS NULL) SET @IsNotOnTrack = 0

        DECLARE @IsBothTracked BIT = CASE WHEN @IsOnTrack = 1 AND @IsNotOnTrack = 1 THEN 1 ELSE 0 END

        IF (@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL
        
        IF (@GoalId = '00000000-0000-0000-0000-000000000000') SET @GoalId = NULL
        
		IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
        
        IF (@UserStoryName = '') SET @UserStoryName = NULL

		IF (@VersionName = '') SET @VersionName = NULL
       
		IF (@ProjectName = '') SET @ProjectName = NULL
        
		--IF(@IsArchived IS NULL) SET @IsArchived = 0

		IF(@IsForUserStoryoverview IS NULL) SET @IsForUserStoryoverview = 0

		IF(@IncludeArchived = 1) SET @IsArchived = NULL
		
		IF(@IncludeParked = 1) SET @IsParked = NULL
        
		IF (@DependencyText = '') SET @DependencyText = NULL
		
		IF (@IsAction IS NULL) SET @IsAction = 0

		IF(@IsGoalsPage IS NULL) SET @IsGoalsPage = 0
		IF(@IsForFilters IS NULL) SET @IsForFilters = 0

		IF (@ParentUserStoryId = '00000000-0000-0000-0000-000000000000') SET @ParentUserStoryId = NULL
        
        IF (@OwnerUserId = '00000000-0000-0000-0000-000000000000') SET @OwnerUserId = NULL
        
        IF (@DependencyUserId = '00000000-0000-0000-0000-000000000000') SET @DependencyUserId = NULL
        
        IF (@UserStoryStatusId = '00000000-0000-0000-0000-000000000000') SET @UserStoryStatusId = NULL
        
        IF (@UserStoryTypeId = '00000000-0000-0000-0000-000000000000') SET @UserStoryTypeId = NULL
        
        IF (@ProjectFeatureId = '00000000-0000-0000-0000-000000000000') SET @ProjectFeatureId = NULL

		IF (@GoalStatusId = '00000000-0000-0000-0000-000000000000') SET @GoalStatusId = NULL
        
        IF (@SortBy IS NULL OR @SortBy = '') 
		      SET @SortBy = 'US.[Order]'
		ELSE 
		      SET @SortBy = '[' + @SortBy + ']'
         
        IF(@SortDirection IS NULL OR @SortDirection = '') SET @SortDirection = 'ASC'
            
        IF (@PageSize > 500) SET @PageSize = 500

		IF (@SearchText = '') SET @SearchText = NULL

		IF (@GoalName = '') SET @GoalName = NULL 

		IF (@GoalName IS NOT NULL)SET @GoalName = '%' + RTRIM(LTRIM(@GoalName)) + '%'

		IF (@VersionName IS NOT NULL)SET @VersionName = '%' + RTRIM(LTRIM(@VersionName)) + '%'

		IF (@UserStoryName IS NOT NULL)SET @UserStoryName = '%' + RTRIM(LTRIM(@UserStoryName)) + '%'

		IF (@UserStoryTags = '') SET @UserStoryTags = NULL 

		IF (@GoalTags = '') SET @GoalTags = NULL 

		IF (@UserStoryTags IS NOT NULL)SET @UserStoryTags = '%' + RTRIM(LTRIM(@UserStoryTags)) + '%'

		IF (@GoalTags IS NOT NULL)SET @GoalTags = '%' + RTRIM(LTRIM(@GoalTags)) + '%'
        
		DECLARE @Currentdate DATETIME = GETDATE()
        
		DECLARE @DateTo DATETIME = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Currentdate), CAST(@Currentdate AS DATE))
       
		DECLARE @IsAutoLog BIT =  (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%') 

	    DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
		
		DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		
		DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

		DECLARE @EnableStartStop BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%')

          
	    DECLARE @DateFrom DATETIME = DATEADD(dd, -(DATEPART(dw, @DateTo)-1), CAST(@DateTo AS DATE))
       
		SET @SearchText = CASE WHEN @SearchText LIKE 'tag:%' THEN   ('%' + (SELECT SUBSTRING(@SearchText,5,LEN(@SearchText))) + '%') ELSE   ('%'+ @SearchText+'%') END 

		DECLARE @ISBugBoard BIT = (SELECT ISBugBoard From [dbo].[BoardType]BT 
		                           INNER JOIN [dbo].[Goal]G ON G.BoardTypeId = BT.Id WHERE BT.CompanyId = @CompanyId AND G.Id = @GoalId
								   )
       
        DECLARE @Skip INT = ((@PageNumber - 1) * @PageSize)

		 CREATE TABLE #OwnerUser1
		 (
		 	Id UNIQUEIDENTIFIER
		 )

		 IF(@OwnerUserIdsXml IS NOT NULL AND @IsGoalsPage =1)
		 BEGIN
		  
		  INSERT INTO #OwnerUser1(Id)
		  	SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
		  	FROM @OwnerUserIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
		  
		  END

		 CREATE TABLE #UserStoryStatus1
		 (
		 	Id UNIQUEIDENTIFIER
		 )

	     CREATE TABLE #UserStoryTypes
           (
                Id UNIQUEIDENTIFIER
           )

		    CREATE TABLE #BugPriorityId
           (
                Id UNIQUEIDENTIFIER
           )

		    CREATE TABLE #BugCausedUser
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
			Tag NVARCHAR(MAX)
			)

		    IF(@DependencyUserIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #DependencyOnUser(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @DependencyUserIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		   IF(@BugPriorityIdsXml IS NOT NULL AND @IsGoalsPage = 1)
           BEGIN
                
                INSERT INTO #BugPriorityId(Id)
                SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @BugPriorityIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END
		    IF(@BugCausedUserIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #BugCausedUser(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @BugCausedUserIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		   IF(@UserStoryTypeIdsXml IS NOT NULL AND @IsGoalsPage = 1)
           BEGIN
                
                INSERT INTO #UserStoryTypes(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @UserStoryTypeIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		      IF(@ProjectFeatureIds IS NOT NULL)
           BEGIN
                
                INSERT INTO #ProjectFeatures(Id)
                SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
                FROM @ProjectFeatureIds.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

           END

		 IF(@UserStoryStatusIdsXml IS NOT NULL AND @IsGoalsPage =1)
		 BEGIN
		 	INSERT INTO #UserStoryStatus1(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @UserStoryStatusIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
		 END

		  IF(@UserStoryTagsXml IS NOT NULL)
		 BEGIN
		 	INSERT INTO #WorkItemTags(Tag)
				SELECT X.Y.value('(text())[1]', 'NVARCHAR(250)')
				FROM @UserStoryTagsXml.nodes('/GenericListOfString/ListItems/string') X(Y)

			
				
		 END

		
        

        
		SET @SearchSqlScript = N'SELECT US.Id AS UserStoryId,
									   (SELECT AC.Id FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id = US.AuditConductQuestionId) ConductId,
		    						   (SELECT ACQ.QuestionId FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id = US.AuditConductQuestionId) QuestionId,
									   (SELECT ACQ.Id FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id = US.AuditConductQuestionId) AuditConductQuestionId,
									   (SELECT ACQ.QuestionName FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id = US.AuditConductQuestionId) QuestionName,
		                                US.UserStoryName,
										US.ReferenceId,
										US.ReferenceTypeId,
										US.[Order],
										US.ActionCategoryId,
                                        ACC.ActionCategoryName,
                                        P.ProjectName As ProjectName,
										P.IsDateTimeConfiguration,
										@EnableSprints As IsSprintsConfiguration,
										@EnableTestRepo AS IsEnableTestRepo,
										@EnableBugBoards AS IsEnableBugBoards,
										@EnableStartStop AS IsEnableStartStop,
										P.Id As ProjectId,
										G.Id AS GoalId,
										US.SprintId,
                                        G.GoalName,
										ISNULL(G.GoalUniqueName,'''') AS GoalUniqueName,
										S.SprintName,
										S.SprintStartDate,
										S.SprintEndDate,
										S.IsReplan,
										G.OnboardProcessDate,
										CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN G.BoardTypeId
										     WHEN US.GoalId IS NOT NULL THEN G.BoardTypeId
											 WHEN US.SprintId IS NOT NULL THEN S.BoardTypeId
										END AS BoardTypeId,
                                        DU.FirstName + '' '' + ISNULL(DU.SurName,'''') AS DependencyName,
                                        OU.FirstName + '' '' + ISNULL(OU.SurName,'''') AS OwnerName,
										OU.ProfileImage AS OwnerProfileImage,
										OU.Id AS OwnerUserId,
                                        ISNULL(US.EstimatedTime,0) EstimatedTime,
										US.TimeStamp,
										@IsAutoLog AS IsAutoLog ,
										TotalCount = COUNT(1) OVER(),
                                        US.DeadLineDate,	
										US.StartDate UserStoryStartDate,
                                        BTW.WorkFlowId,
										CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN BT.BoardTypeUIId
										     WHEN US.GoalId IS NOT NULL THEN BT.BoardTypeUIId
											 WHEN US.SprintId IS NOT NULL THEN BTS.BoardTypeUIId
										END AS BoardTypeUiId,
										CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN BT.IsBugBoard
										     WHEN US.GoalId IS NOT NULL THEN BT.IsBugBoard
											 WHEN US.SprintId IS NOT NULL THEN BTS.IsBugBoard
										END AS IsBugBoard,
										CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN BT.IsSuperAgileBoard
										     WHEN US.GoalId IS NOT NULL THEN BT.IsSuperAgileBoard
											 WHEN US.SprintId IS NOT NULL THEN BTS.IsSuperAgileBoard
										END AS IsSuperAgileBoard,
										WFS.Id AS WorkFlowStatusId,
										(select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) AutoLog,
								  (SELECT TOP 1 BreakType From UserStorySpentTime USPt  where USPt.UserStoryId = US.Id AND  USPt.UserId = @OperationsPerformedBy
								  ORDER BY USPt.TimeStamp DESC
								  ) BreakType,
								  US.IsBacklog,
								  US.RAGStatus,
								  UST.IsBug,
								  TS.Id AS TaskStatusId,
								  US.[Description],
								  TZ.TimeZoneAbbreviation CreatedOnTimeZoneAbbreviation ,
								  TZ.TimeZoneAbbreviation DeadLineTimeZoneAbbreviation,
								  
								  CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN 0
										     WHEN US.GoalId IS NOT NULL THEN 0
											 WHEN US.SprintId IS NOT NULL THEN 1 END AS IsFromSprints,
								    (select top(1) CAST(USPt.StartTime AS DATETIME)  from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy) StartTime,
									   (select top(1) USPt.EndTime  from UserStorySpentTime USPt
								  where USPt.UserStoryId = US.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy) EndTime'
                          
		IF(@IsForUserStoryoverview = 1)  
		BEGIN

				SET @SearchSqlScript = @SearchSqlScript + N' ,US.InActiveDateTime AS UserStoryArchivedDateTime,
		         US.CreateddateTime AS CreatedDate,US.CreateddateTime, US.UpdatedDateTime,
											STUFF(( SELECT  '','' + U.FirstName + CONCAT('' '',U.SurName) + '' : '' + CONVERT(NVARCHAR,ROUND(SUM(UST.SpentTimeInMin) * 1.0 / 60.0,2)) + '' hr''
                                                     FROM [UserStorySpentTime] UST
                                                          INNER JOIN [User] U ON U.Id = UST.UserId
		                                             WHERE UST.UserStoryId = US.Id
													 GROUP BY U.FirstName ,U.SurName,U.Id
                                                     FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS UserSpentTime,
                                        US.ParkedDateTime AS UserStoryParkedDateTime,
						        	    (SELECT COUNT(1)
										  FROM [UserStory] US2 WITH (NOLOCK)  
											   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US2.UserStoryStatusId AND USSS.CompanyId  = @CompanyId  AND USSS.InactiveDateTime IS NULL  AND US2.InactiveDateTime IS NULL AND US2.[ArchivedDateTime] IS NULL AND US2.[ParkedDateTime] IS NULL
										        AND USSS.TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'', ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
											   INNER JOIN [Goal]G WITH(NOLOCK) ON G.Id = US2.GoalId AND G.InActiveDateTime IS NULL
											   LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US2.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND (@GoalId IS NULL OR US1.GoalId = @GoalId)
											   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US2.TestCaseId AND TC.InActiveDateTime IS NULL
											   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US2.BugPriorityId AND BP.InactiveDateTime IS NULL
										       LEFT JOIN [Goal]G1 WITH(NOLOCK) ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL
										       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US2.TestCaseId AND USS.InActiveDateTime IS NULL
                                                WHERE US.Id = US2.ParentUserStoryId AND (G.Id <> G1.Id) AND (US2.TestCaseId IS NULL OR USS.TestCaseId IS NOT NULL)) AS BugsCount,
										
										US.VersionName,
										G.GoalStatusId,
										G.OnboardProcessDate,
										US.TestCaseId,
										TS2.Id TestSuiteId,
										TSS.Id TestSuiteSectionId,
										TSS.SectionName TestSuiteSectionName,
										USS.[Status] AS UserStoryStatusName,
                                        USS.StatusHexValue AS UserStoryStatusColor,
										US.UserStoryStatusId,
										US.OwnerUserId,
										US.DependencyUserId,
										US.BugPriorityId,
										US.UserStoryTypeId,
										BP.PriorityName AS BugPriority,
                                        BP.Color AS BugPriorityColor,
                                        BP.[Description] AS BugPriorityDescription,
										OU.ProfileImage AS OwnerProfileImage,
										BU.UserId AS BugCausedUserId,
                                        BUU.FirstName + '' '' + ISNULL(BUU.SurName,'''') AS BugCausedUserName,
                                        BUU.ProfileImage AS BugCausedUserProfileImage,
										DU.ProfileImage AS DependencyProfileImage,
                                        G.GoalShortName,
										US1.GoalId ParentUserStoryGoalId,
										US1.UserStoryName ParentUserStoryName,
										BP.Icon,
										US.SprintId,
										US.ParentUserStoryId,
										TS.[Order] AS TaskStatusOrder,
                                        
										US.Tag,
									    CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN BT.BoardTypeUIId
										     WHEN US.GoalId IS NOT NULL THEN BT.BoardTypeUIId
											 WHEN US.SprintId IS NOT NULL THEN BTS.BoardTypeUIId
										END AS boardTypeUiId,
										UST.UserStoryTypeName,
										UST.Color AS UserStoryTypeColor,
										TUSInner.TransitionDateTime,
					                    US.ProjectFeatureId,
										(SELECT SUM(ISNULL(US1.EstimatedTime,0)) FROM UserStory US1 WHERE ParentUserStoryId = US.Id AND US1.GoalId = US.GoalId  
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (US1.InActiveDateTime IS NOT NULL OR US1.ArchivedDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (US1.InActiveDateTime IS NULL AND US1.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR (@IsParked = 1 AND US1.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US1.ParkedDateTime IS NULL))
							                                 AND P.InactiveDateTime IS NULL) TotalEstimatedTime,
					
										                        PF.ProjectFeatureName,
																(
																	SELECT USInner.Id AS userStoryId,
																	USInner.UserStoryName AS userStoryName,
																	P.ProjectName As projectName,
																	P.IsDateTimeConfiguration,
																	@EnableSprints As isSprintsConfiguration,
																	@EnableTestRepo AS isEnableTestRepo,
																	@EnableBugBoards AS isEnableBugBoards,
																	@EnableStartStop AS isEnableStartStop,
																	P.Id As projectId,
																	G.Id AS goalId,
																	G.OnboardProcessDate AS onboardProcessDate,
																	0 AS isFromSprint,
																	G.GoalName AS goalName,
																	G.GoalStatusId AS goalStatusId,
																	DUINNER.FirstName + '' '' + ISNULL(DUINNER.SurName,'''') AS dependencyName,
																	@IsAutoLog AS IsAutoLog ,
																	OUINNER.FirstName + '' '' + ISNULL(OUINNER.SurName,'''') AS ownerName,
																	ISNULL(USInner.EstimatedTime,0) estimatedTime,
																	(select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) autoLog,
								   (SELECT TOP 1 BreakType From UserStorySpentTime USPt  where USPt.UserStoryId = USInner.Id AND  USPt.UserId = @OperationsPerformedBy
								   ORDER BY USPt.[TimeStamp] DESC
								  ) breakType,
								   (select  CASE WHEN (select  top(1) USPt.StartTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy
																	  )IS NULL THEN NUll ELSE (select  top(1) USPt.StartTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy
																	  )  END) startTime,
									   
								  (select  CASE WHEN (select  top(1) USPt.EndTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
																	  )IS NULL THEN NUll ELSE (select  top(1) USPt.EndTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
																	  )  END) endTime,
											USInner.TimeStamp AS timeStamp,
											USInner.ParentUserStoryId AS parentUserStoryId,
											USInner.CreateddateTime AS createdDate,
											USInner.DeadLineDate AS deadLineDate,
											USInner.InActiveDateTime AS userStoryArchivedDateTime,
											USInner.ParkedDateTime AS userStoryParkedDateTime,
											TS1.Id TestSuiteId,
											TSS1.Id TestSuiteSectionId,
											USInner.VersionName AS versionName,
											USSINNER.[Status] AS userStoryStatusName,
											USSINNER.StatusHexValue AS userStoryStatusColor,
											USInner.UserStoryStatusId AS userStoryStatusId,
											USInner.OwnerUserId AS ownerUserId,
											USInner.DependencyUserId AS dependencyUserId,
											USInner.BugPriorityId AS bugPriorityId,
											BPINNER.PriorityName AS bugPriority,
											STUFF(( SELECT  '','' + UIN.FirstName + CONCAT('' '',UIN.SurName) + '' : '' + CONVERT(NVARCHAR,ROUND(SUM(USTIN.SpentTimeInMin) * 1.0 / 60.0,2)) + '' hr''
                                                     FROM [UserStorySpentTime] USTIN
                                                          INNER JOIN [User] UIN ON UIN.Id = USTIN.UserId
		                                             WHERE USTIN.UserStoryId = USInner.Id
													 GROUP BY UIN.FirstName ,UIN.SurName,UIN.Id
                                                     FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS userSpentTime,
											BPINNER.Color AS bugPriorityColor,
											BPINNER.[Description] AS bugPriorityDescription,
											OUINNER.ProfileImage AS ownerProfileImage,
											BUINNER.UserId AS bugCausedUserId,
											BUUINNER.FirstName + '' '' + ISNULL(BUUINNER.SurName,'''') AS bugCausedUserName,
											BUUINNER.ProfileImage AS bugCausedUserProfileImage,
											DUINNER.ProfileImage AS dependencyProfileImage,
											G.GoalShortName AS goalShortName,
											S.SprintName AS sprintName,
											BPINNER.Icon AS icon,
											TUSINNER.TransitionDateTime AS transitionDateTime,
											USInner.[Order] AS ''order'',
											USInner.Tag AS tag,
											USInner.[Description] AS description,
											USInner.UserStoryTypeId AS userStoryTypeId,
											USTINNER.UserStoryTypeName AS userStoryTypeName,
											USTINNER.Color AS userStoryTypeColor,
											USInner.UserStoryUniqueName AS userStoryUniqueName,
											USInner.ProjectFeatureId AS projectFeatureId,
											USInner.RAGStatus AS rAGStatus,
											TSINNER.Id AS taskStatusId,
											TSINNER.[Order] AS taskStatusOrder,
											 BTWINNER.workFlowId,
											 TZ.TimeZoneAbbreviation CreatedOnTimeZoneAbbreviation ,
											 TZ.TimeZoneAbbreviation DeadLineTimeZoneAbbreviation,
											PFINNER.ProjectFeatureName AS ProjectFeatureName,
											CASE WHEN USInner.GoalId IS NOT NULL AND USInner.SprintId IS NOT NULL THEN BTINNER.IsSuperAgileBoard
										     WHEN USInner.GoalId IS NOT NULL THEN BTINNER.IsSuperAgileBoard
											 WHEN USInner.SprintId IS NOT NULL THEN BTINNER.IsSuperAgileBoard
										      END AS isSuperAgileBoard,
																	    (SELECT COUNT(1)
										  FROM [UserStory]US2 WITH (NOLOCK)  
											   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US2.UserStoryStatusId AND USSS.CompanyId  = @CompanyId AND USSS.InactiveDateTime IS NULL AND US2.InactiveDateTime IS NULL AND US2.[ArchivedDateTime] IS NULL AND US2.[ParkedDateTime] IS NULL
										        AND USSS.TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'', ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
											   INNER JOIN [Goal]G WITH(NOLOCK) ON G.Id = US2.GoalId AND G.InActiveDateTime IS NULL
											   LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US2.ParentUserStoryId AND US1.InActiveDateTime IS NULL   AND (@GoalId IS NULL OR US1.GoalId = @GoalId)
											   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US2.TestCaseId AND TC.InActiveDateTime IS NULL
											   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US2.BugPriorityId AND BP.InactiveDateTime IS NULL
										       LEFT JOIN [Goal]G1 WITH(NOLOCK) ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL
										       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US2.TestCaseId AND USS.InActiveDateTime IS NULL
                                                WHERE USInner.Id = US2.ParentUserStoryId AND (G1.Id <> G.Id) AND (US2.TestCaseId IS NULL OR USS.TestCaseId IS NOT NULL)) AS bugsCount,
											(CASE WHEN ((P.IsDateTimeConfiguration = 1 AND SYSDATETIMEOFFSET() > US.DeadLineDate) OR (P.IsDateTimeConfiguration = 0 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate))) 
											            AND (TS.[Order] IN (1,2)) 
										         THEN 1 ELSE 0 END) AS IsOnTrack,
												 (SELECT CFInner.Id AS customFieldId,
										CFInner.FieldName AS formName,
										CFInner.FormKeys AS formKeys,
										CFFInner.FormDataJson AS formDataJson,
										CFFInner.CreatedDateTime AS createdDateTime  FROM [dbo].[CustomField] CFInner
										INNER JOIN [dbo].[CustomFormFieldMapping] CFFInner ON CFFInner.FormId = CFInner.Id AND CFFInner.FormReferenceId = USInner.Id AND CFInner.CompanyId = @CompanyId
										 WHERE CFInner.InactiveDateTime IS NULL 
										FOR XML PATH(''UserStoryCustomFieldsModel''), ROOT(''UserStoryCustomFieldsModel''), TYPE) AS userStoryCustomFieldsXml
										FROM UserStory USInner 
									INNER JOIN [dbo].[Goal]GINNER WITH (NOLOCK) ON GINNER.Id = USInner.GoalId  AND (@GoalId IS NULL OR USInner.GoalId = @GoalId)
									LEFT JOIN [dbo].[BugPriority] BPINNER WITH (NOLOCK) ON BPINNER.Id = USInner.BugPriorityId AND USInner.GoalId = US.GoalId
									LEFT JOIN [TestSuite]TS1 ON TS1.Id = GINNER.TestSuiteId AND TS1.InActiveDateTime IS NULL
								   LEFT JOIN [dbo].[TestSuiteSection] TSS1 WITH (NOLOCK)  ON TSS1.Id = USInner.TestSuiteSectionId AND TS1.Id = TSS1.TestSuiteId AND TSS1.InActiveDateTime IS NULL
                                   LEFT JOIN [dbo].[BugCausedUser] BUINNER WITH (NOLOCK) ON BUINNER.UserStoryId = USInner.Id	AND BUINNER.InActiveDateTime IS NULL
                                   LEFT JOIN [dbo].[User] BUUINNER WITH (NOLOCK) ON BUUINNER.Id = BUINNER.UserId 
                                   LEFT JOIN [dbo].[UserStoryType] USTINNER WITH (NOLOCK) ON USTINNER.Id = USInner.UserStoryTypeId 
                                   LEFT JOIN [dbo].[ProjectFeature] PFINNER WITH (NOLOCK) ON PFINNER.Id = USInner.ProjectFeatureId 
                                   LEFT JOIN [dbo].[UserStoryPriority] USPINNER WITH (NOLOCK) ON USPINNER.Id = USInner.UserStoryPriorityId 
                                   LEFT JOIN [dbo].[User] RUINNER WITH (NOLOCK) ON RUINNER.Id = USInner.ReviewerUserId 
								   LEFT JOIN [UserStoryStatus] USSINNER WITH (NOLOCK) ON USSINNER.Id = USINNER.UserStoryStatusId 
                                   LEFT JOIN [dbo].[User] OUINNER WITH (NOLOCK) ON OUINNER.Id = USINNER.OwnerUserId 
                                   LEFT JOIN [dbo].[User] DUINNER WITH (NOLOCK) ON DUINNER.Id = USINNER.DependencyUserId 
                                   LEFT JOIN [dbo].[BoardTypeWorkFlow] BTWINNER WITH (NOLOCK) ON BTWINNER.BoardTypeId = G.BoardTypeId 
                                   LEFT JOIN [dbo].[BoardType] BTINNER WITH (NOLOCK) ON BTINNER.Id = G.BoardTypeId 
								   LEFT JOIN [dbo].[TaskStatus]TSINNER WITH (NOLOCK) ON TSINNER.Id = USSINNER.TaskStatusId
								   LEFT JOIN TimeZone TZ ON TZ.Id = USInner.CreatedDateTimeZone
								   LEFT JOIN TimeZone TZ1 ON TZ1.Id = USInner.DeadLineDateTimeZone
								   LEFT JOIN #UserStoryTypes USTT ON USTT.Id = USInner.UserStoryTypeId AND @UserStoryTypeIdsXml IS NOT NULL
				                   LEFT JOIN #BugPriorityId BPP ON BPP.Id = USInner.BugPriorityId AND @BugPriorityIdsXml IS NOT NULL
				                   LEFT JOIN #BugCausedUser BC ON BC.Id = BUINNER.UserId AND @BugCausedUserIds IS NOT NULL
				                   LEFT JOIN #DependencyOnUser DOU ON DOU.Id= USINNER.DependencyUserId AND @DependencyUserIds IS NOT NULL
								   LEFT JOIN #ProjectFeatures PFF ON PFF.Id = USInner.ProjectFeatureId
								    LEFT JOIN (SELECT UserStoryId,MAX(TransitionDateTime) TransitionDateTime
																								FROM UserStoryWorkflowStatusTransition WITH (NOLOCK)
																								WHERE (@UserStoryId IS NULL OR UserStoryId = @UserStoryId)
																								GROUP BY UserStoryId) TUSINNER ON TUSINNER.UserStoryId = USInner.Id 
										 WHERE P.CompanyId = @CompanyId
							                                 AND (@GoalId IS NULL OR USInner.GoalId = @GoalId)
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (USInner.InActiveDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (USInner.InActiveDateTime IS NULL AND USInner.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR ((@IsParked = 1 AND USInner.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND USInner.ParkedDateTime IS NULL)))
							                                 AND  P.InactiveDateTime IS NULL
															 AND (@UserStoryTypeIdsXml IS NULL OR USTT.Id IS NOT NULL)
							                                 AND (@BugPriorityIdsXml IS NULL OR BPP.Id IS NOT NULL)
							                                 AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL)
							                                 AND (@DependencyUserIds IS NULL OR DOU.Id IS NOT NULL)
							                                 AND (@ProjectFeatureIds IS NULL OR PFF.Id IS NOT NULL)
															 AND (@CreatedDateFrom IS NULL OR CAST(USInner.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE))
							                                 AND (@CreatedDateTo IS NULL OR CAST(USInner.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE))
							                                 AND (@UpdatedDateFrom IS NULL OR CAST(USInner.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE))
							                                 AND (@UpdatedDateTo IS NULL OR CAST(USInner.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE))
															 AND (@UserStoryName IS NULL OR USInner.UserStoryName LIKE  @UserStoryName)
															 AND (@VersionName IS NULL OR USInner.VersionName LIKE  @VersionName)
															 AND (@UserStoryId IS NULL OR (@UserStoryId IS NOT NULL AND USInner.InActiveDateTime IS NULL AND USInner.ParkedDateTime IS NULL))
															 AND USInner.ParentUserStoryId = US.Id AND USInner.GoalId = US.GoalId 
															 AND (@UserStoryTagsXml IS NULL OR  EXISTS (SELECT [Value] FROM [dbo].[ufn_stringsplit](USInner.Tag,'','') WHERE [Value] In (SELECT Tag FROM #WorkItemTags) AND USInner.Tag IS NOT NULL) )'
	
					IF(@IsOnTrack = 1 OR @IsNotOnTrack = 1)
					BEGIN
						
						SET @SearchSqlScript = @SearchSqlScript + N' AND (TSINNER.Id <> ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'' AND USInner.DeadLineDate IS NOT NULL)'

						IF(@IsBothTracked = 0)
						BEGIN
						
							IF (@IsOnTrack = 1) 
								SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,USInner.DeadLineDate) >= CONVERT(DATE,GETDATE())) AND USInner.DeadLineDate IS NOT NULL '
							ELSE 
								SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,USInner.DeadLineDate) < CONVERT(DATE,GETDATE())) AND USInner.DeadLineDate IS NOT NULL '

						END
					
					END

				SET @SearchSqlScript = @SearchSqlScript + N' AND (@DeadLineDateFrom IS NULL OR USInner.DeadLineDate >= @DeadLineDateFrom)
                                                             AND (USInner.DeadLineDate >= @DeadLineDateFrom OR @DeadLineDateFrom IS NULL)
															 AND (@OwnerUserIdsXml IS NULL OR (USInner.OwnerUserId IN (SELECT Id FROM #OwnerUser1) OR (USInner.OwnerUserId IS NULL AND ''00000000-0000-0000-0000-000000000000'' IN (SELECT Id FROM #OwnerUser1 WHERE Id = ''00000000-0000-0000-0000-000000000000''))))
	                                                     	 AND (@UserStoryStatusIdsXml IS NULL OR USInner.UserStoryStatusId IN (SELECT Id FROM #UserStoryStatus1)) 
										ORDER BY USInner.[Order] ASC
										FOR JSON PATH,ROOT(''ChildUserStories'')) AS SubUserStories,
										US.UserStoryUniqueName,
										(CASE WHEN ((P.IsDateTimeConfiguration = 1 AND SYSDATETIMEOFFSET() > US.DeadLineDate) OR (P.IsDateTimeConfiguration = 0 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate))) 
											            AND (TS.[Order] IN (1,2)) 
										         THEN 1 ELSE 0 END) AS IsOnTrack ,
									(SELECT CF.Id AS CustomFieldId,
										CF.FieldName AS FormName,
										CF.FormKeys,
										CFF.FormDataJson,
										CFF.CreatedDateTime FROM [dbo].[CustomField] CF
										INNER JOIN [dbo].[CustomFormFieldMapping] CFF ON CFF.FormId = CF.Id AND CFF.FormReferenceId = US.Id
										 WHERE CF.InactiveDateTime IS NULL AND CF.CompanyId = @CompanyId
										FOR XML PATH(''UserStoryCustomFieldsModel''), ROOT(''UserStoryCustomFieldsModel''), TYPE) AS UserStoryCustomFieldsXml'
		
		END
		ELSE
         IF(@DependencyText IS NULL)  SET @SearchSqlScript = @SearchSqlScript + N' ,US.GoalId,
                                       
                                        US.OwnerUserId,
                                        US.InActiveDateTime AS UserStoryArchivedDateTime,
                                        US.ParkedDateTime AS UserStoryParkedDateTime,
                                        BP.PriorityName AS BugPriority,
                                        BP.Color AS BugPriorityColor,
                                        BP.[Description] AS BugPriorityDescription,
										US.VersionName,
										TS2.Id TestSuiteId,
										TSS.Id TestSuiteSectionId,
										TSS.SectionName TestSuiteSectionName,
                                        PF.ProjectFeatureName,
                                        OU.ProfileImage AS OwnerProfileImage,
                                        G.ProjectId AS ProjectId,
                                        G.BoardTypeId,
										US.TestCaseId,
                                        G.BoardTypeApiId,
                                        G.InActiveDateTime AS GoalArchivedDateTime,
										G.ParkedDateTime AS GoalParkedDateTime,
                                        G.GoalStatusId,
                                        G.GoalShortName,
                                        G.OnboardProcessDate,
                                        G.ConfigurationId,
                                        US.DependencyUserId,
                                        DU.ProfileImage AS DependencyProfileImage,
                                        US.[Order],
                                        US.UserStoryStatusId,
                                        USS.[Status] AS UserStoryStatusName,
                                        USS.StatusHexValue AS UserStoryStatusColor,
										US.InactiveDateTime,
                                        US.BugPriorityId,
                                        US.ParentUserStoryId,
										US1.GoalId ParentUserStoryGoalId,
										BP.Icon,
                                        BU.UserId AS BugCausedUserId,
                                        BUU.FirstName + '' '' + ISNULL(BUU.SurName,'''') AS BugCausedUserName,
                                        BUU.ProfileImage AS BugCausedUserProfileImage,
                                        US.UserStoryTypeId,
                                        UST.UserStoryTypeName,
										UST.IsQaRequired,
										UST.IsLogTimeRequired,
										UST.UserStoryTypeName,
										UST.Color AS UserStoryTypeColor,
                                        US.UserStoryPriorityId,
                                        USP.PriorityName,
                                        USP.[Order] UserStoryPriorityOder ,
                                        US.ProjectFeatureId,
                                        US.ParkedDateTime,
                                        US.UserStoryUniqueName,
										(CASE WHEN ((P.IsDateTimeConfiguration = 1 AND SYSDATETIMEOFFSET() > US.DeadLineDate) OR (P.IsDateTimeConfiguration = 0 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate))) 
											            AND (TS.[Order] IN (1,2)) 
										         THEN 1 ELSE 0 END) AS IsOnTrack,
                                        US.CreatedDateTime,
                                        RU.Id AS ReviewerUserId,
                                        RU.FirstName + '' '' + ISNULL(RU.SurName,'''') AS ReviewerUserName,
                                        US.[Description],
										US.[TimeStamp],
										US.Tag,
										TS.[Order] AS TaskStatusOrder,
										(SELECT COUNT(1)
										  FROM [UserStory] US2 WITH (NOLOCK)  
											   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US2.UserStoryStatusId  AND USSS.CompanyId  = @CompanyId  AND USSS.InactiveDateTime IS NULL AND US2.InactiveDateTime IS NULL AND US2.[ArchivedDateTime] IS NULL AND US2.[ParkedDateTime] IS NULL
										        AND USSS.TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'', ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
											   INNER JOIN [Goal]G WITH(NOLOCK) ON G.Id = US2.GoalId AND G.InActiveDateTime IS NULL
											   LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US2.ParentUserStoryId AND US1.InActiveDateTime IS NULL  AND (@GoalId IS NULL OR US1.GoalId = @GoalId)
											   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US2.TestCaseId AND TC.InActiveDateTime IS NULL
											   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US2.BugPriorityId AND BP.InactiveDateTime IS NULL
										       LEFT JOIN [Goal]G1 WITH(NOLOCK) ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL
										       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US2.TestCaseId AND USS.InActiveDateTime IS NULL
                                                WHERE US.Id = US2.ParentUserStoryId AND (G.Id <> G1.Id) AND (US2.TestCaseId IS NULL OR USS.TestCaseId IS NOT NULL)) AS BugsCount,
										(SELECT SUM(ISNULL(US1.EstimatedTime,0)) FROM UserStory US1 WHERE ParentUserStoryId = US.Id AND US1.GoalId = US.GoalId 
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (US1.InActiveDateTime IS NOT NULL OR US1.ArchivedDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (US1.InActiveDateTime IS NULL AND US1.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR (@IsParked = 1 AND US1.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US1.ParkedDateTime IS NULL))
							                                 AND  P.InactiveDateTime IS NULL) TotalEstimatedTime,
									
										(
											SELECT USInner.Id AS userStoryId,
											USInner.UserStoryName AS userStoryName,
											P.ProjectName As projectName,
											P.IsDateTimeConfiguration,
											@EnableSprints As isSprintsConfiguration,
											@EnableTestRepo AS isEnableTestRepo,
											@EnableBugBoards AS isEnableBugBoards,
											@EnableStartStop AS isEnableStartStop,
											0 AS isFromSprint,
											P.Id As projectId,
											G.Id AS goalId,
											G.GoalName AS goalName,
											G.GoalStatusId AS goalStatusId,
											DUINNER.FirstName + '' '' + ISNULL(DUINNER.SurName,'''') AS dependencyName,
											@IsAutoLog AS IsAutoLog ,
											OUINNER.FirstName + '' '' + ISNULL(OUINNER.SurName,'''') AS ownerName,
											ISNULL(USInner.EstimatedTime,0) estimatedTime,
											(select  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) autoLog,
								    (SELECT TOP 1 BreakType From UserStorySpentTime USPt  where USPt.UserStoryId = USInner.Id AND  USPt.UserId = @OperationsPerformedBy
								  ORDER BY  USPt.[TimeStamp] DESC
								  ) breakType,
								   (select  CASE WHEN (select  top(1) USPt.StartTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy
																	  )IS NULL THEN NUll ELSE (select  top(1) CAST(USPt.StartTime AS DATETIME) from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPt.UserId = @OperationsPerformedBy
																	  )  END) startTime,
									   
								  (select  CASE WHEN (select  top(1) USPt.EndTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
																	  )IS NULL THEN NUll ELSE (select  top(1) USPt.EndTime  from UserStorySpentTime USPt
									where USPt.UserStoryId = USInner.Id AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
																	  )  END) endTime,
											USInner.TimeStamp AS timeStamp,
											USInner.ParentUserStoryId AS parentUserStoryId,
											USInner.DeadLineDate AS deadLineDate,
											USInner.InActiveDateTime AS userStoryArchivedDateTime,
											USInner.ParkedDateTime AS userStoryParkedDateTime,
											TS1.Id TestSuiteId,
											USInner.RAGStatus AS rAGStatus,
											TSS1.Id TestSuiteSectionId,
											USInner.VersionName AS versionName,
											USSINNER.[Status] AS userStoryStatusName,
											USSINNER.StatusHexValue AS userStoryStatusColor,
											USInner.UserStoryStatusId AS userStoryStatusId,
											USInner.OwnerUserId AS ownerUserId,
											USInner.DependencyUserId AS dependencyUserId,
											USInner.BugPriorityId AS bugPriorityId,
											BPINNER.PriorityName AS bugPriority,
											BPINNER.Color AS bugPriorityColor,
											BPINNER.[Description] AS bugPriorityDescription,
											OUINNER.ProfileImage AS ownerProfileImage,
											BUINNER.UserId AS bugCausedUserId,
											BUUINNER.FirstName + '' '' + ISNULL(BUUINNER.SurName,'''') AS bugCausedUserName,
											BUUINNER.ProfileImage AS bugCausedUserProfileImage,
											DUINNER.ProfileImage AS dependencyProfileImage,
											G.GoalShortName AS goalShortName,
											BPINNER.Icon AS icon,
											USInner.[Order] AS ''order'',
											USInner.Tag AS tag,
											UsInner.UserStoryTypeId AS userStoryTypeId,
											USTINNER.IsQaRequired AS isQaRequired,
										    USTINNER.IsLogTimeRequired AS isLogTimeRequired,
											USTINNER.UserStoryTypeName AS userStoryTypeName,
											USTINNER.Color AS userStoryTypeColor,
											USInner.UserStoryUniqueName AS userStoryUniqueName,
											TUSINNER.TransitionDateTime AS transitionDateTime,
											USInner.ProjectFeatureId AS projectFeatureId,
											PFINNER.ProjectFeatureName AS ProjectFeatureName,
											BTWINNER.workFlowId,
											TZ.TimeZoneAbbreviation CreatedOnTimeZoneAbbreviation ,
											TZ.TimeZoneAbbreviation DeadLineTimeZoneAbbreviation,
											TSINNER.[Order] AS taskStatusOrder,
											 CASE WHEN US.GoalId IS NOT NULL AND US.SprintId IS NOT NULL THEN BT.BoardTypeUIId
										     WHEN US.GoalId IS NOT NULL THEN BT.BoardTypeUIId
											 WHEN US.SprintId IS NOT NULL THEN BTS.BoardTypeUIId
										END AS boardTypeUiId,
										CASE WHEN USInner.GoalId IS NOT NULL AND USInner.SprintId IS NOT NULL THEN BTINNER.IsSuperAgileBoard
										     WHEN USInner.GoalId IS NOT NULL THEN BTINNER.IsSuperAgileBoard
											 WHEN USInner.SprintId IS NOT NULL THEN BTINNER.IsSuperAgileBoard
										      END AS isSuperAgileBoard,
											(SELECT COUNT(1)
										  FROM [UserStory]US2 WITH (NOLOCK)  
											   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US2.UserStoryStatusId  AND USSS.CompanyId  = @CompanyId  AND USSS.InactiveDateTime IS NULL AND US2.InactiveDateTime IS NULL AND US2.[ArchivedDateTime] IS NULL AND US2.[ParkedDateTime] IS NULL
										        AND USSS.TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'', ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
											   INNER JOIN [Goal]G WITH(NOLOCK) ON G.Id = US2.GoalId AND G.InActiveDateTime IS NULL
											   LEFT JOIN [Goal]G1 WITH(NOLOCK) ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL  AND (@GoalId IS NULL OR US1.GoalId = @GoalId)
											   LEFT JOIN TestCase TC  WITH(NOLOCK) ON TC.Id = US2.TestCaseId AND TC.InActiveDateTime IS NULL
											   LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US2.BugPriorityId AND BP.InactiveDateTime IS NULL
										       LEFT JOIN UserStory US1 WITH (NOLOCK) ON US1.Id = US2.ParentUserStoryId AND US1.InActiveDateTime IS NULL
										       LEFT JOIN [UserStoryScenario]USS WITH(NOLOCK) ON USS.TestCaseId = US2.TestCaseId AND USS.InActiveDateTime IS NULL
                                                WHERE USInner.Id = US2.ParentUserStoryId AND (G.Id <> G1.Id) AND (US2.TestCaseId IS NULL OR USS.TestCaseId IS NOT NULL)) AS bugsCount,
											(CASE WHEN ((P.IsDateTimeConfiguration = 1 AND SYSDATETIMEOFFSET() > US.DeadLineDate) OR (P.IsDateTimeConfiguration = 0 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate))) 
											            AND (TS.[Order] IN (1,2)) 
										         THEN 1 ELSE 0 END) AS IsOnTrack,
												  (SELECT CFInner.Id AS customFieldId,
										CFInner.FieldName AS formName,
										CFInner.FormKeys AS formKeys,
										CFFInner.FormDataJson AS formDataJson,
										CFFInner.CreatedDateTime AS createdDateTime  FROM [dbo].[CustomField] CFInner
										INNER JOIN [dbo].[CustomFormFieldMapping] CFFInner ON CFFInner.FormId = CFInner.Id AND CFFInner.FormReferenceId = USInner.Id
										 WHERE CFInner.InactiveDateTime IS NULL AND CFInner.CompanyId = @CompanyId
										FOR XML PATH(''UserStoryCustomFieldsModel''), ROOT(''UserStoryCustomFieldsModel''), TYPE) AS userStoryCustomFieldsXml
										FROM UserStory USInner INNER JOIN [dbo].[Goal]GINNER WITH (NOLOCK) ON GINNER.Id = USInner.GoalId  AND (@GoalId IS NULL OR USInner.GoalId = @GoalId)
										LEFT JOIN [dbo].[BugPriority] BPINNER WITH (NOLOCK) ON BPINNER.Id = USInner.BugPriorityId 
								   LEFT JOIN [TestSuite]TS1 ON TS1.Id = GINNER.TestSuiteId AND TS1.InActiveDateTime IS NULL
								   LEFT JOIN [dbo].[TestSuiteSection] TSS1 WITH (NOLOCK)  ON TSS1.Id = USInner.TestSuiteSectionId AND TS1.Id = TSS1.TestSuiteId AND TSS1.InActiveDateTime IS NULL
                                   LEFT JOIN [dbo].[BugCausedUser] BUINNER WITH (NOLOCK) ON BUINNER.UserStoryId = USInner.Id AND BUINNER.InactiveDateTime IS NULL
                                   LEFT JOIN [dbo].[User] BUUINNER WITH (NOLOCK) ON BUUINNER.Id = BUINNER.UserId 
                                   LEFT JOIN [dbo].[UserStoryType] USTINNER WITH (NOLOCK) ON USTINNER.Id = USInner.UserStoryTypeId 
                                   LEFT JOIN [dbo].[ProjectFeature] PFINNER WITH (NOLOCK) ON PFINNER.Id = USInner.ProjectFeatureId 
                                   LEFT JOIN [dbo].[UserStoryPriority] USPINNER WITH (NOLOCK) ON USPINNER.Id = USInner.UserStoryPriorityId 
                                   LEFT JOIN [dbo].[User] RUINNER WITH (NOLOCK) ON RUINNER.Id = USInner.ReviewerUserId 
								   LEFT JOIN [UserStoryStatus] USSINNER WITH (NOLOCK) ON USSINNER.Id = USINNER.UserStoryStatusId 
                                   LEFT JOIN [TaskStatus]TSINNER WITH (NOLOCK) ON TSINNER.Id = USSINNER.TaskStatusId
								   LEFT JOIN [dbo].[User] OUINNER WITH (NOLOCK) ON OUINNER.Id = USINNER.OwnerUserId 
                                   LEFT JOIN [dbo].[User] DUINNER WITH (NOLOCK) ON DUINNER.Id = USINNER.DependencyUserId 
                                   LEFT JOIN [dbo].[BoardTypeWorkFlow] BTWINNER WITH (NOLOCK) ON BTWINNER.BoardTypeId = G.BoardTypeId
                                   LEFT JOIN [dbo].[BoardType] BTINNER WITH (NOLOCK) ON BTINNER.Id = G.BoardTypeId 
								   LEFT JOIN TimeZone TZ ON TZ.Id = USInner.CreatedDateTimeZone
								   LEFT JOIN TimeZone TZ1 ON TZ1.Id = USInner.DeadLineDateTimeZone
								   LEFT JOIN #UserStoryTypes USTT ON USTT.Id = USInner.UserStoryTypeId AND @UserStoryTypeIdsXml IS NOT NULL
				                   LEFT JOIN #BugPriorityId BPP ON BPP.Id = USInner.BugPriorityId AND @BugPriorityIdsXml IS NOT NULL
				                   LEFT JOIN #BugCausedUser BC ON BC.Id = BUINNER.UserId AND @BugCausedUserIds IS NOT NULL
				                   LEFT JOIN #DependencyOnUser DOU ON DOU.Id= USInner.DependencyUserId AND @DependencyUserIds IS NOT NULL
								   LEFT JOIN #ProjectFeatures PFF ON PFF.Id = USInner.ProjectFeatureId AND @ProjectFeatureIds IS NOT NULL
				                   LEFT JOIN (SELECT UserStoryId,MAX(TransitionDateTime) TransitionDateTime
																								FROM UserStoryWorkflowStatusTransition WITH (NOLOCK)
																								GROUP BY UserStoryId) TUSINNER ON TUSINNER.UserStoryId = USInner.Id 
										WHERE P.CompanyId = @CompanyId
										                     AND (@GoalId IS NULL OR USInner.GoalId = @GoalId)
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (USInner.InActiveDateTime IS NOT NULL OR USInner.ArchivedDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (USInner.InActiveDateTime IS NULL AND USInner.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR ((@IsParked = 1 AND USInner.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND USInner.ParkedDateTime IS NULL)))
							                                 AND P.InactiveDateTime IS NULL
															 AND (@UserStoryTypeIdsXml IS NULL OR USTT.Id IS NOT NULL)
							                                 AND (@BugPriorityIdsXml IS NULL OR BPP.Id IS NOT NULL)
							                                 AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL)
							                                 AND (@DependencyUserIds IS NULL OR DOU.Id IS NOT NULL)
							                                 AND (@ProjectFeatureIds IS NULL OR PFF.Id IS NOT NULL)
															  AND (@UserStoryName IS NULL OR USInner.UserStoryName LIKE  @UserStoryName)
															  AND (@VersionName IS NULL OR USInner.VersionName LIKE  @VersionName)
															 AND (@CreatedDateFrom IS NULL OR CAST(USInner.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE))
							                                 AND (@CreatedDateTo IS NULL OR CAST(USInner.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE))
							                                 AND (@UpdatedDateFrom IS NULL OR CAST(USInner.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE))
							                                 AND (@UpdatedDateTo IS NULL OR CAST(USInner.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE))
															 AND (@UserStoryId IS NULL OR (@UserStoryId IS NOT NULL AND USInner.InActiveDateTime IS NULL AND USInner.ParkedDateTime IS NULL))
															 AND USInner.ParentUserStoryId = US.Id AND USInner.GoalId = US.GoalId
															 AND (@OwnerUserIdsXml IS NULL OR (USInner.OwnerUserId IN (SELECT Id FROM #OwnerUser1) OR (USInner.OwnerUserId IS NULL AND ''00000000-0000-0000-0000-000000000000'' IN (SELECT Id FROM #OwnerUser1 WHERE Id = ''00000000-0000-0000-0000-000000000000''))))
	                                                     	 AND (@UserStoryStatusIdsXml IS NULL OR USInner.UserStoryStatusId IN (SELECT Id FROM #UserStoryStatus1)) 
															 AND (@UserStoryTagsXml IS NULL OR  EXISTS (SELECT [Value] FROM [dbo].[ufn_stringsplit](USInner.Tag,'','') WHERE [Value] In (SELECT Tag FROM #WorkItemTags) AND USInner.Tag IS NOT NULL))
										AND USInner.InactiveDateTime IS NULL
										ORDER BY USInner.[Order] ASC
										FOR JSON PATH,ROOT(''ChildUserStories'')) AS SubUserStories,
										(CASE WHEN ((P.IsDateTimeConfiguration = 1 AND SYSDATETIMEOFFSET() > US.DeadLineDate) OR (P.IsDateTimeConfiguration = 0 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate))) 
											            AND (TS.[Order] IN (1,2)) 
										         THEN 1 ELSE 0 END) AS IsOnTrack,
									
										TS.Id AS TaskStatusId,
										CX.CronExpression,
										CX.TimeStamp AS CronExpressionTimeStamp,
										CX.Id AS CronExpressionId,
										CX.JobId,
										CX.EndDate AS ScheduleEndDate,
										CX.IsPaused,
										(SELECT CF.Id AS CustomFieldId,
										CF.FieldName AS FormName,
										CF.FormKeys,
										CFF.FormDataJson,
										CFF.CreatedDateTime FROM [dbo].[CustomField] CF
										INNER JOIN [dbo].[CustomFormFieldMapping] CFF ON CFF.FormId = CF.Id AND CFF.FormReferenceId = US.Id
										 WHERE CF.InactiveDateTime IS NULL AND CF.CompanyId = @CompanyId
										FOR XML PATH(''UserStoryCustomFieldsModel''), ROOT(''UserStoryCustomFieldsModel''), TYPE) AS UserStoryCustomFieldsXml' 
			 
         SET @SearchSqlScript = @SearchSqlScript + N' FROM [dbo].[UserStory] US
		                                              LEFT JOIN CronExpression CX ON CX.CustomWidgetId = US.Id AND CX.InactiveDateTime IS NULL AND CX.CompanyId = @CompanyId AND  (@GoalId IS NULL OR US.GoalId = @GoalId)' 

		 IF (@UserStoryIdsXml IS NOT NULL)
		  BEGIN
		  	
		  	CREATE TABLE #UserStory
		  	(
		  		Id UNIQUEIDENTIFIER
		  	)
		  
		  	INSERT INTO #UserStory(Id)
		  	SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
		  	FROM @UserStoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
		  
		  	SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #UserStory USInner ON USInner.Id = US.Id '
		  	 
		  END

		 IF (@GoalId IS NOT NULL OR @UserStoryId IS NOT NULL) 
		 BEGIN
			
		   IF (@GoalId IS NOT NULL AND @UserStoryId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId AND (US.GoalId = @GoalId) AND (US.Id = @UserStoryId)' 
		   
		   ELSE IF (@UserStoryId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' LEFT JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId' 
		   
		   ELSE IF (@GoalId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId AND (US.GoalId = @GoalId)' 
		   
		   ELSE SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId AND (US.GoalId = @GoalId)'
		 
		 END
         ELSE SET @SearchSqlScript = @SearchSqlScript + ' LEFT JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId'
		                                                  
		 IF (@ProjectId IS NOT NULL AND @GoalStatusId IS NULL) SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = US.ProjectId AND (US.ProjectId = @ProjectId)
		                                                                          AND P.Id IN (SELECT UP.ProjectId FROM USerProject UP
																				               WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
																				AND P.ProjectName <> ''Adhoc project''
		                                                             AND P.InactiveDateTime IS NULL'

         ELSE SET @SearchSqlScript = @SearchSqlScript + ' INNER JOIN [Project] P WITH (NOLOCK) ON (P.Id = US.ProjectId )
		                                                  AND P.Id IN (SELECT UP.ProjectId FROM USerProject UP
																				               WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
																				AND P.ProjectName <> ''Adhoc project''
		                                                             AND P.InactiveDateTime IS NULL '

		 SET @SearchSqlScript = @SearchSqlScript + ' LEFT JOIN [dbo].[GoalStatus] GS WITH (NOLOCK) ON GS.Id = G.GoalStatusId
								   LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW WITH (NOLOCK) ON BTW.BoardTypeId = G.BoardTypeId
								   LEFT JOIN [dbo].[BoardType] BT WITH (NOLOCK) ON BT.Id = G.BoardTypeId
                                   LEFT JOIN [UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId
								   LEFT JOIN [WorkFlowStatus] WFS WITH (NOLOCK) ON WFS.WorkFlowId = US.WorkFlowId AND WFS.UserStoryStatusId = USS.Id
								   LEFT JOIN [TaskStatus] TS WITH (NOLOCK) ON TS.Id = USS.TaskStatusId
                                   LEFT JOIN [dbo].[User] OU WITH (NOLOCK) ON OU.Id = US.OwnerUserId
                                   LEFT JOIN [dbo].[User] DU WITH (NOLOCK) ON DU.Id = US.DependencyUserId
								   LEFT JOIN [dbo].[Sprints] S ON US.SprintId = S.Id AND S.InActiveDateTime IS NULL
								   LEFT JOIN [ActionCategory] ACC ON ACC.Id = US.ActionCategoryId AND ACC.InActiveDateTime IS NULL
		                           LEFT JOIN [dbo].[BoardType] BTS WITH (NOLOCK) ON BTS.Id = S.BoardTypeId'
                                   
		IF(@DependencyText IS NULL)  SET @SearchSqlScript = @SearchSqlScript + N' LEFT JOIN [dbo].[BugPriority] BP WITH (NOLOCK) ON BP.Id = US.BugPriorityId
                                   LEFT JOIN [dbo].[BugCausedUser] BU WITH (NOLOCK) ON BU.UserStoryId = US.Id AND BU.InActiveDateTime IS NULL
                                   LEFT JOIN [dbo].[User] BUU WITH (NOLOCK) ON BUU.Id = BU.UserId
                                   LEFT JOIN [dbo].[UserStoryType] UST WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId
                                   LEFT JOIN [dbo].[ProjectFeature] PF WITH (NOLOCK) ON PF.Id = US.ProjectFeatureId
                                   LEFT JOIN [dbo].[UserStoryPriority] USP WITH (NOLOCK) ON USP.Id = US.UserStoryPriorityId
                                   LEFT JOIN [dbo].[User] RU WITH (NOLOCK) ON RU.Id = US.ReviewerUserId
								   LEFT JOIN [TestSuite]TS2 ON TS2.Id = G.TestSuiteId AND TS2.InActiveDateTime IS NULL
								   LEFT JOIN [dbo].[TestSuiteSection] TSS WITH (NOLOCK)  ON TSS.Id = US.TestSuiteSectionId AND TSS.InActiveDateTime IS NULL AND TS2.Id = TSS.TestSuiteId
								   LEFT JOIN [dbo].[UserStory]US1 WITH (NOLOCK)  ON  US1.Id = US.ParentUserStoryId AND US1.InactiveDateTime IS NULL
								   LEFT JOIN TimeZone TZ ON TZ.Id = US.CreatedDateTimeZone
								   LEFT JOIN TimeZone TZ1 ON TZ1.Id = US.DeadLineDateTimeZone
								   '
		
		IF(@IsForUserStoryoverview = 1)	SET @SearchSqlScript = @SearchSqlScript + N' LEFT JOIN (SELECT UserStoryId,MAX(TransitionDateTime) TransitionDateTime
																								FROM UserStoryWorkflowStatusTransition WITH (NOLOCK)
																								GROUP BY UserStoryId) TUSInner ON TUSInner.UserStoryId = US.Id '

			IF(@TeamMemberIdsXml IS NOT NULL)
			BEGIN
				
				CREATE TABLE #TeamMember
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #TeamMember(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @TeamMemberIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #TeamMember T ON T.Id = US.OwnerUserId OR T.Id = US.DependencyUserId'

			END

			IF (@IsStatusMultiselect = 1 AND @UserStoryStatusIdsXml IS NOT NULL AND @IsGoalsPage = 0) 
			BEGIN
			
				CREATE TABLE #UserStoryStatus
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #UserStoryStatus(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @UserStoryStatusIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #UserStoryStatus USSInner ON USSInner.Id = US.UserStoryStatusId ' 

			END
			 
			  IF(@UserStoryTypeIdsXml IS NOT NULL) SET @SearchSqlScript =  @SearchSqlScript + N'     LEFT JOIN #UserStoryTypes USTT ON USTT.Id = US.UserStoryTypeId'
			  IF(@BugPriorityIdsXml IS NOT NULL)   SET @SearchSqlScript =  @SearchSqlScript + N'     LEFT JOIN #BugPriorityId BPP ON BPP.Id = US.BugPriorityId'
			  IF(@BugCausedUserIds IS NOT NULL)	SET @SearchSqlScript =	@SearchSqlScript + N'	     LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id AND BCU.InActiveDateTime IS  NULL
			                                                                                           LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId '
			  IF(@DependencyUserIds IS NOT NULL)SET @SearchSqlScript =  @SearchSqlScript + N'     LEFT JOIN #DependencyOnUser DOU ON DOU.Id= US.DependencyUserId'
			  IF(@ProjectFeatureIds IS NOT NULL)SET @SearchSqlScript =	@SearchSqlScript + N'	  LEFT JOIN #ProjectFeatures PFF ON PFF.Id = US.ProjectFeatureId'
			  IF(@UserStoryTagsXml IS NOT NULL)SET @SearchSqlScript = @SearchSqlScript + N'    AND EXISTS (SELECT [Value] FROM [dbo].[ufn_stringsplit](US.Tag,'','') WHERE [Value] In (SELECT Tag FROM #WorkItemTags) AND US.Tag IS NOT NULL) '
 
			IF (@BugPriorityIdsXml IS NOT NULL  AND @IsGoalsPage = 0)
			BEGIN
				
				CREATE TABLE #BugPriority
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #BugPriority(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @BugPriorityIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #BugPriority BPInner ON BPInner.Id = US.BugPriorityId '
				 
			END

			IF (@OwnerUserIdsXml IS NOT NULL AND @IsGoalsPage = 0)
			BEGIN
				
				CREATE TABLE #OwnerUser
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #OwnerUser(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @OwnerUserIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #OwnerUser OwnerUserInner ON (OwnerUserInner.Id = US.OwnerUserId  OR (OwnerUserInner.Id = ''00000000-0000-0000-0000-000000000000'' AND US.OwnerUserId IS NULL))'
				 
			END
			IF(@IsGoalsPage = 1 AND @IsForFilters = 1)
			BEGIN

				SET @SearchSqlScript = @SearchSqlScript + N'  LEFT JOIN (SELECT ParentUserStoryId,GoalId FROM UserStory US2 INNER JOIN UserStoryStatus USS2 ON USS2.Id = US2.UserStoryStatusId AND USS2.CompanyId  = @CompanyId 
                                                                              LEFT JOIN #UserStoryTypes UST ON UST.Id = US2.UserStoryTypeId
				                                                              LEFT JOIN #BugPriorityId BP ON UST.Id = US2.BugPriorityId
				                                                              LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US2.Id  AND BCU.InActiveDateTime IS  NULL
				                                                              LEFT JOIN #BugCausedUser BC ON BC.Id = BCU.UserId
				                                                              LEFT JOIN #DependencyOnUser DU ON DU.Id= US2.DependencyUserId
																			  LEFT JOIN #ProjectFeatures PFF ON PFF.Id = US2.ProjectFeatureId
										  WHERE (@OwnerUserIdsXml IS NULL OR (OwnerUserId IN (SELECT Id FROM #OwnerUser1) OR (US2.OwnerUserId IS NULL AND ''00000000-0000-0000-0000-000000000000'' IN (SELECT Id FROM #OwnerUser1 WHERE Id = ''00000000-0000-0000-0000-000000000000''))))
                                           AND (@UserStoryStatusIdsXml IS NULL OR UserStoryStatusId IN (SELECT Id FROM #UserStoryStatus1))
                                          
										   	AND (@UserStoryTypeIdsXml IS NULL OR UST.Id IS NOT NULL)
							                AND (@BugPriorityIdsXml IS NULL OR BP.Id IS NOT NULL)
							                AND (@BugCausedUserIds IS NULL OR BC.Id IS NOT NULL)
							                AND (@DependencyUserIds IS NULL OR DU.Id IS NOT NULL)
											AND (@ProjectFeatureIds IS NULL OR PFF.Id IS NOT NULL)
											AND (@UserStoryName IS NULL OR US2.UserStoryName LIKE  @UserStoryName)
											AND (@CreatedDateFrom IS NULL OR CAST(US2.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE))
							                AND (@CreatedDateTo IS NULL OR CAST(US2.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE))
							                AND (@UpdatedDateFrom IS NULL OR CAST(US2.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE))
							                AND (@UpdatedDateTo IS NULL OR CAST(US2.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE))
										    AND (@UserStoryTagsXml IS NULL OR  EXISTS (SELECT [Value] FROM [dbo].[ufn_stringsplit](US2.Tag,'','') WHERE [Value] In (SELECT Tag FROM #WorkItemTags) AND US2.Tag IS NOT NULL ))
											AND  (US2.UserStoryName LIKE @UserStoryName  OR @UserStoryName IS NULL)
											AND  (US2.[VersionName] LIKE  @VersionName OR @VersionName IS NULL)'
										
					IF(@IsOnTrack = 1 OR @IsNotOnTrack = 1)
					BEGIN
						
						SET @SearchSqlScript = @SearchSqlScript + N' AND (USS2.TaskStatusId <> ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'' AND US2.DeadLineDate IS NOT NULL)'

						IF(@IsBothTracked = 0)
						BEGIN
						
							IF (@IsOnTrack = 1) 
								SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,US2.DeadLineDate) >= CONVERT(DATE,GETDATE())) AND US2.DeadLineDate IS NOT NULL '
							ELSE 
								SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,US2.DeadLineDate) < CONVERT(DATE,GETDATE())) AND US2.DeadLineDate IS NOT NULL '

						END
					
					END

           SET @SearchSqlScript = @SearchSqlScript + N' AND (@DeadLineDateFrom IS NULL OR US2.DeadLineDate >= @DeadLineDateFrom)
                                           AND (US2.DeadLineDate >= @DeadLineDateFrom OR @DeadLineDateFrom IS NULL)
                                           AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (US2.InActiveDateTime IS NOT NULL)) 
                                           		  OR (@IsArchived = 0 AND (US2.InActiveDateTime IS NULL AND US2.ArchivedDateTime IS NULL)))
                                           AND (@IsParked IS NULL OR ((@IsParked = 1 AND US2.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US2.ParkedDateTime IS NULL)))
                                           GROUP BY ParentUserStoryId,GoalId) USIN ON USIN.ParentUserStoryId = US.Id AND USIN.GoalId = US.GoalId ' 

			END

			IF (@ProjectIdsXml IS NOT NULL)
			BEGIN
				
				CREATE TABLE #ProjectIds
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #ProjectIds(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @ProjectIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #ProjectIds ProjectIds ON (ProjectIds.Id = US.ProjectId)'
				 
			END

			IF (@GoalResponsiblePersonIdsXml IS NOT NULL)
			BEGIN
				
				CREATE TABLE #GoalResponsiblePersonIds
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #GoalResponsiblePersonIds(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @GoalResponsiblePersonIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				 
			END

			IF (@GoalStatusIdsXml IS NOT NULL)
			BEGIN
				
				CREATE TABLE #GoalStatusIds
				(
					Id UNIQUEIDENTIFIER
				)

				INSERT INTO #GoalStatusIds(Id)
				SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
				FROM @GoalStatusIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)

				 
			END

			IF (@UserStoryTypeIdsXml IS NOT NULL AND @IsGoalsPage = 0)
		  BEGIN
		  	
		  	CREATE TABLE #UserStoryType
		  	(
		  		Id UNIQUEIDENTIFIER
		  	)
		  
		  	INSERT INTO #UserStoryType(Id)
		  	SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
		  	FROM @UserStoryTypeIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
		  
		  	SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN #UserStoryType USInner ON USInner.Id = US.UserStoryTypeId '
		  	 
		  END

			IF(@EntityId IS NOT NULL)
			BEGIN
				
				SET @SearchSqlScript = @SearchSqlScript + N' INNER JOIN [Employee] E ON E.UserId = OU.Id
				                                             INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
															            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
								                                        AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
			
			END

			SET @SearchSqlScript = @SearchSqlScript + N'  WHERE P.CompanyId = @CompanyId
							                                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND (US.InActiveDateTime IS NOT NULL OR US.ArchivedDateTime IS NOT NULL)) 
															      OR (@IsArchived = 0 AND (US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL)))
							                                 AND (@IsParked IS NULL OR (@IsParked = 1 AND US.ParkedDateTime IS NOT NULL) OR (@IsParked = 0 AND US.ParkedDateTime IS NULL))
							                                 AND P.InactiveDateTime IS NULL 
															 ' --AND (@IsArchived = 0 OR US.ArchivedDateTime IS NULL)'

		 IF(@IsAction = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND UST.IsAction = 1 AND UST.IsAction IS NOT NULL AND UST.InActiveDateTime IS NULL '

		 IF (@ParentUserStoryId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.ParentUserStoryId = @ParentUserStoryId) AND US.GoalId = US1.GoalId'
		 
		 IF(@IsForUserStoryoverview = 1 AND @ProjectId IS NULL AND  (@ParentUserStoryId IS  NULL AND (@ISBugBoard IS NULL OR @ISBugBoard = 0)))	SET @SearchSqlScript = @SearchSqlScript + N' AND (US.ParentUserStoryId IS NULL OR (BT.IsBugBoard = 1 OR BTS.IsBugBoard = 1))'

		 IF (@UserStoryName IS NOT NULL AND @IsGoalsPage = 0) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.UserStoryName LIKE  @UserStoryName )'
		 IF (@UserStoryName IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.UserStoryName LIKE  @UserStoryName OR  USIN.ParentUserStoryId IS NOT NULL)'
		
		IF (@VersionName IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.VersionName LIKE  @VersionName OR  USIN.ParentUserStoryId IS NOT NULL)'
		 
		 IF(@IsOnTrack = 1 OR @IsNotOnTrack = 1)
		 BEGIN
			
			SET @SearchSqlScript = @SearchSqlScript + N' AND ((TS.Id <> ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'' AND US.DeadLineDate IS NOT NULL) 
			                                                   OR USIN.ParentUserStoryId IS NOT NULL
															  )'

			IF(@IsBothTracked = 0)
			BEGIN
			
				IF (@IsOnTrack = 1) 
					SET @SearchSqlScript = @SearchSqlScript + N' AND ((CONVERT(DATE,US.DeadLineDate) >= CONVERT(DATE,GETDATE()) AND US.DeadLineDate IS NOT NULL)  
					                                                   OR USIN.ParentUserStoryId IS NOT NULL
																	  )'
				ELSE IF (@IsNotOnTrack = 1)
					SET @SearchSqlScript = @SearchSqlScript + N' AND ( ( CONVERT(DATE,US.DeadLineDate) < CONVERT(DATE,GETDATE()) AND US.DeadLineDate IS NOT NULL) 
					                                                   OR  USIN.ParentUserStoryId IS NOT NULL
																	  )'

			END
		 
		 END

		 IF (@UserStoryId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.Id = @UserStoryId)'
		  
         IF (@ProjectName IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (P.ProjectName = @ProjectName)'
            
         IF (@EstimatedTime IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.EstimatedTime = @EstimatedTime)' 
            
         IF (@DeadLineDate IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DeadLineDate = @DeadLineDate)' 
            
         IF (@OwnerUserId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.OwnerUserId = @OwnerUserId OR @OwnerUserIdsXml IS NOT NULL)' 

		 IF (@UserStoryUniqueName IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N'AND (US.UserStoryUniqueName = @UserStoryUniqueName)'

		 --IF (@UserStoryTags IS NOT NULL AND @IsGoalsPage = 0) SET @SearchSqlScript = @SearchSqlScript + N' AND (@UserStoryTags LIKE ''%''+ US.Tag + ''%'' )'

		--  IF (@UserStoryTags IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (@UserStoryTags LIKE ''%''+ US.Tag + ''%''   OR  USIN.ParentUserStoryId IS NOT NULL)'

		 IF (@GoalTags IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.Tag LIKE @GoalTags)'
            
         IF (@DependencyUserId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DependencyUserId = @DependencyUserId)' 

         IF (@GoalResponsiblePersonId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.GoalResponsibleUserId = @GoalResponsiblePersonId)' 
            
         IF (@Order IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.[Order] = @Order)' 

		 IF (@Order IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.[Order] = @Order)' 

         IF (@GoalName IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.GoalName LIKE @GoalName OR G.GoalShortName LIKE @GoalName)' 

		 IF(@CreatedDateFrom IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (CAST(US.CreatedDateTime AS DATE) >= CAST(@CreatedDateFrom AS DATE) OR USIN.ParentUserStoryId IS NOT NULL)'  
		 IF(@CreatedDateTo IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (CAST(US.CreatedDateTime AS DATE) <= CAST(@CreatedDateTo AS DATE) OR USIN.ParentUserStoryId IS NOT NULL)'  
		 IF(@UpdatedDateFrom IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (CAST(US.UpdatedDateTime AS DATE) >= CAST(@UpdatedDateFrom AS DATE) OR USIN.ParentUserStoryId IS NOT NULL)'  
		 IF(@UpdatedDateTo IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1)  SET @SearchSqlScript = @SearchSqlScript + N' AND (CAST(US.UpdatedDateTime AS DATE) <= CAST(@UpdatedDateTo AS DATE) OR USIN.ParentUserStoryId IS NOT NULL)'  
          
		 IF(@IsMyWorkOnly = 1) SET @SearchSqlScript = @SearchSqlScript + N'
		                                                                    AND G.ParkedDateTime IS NULL 
																			AND G.InActiveDateTime IS NULL 
																			AND S.InActiveDateTime IS NULL
																			AND (GS.IsActive = 1 OR ((S.IsReplan = 0 OR S.IsREplan IS NULL) AND S.SprintStartDate IS NOT NULL))'
		 IF(@IsActiveGoalsOnly = 1) SET @SearchSqlScript = @SearchSqlScript + N'
		                                                                    AND G.ParkedDateTime IS NULL 
																			AND G.InActiveDateTime IS NULL 
																			AND (GS.IsActive = 1)'
		 IF(@GoalStatusId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND G.ParkedDateTime IS NULL 
																			AND G.InActiveDateTime IS NULL
																			AND G.GoalStatusId = @GoalStatusId 
																			AND US.ProjectId = @ProjectId
																			AND US.ParentUserStoryId IS NULL
																			AND US.SprintId IS NULL'

		 IF(@IsMyWorkOnly = 1 AND @TeamMemberIdsXml IS NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.OwnerUserId = @OperationsPerformedBy OR US.DependencyUserId = @OperationsPerformedBy)' 
			  
         IF (@ActualDeadLineDate IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.ActualDeadLineDate = @ActualDeadLineDate)' 
            
         IF (@UserStoryTypeId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.UserStoryTypeId = @UserStoryTypeId)' 
            
         IF (@ProjectFeatureId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.ProjectFeatureId = @ProjectFeatureId)' 

		 IF (@UserStoryStatusId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.UserStoryStatusId = @UserStoryStatusId)' 

		 IF (@IsProductive = 1 ) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.Isproductiveboard = @IsProductive)' 
		 
		 IF (@IsTracked = 1 ) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.IsToBeTracked = @IsTracked)' 


		 IF (@GoalResponsiblePersonIdsXml IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.GoalResponsibleUserId  IN (SELECT Id FROM #GoalResponsiblePersonIds))' 
		 
		 IF (@GoalStatusIdsXml IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (G.GoalStatusId IN (SELECT Id FROM #GoalStatusIds))' 
		 
		 	IF(@UserStoryTypeIdsXml IS NOT NULL) SET @SearchSqlScript =  @SearchSqlScript + N'    	AND (USIN.ParentUserStoryId IS NOT NULL OR USTT.Id IS NOT NULL) '
			IF(@BugPriorityIdsXml IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1)   SET @SearchSqlScript =  @SearchSqlScript + N' AND (USIN.ParentUserStoryId IS NOT NULL OR BPP.Id IS NOT NULL) '
			IF(@BugCausedUserIds IS NOT NULL)	SET @SearchSqlScript =	@SearchSqlScript + N'   AND (USIN.ParentUserStoryId IS NOT NULL OR BC.Id IS NOT NULL) '
			IF(@DependencyUserIds IS NOT NULL)SET @SearchSqlScript =  @SearchSqlScript + N'     AND (USIN.ParentUserStoryId IS NOT NULL OR DOU.Id IS NOT NULL) '
			IF(@ProjectFeatureIds IS NOT NULL)SET @SearchSqlScript =	@SearchSqlScript + N'	AND (USIN.ParentUserStoryId IS NOT NULL OR PFF.Id IS NOT NULL) '
        
         IF (@Order IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.[Order] = @Order)' 

		 IF(@UserStoryTagsXml IS NOT NULL)SET @SearchSqlScript = @SearchSqlScript + N'    AND EXISTS (SELECT [Value] FROM [dbo].[ufn_stringsplit](US.Tag,'','') WHERE [Value] In (SELECT Tag FROM #WorkItemTags) AND US.Tag IS NOT NULL) '
 

		  IF (@OwnerUserIdsXml IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1)
		  BEGIN
		  
		  	SET @SearchSqlScript = @SearchSqlScript + N'  AND ((US.OwnerUserId IN (SELECT Id FROM #OwnerUser1) OR (US.OwnerUserId IS NULL AND ''00000000-0000-0000-0000-000000000000'' IN (SELECT Id FROM #OwnerUser1 WHERE Id = ''00000000-0000-0000-0000-000000000000''))) OR USIN.ParentUserStoryId IS NOT NULL)'
		  	 
		   END
		   IF (@IsStatusMultiselect = 1 AND @UserStoryStatusIdsXml IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) 
			BEGIN
			
				SET @SearchSqlScript = @SearchSqlScript + N'  AND (US.UserStoryStatusId IN (SELECT Id FROM #UserStoryStatus1) OR  USIN.ParentUserStoryId IS NOT NULL )' 

			END
          
         IF (@DependencyText IS NOT NULL)
         BEGIN

            IF (@DependencyText = 'DependencyOnMe') SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DependencyUserId = @OperationsPerformedBy) AND G.InactiveDateTime IS NULL AND GS.IsActive = 1 AND G.ParkedDateTime IS NULL AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL)' 
            ELSE 
            BEGIN

                IF (@DependencyText = 'DependencyOnOthers') SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DependencyUserId <> @OperationsPerformedBy AND US.DependencyUserId IS NOT NULL) 
				                                                                                         AND P.InactiveDateTime IS NULL AND G.InactiveDateTime IS NULL AND GS.IsActive = 1 
																										 AND G.ParkedDateTime IS NULL AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL 
																										 AND US.ParkedDateTime IS NULL 
																										 AND OU.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)) 
																										 AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL)'
				
                ELSE IF (@DependencyText = 'ImminentDeadLine') SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.GoalId IS NOT NULL AND US.DeadLineDate > @DateFrom AND US.DeadLineDate <= @DateTo) OR (US.SprintId IS NOT NULL AND S.SprintStartDate > @DateFrom OR S.SprintEndDate <= @DateTo)) 
				                                                                                            AND (USS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'' 
																											     OR USS.TaskStatusId = ''166DC7C2-2935-4A97-B630-406D53EB14BC'' 
																												 OR USS.TaskStatusId = ''F2B40370-D558-438A-8982-55C052226581'')
				                                                                                            AND ((G.InactiveDateTime IS NULL AND G.ParkedDateTime IS NULL) OR S.InActiveDateTime IS NULL)
																											AND USS.CompanyId = @CompanyId
																											AND (((GS.IsActive = 1 OR GS.IsActive IS NULL) AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL)) OR (S.IsReplan = 0 AND S.SprintStartDate IS NOT NULL)) 
																											AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL 
																											AND US.ParkedDateTime IS NULL AND P.InActiveDateTime IS NULL 
																											AND OU.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))'

                ELSE IF (@DependencyText = 'CurrentUserStories') SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.GoalId IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) =  CONVERT(DATE,GETDATE())) OR (US.SprintId IS NOT NULL AND CONVERT(DATE,S.SprintStartDate) = CONVERT(DATE,GETDATE()) AND CONVERT(DATE,S.SprintEndDate) =  CONVERT(DATE,GETDATE()))) 
				AND (USS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'' OR USS.TaskStatusId = ''166DC7C2-2935-4A97-B630-406D53EB14BC'' OR USS.TaskStatusId = ''F2B40370-D558-438A-8982-55C052226581'')
																											  AND USS.CompanyId = @CompanyId
																											  AND G.InactiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND S.InActiveDateTime IS NULL 
																											  AND ((GS.IsActive = 1 OR GS.IsActive IS NULL) AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL))
																											  AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL 
																											  AND P.InActiveDateTime IS NULL AND OU.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))'

				ELSE IF (@DependencyText = 'PreviousUserStories') SET @SearchSqlScript = @SearchSqlScript + N' AND CONVERT(DATE,US.DeadLineDate) < CONVERT(DATE,GETDATE()) AND (USS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'' OR USS.TaskStatusId = ''166DC7C2-2935-4A97-B630-406D53EB14BC'' OR USS.TaskStatusId = ''F2B40370-D558-438A-8982-55C052226581'')
																											   AND USS.CompanyId = @CompanyId
																											   AND G.InactiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND (GS.IsActive = 1 OR GS.IsActive IS NULL) 
																											   AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL) AND US.InactiveDateTime IS NULL 
																											   AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL AND P.InActiveDateTime IS NULL 
																											   AND OU.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))'

				ELSE IF (@DependencyText = 'FutureUserStories') SET @SearchSqlScript = @SearchSqlScript + N' AND CONVERT(DATE,US.DeadLineDate) > CONVERT(DATE,GETDATE()) AND (USS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'' OR USS.TaskStatusId = ''166DC7C2-2935-4A97-B630-406D53EB14BC'' OR USS.TaskStatusId = ''F2B40370-D558-438A-8982-55C052226581'')
																											 AND USS.CompanyId = @CompanyId
																											 AND G.InactiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
																											 AND (GS.IsActive = 1 OR GS.IsActive IS NULL) AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL) 
																											 AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL 
																											 AND P.InActiveDateTime IS NULL AND OU.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))'

                ELSE IF (@DependencyText = 'Current working/Backlog User Stories') SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DeadLineDate <= @Currentdate+1) AND (USS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'' OR USS.TaskStatusId = ''166DC7C2-2935-4A97-B630-406D53EB14BC'' OR USS.TaskStatusId = ''F2B40370-D558-438A-8982-55C052226581'')
																																AND USS.CompanyId = @CompanyId
																															    AND G.InactiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
																																AND (GS.IsActive = 1 OR GS.IsActive IS NULL) AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL) 
																																AND US.InactiveDateTime IS NULL AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL 
																																AND P.InActiveDateTime IS NULL AND OU.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId))'
				
			END

		 END

         IF (@DeadLineDateFrom IS NOT NULL AND @IsGoalsPage = 0) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DeadLineDate >= @DeadLineDateFrom)' 

         IF (@DeadLineDateFrom IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DeadLineDate >= @DeadLineDateFrom OR   USIN.ParentUserStoryId IS NOT NULL)' 
            
         IF (@DeadLineDateTo IS NOT NULL AND @IsGoalsPage = 0) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DeadLineDate <= @DeadLineDateTo)' 

         IF (@DeadLineDateTo IS NOT NULL AND @IsGoalsPage = 1 AND @IsForFilters = 1) SET @SearchSqlScript = @SearchSqlScript + N' AND (US.DeadLineDate <= @DeadLineDateTo OR  USIN.ParentUserStoryId IS NOT NULL)' 
          
         IF (@SearchText IS NOT NULL) 
		 BEGIN

			SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.UserStoryName LIKE @SearchText)
                                                                                        OR (P.ProjectName LIKE @SearchText)
                                                                                        OR (G.GoalName LIKE @SearchText)
                                                                                        OR (OU.FirstName +'' ''+ ISNULL(OU.SurName,'''') LIKE @SearchText)
                                                                                        OR (DU.FirstName +'' ''+ ISNULL(DU.SurName,'''') LIKE @SearchText)
                                                                                        OR (FORMAT(US.EstimatedTime,''g15'')  LIKE @SearchText)
                                                                                        OR (SUBSTRING(CONVERT(VARCHAR, US.DeadLineDate, 106),1,2) + ''-'' + SUBSTRING(CONVERT(VARCHAR, US.DeadLineDate, 106),4,3) + ''-''+ CONVERT(VARCHAR,DATEPART(YEAR,US.DeadLineDate))  LIKE @SearchText) 
																						OR (CONVERT(VARCHAR,DATEPART(DAY,US.DeadLineDate)) +  ''-'' + SUBSTRING(CONVERT(VARCHAR, US.DeadLineDate, 106),4,3) +  ''-'' + CONVERT(VARCHAR,DATEPART(YEAR,US.DeadLineDate)) LIKE @SearchText)
																						OR (US.UserStoryUniqueName LIKE @SearchText)
																						OR (G.GoalUniqueName LIKE @SearchText)
																						OR (REPLACE(S.SprintUniqueName,'' '','''') LIKE @SearchText)'
		
			IF(@DependencyText IS NULL)  SET @SearchSqlScript = @SearchSqlScript + N' OR (G.GoalShortName LIKE @SearchText)   
																						OR (US.Tag LIKE @SearchText)
                                                                                        OR (BUU.FirstName +'' ''+ ISNULL(BUU.SurName,'''') LIKE @SearchText)
                                                                                        OR (RU.FirstName +'' ''+ ISNULL(RU.SurName,'''') LIKE @SearchText)
                                                                                        OR (USS.[Status]  LIKE @SearchText)
                                                                                        OR (UST.UserStoryTypeName  LIKE @SearchText))'
			ELSE SET @SearchSqlScript = @SearchSqlScript + N') '

		END

		IF (@SearchText IS NOT NULL AND (@DependencyText = 'CurrentUserStories' OR @DependencyText = 'PreviousUserStories' OR @DependencyText = 'FutureUserStories')) SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.UserStoryName LIKE @SearchText)
                                                                                        OR (OU.FirstName +'' ''+ ISNULL(OU.SurName,'''') LIKE @SearchText)
                                                                                        OR (FORMAT(US.EstimatedTime,''g15'')  LIKE @SearchText))'

         IF (@SearchText IS NOT NULL AND @DependencyText = 'Current working/Backlog User Stories') SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.UserStoryName LIKE @SearchText)
                                                                                        OR (P.ProjectName LIKE @SearchText)
                                                                                        OR (G.GoalName LIKE @SearchText)
                                                                                        OR (OU.FirstName +'' ''+ ISNULL(OU.SurName,'''') LIKE @SearchText)
                                                                                        OR (FORMAT(US.EstimatedTime,''g15'')  LIKE @SearchText))'

		IF (@SearchText IS NOT NULL AND (@DependencyText = 'DependencyOnMe' )) SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.UserStoryName LIKE @SearchText)
                                                                                        OR (P.ProjectName LIKE @SearchText)
                                                                                        OR (G.GoalName LIKE @SearchText))'

		IF (@SearchText IS NOT NULL AND (@DependencyText = 'DependencyOnOthers' )) SET @SearchSqlScript = @SearchSqlScript + N' AND ((US.UserStoryName LIKE @SearchText)
                                                                                        OR (P.ProjectName LIKE @SearchText)
                                                                                        OR (G.GoalName LIKE @SearchText)
                                                                                        OR (DU.FirstName +'' ''+ ISNULL(DU.SurName,'''') LIKE @SearchText))'

		IF (@SearchText IS NOT NULL AND (@DependencyText = 'ImminentDeadLine' )) SET @SearchSqlScript = @SearchSqlScript + N'  AND ((US.UserStoryName LIKE @SearchText)
                                                                                        OR (OU.FirstName +'' ''+ ISNULL(OU.SurName,'''') LIKE @SearchText)
                                                                                        OR (SUBSTRING(CONVERT(VARCHAR, US.DeadLineDate, 106),1,2) + ''-'' + SUBSTRING(CONVERT(VARCHAR, US.DeadLineDate, 106),4,3) + ''-''+ CONVERT(VARCHAR,DATEPART(YEAR,US.DeadLineDate))  LIKE @SearchText) 
																						OR (CONVERT(VARCHAR,DATEPART(DAY,US.DeadLineDate)) +  ''-'' + SUBSTRING(CONVERT(VARCHAR, US.DeadLineDate, 106),4,3) +  ''-'' + CONVERT(VARCHAR,DATEPART(YEAR,US.DeadLineDate)) LIKE @SearchText))'

		IF (@PageSize IS NOT NULL AND @PageSize > 0) SET @SearchSqlScript = @SearchSqlScript + N' ORDER BY ' +  @SortBy + ' ' + @SortDirection + N'
                                                                                                 OFFSET @Skip ROWS 
                                                                                                 FETCH NEXT @pageSize ROWS ONLY'

	   
        EXEC SP_EXECUTESQL @SearchSqlScript,
        N'@UserStoryId UNIQUEIDENTIFIER,
          @GoalId UNIQUEIDENTIFIER,
          @UserStoryName NVARCHAR(250),
          @EstimatedTime DATETIME,
          @DeadLineDate DATETIME,
          @OwnerUserId UNIQUEIDENTIFIER,
          @DependencyUserId UNIQUEIDENTIFIER,
          @Order INT,
          @UserStoryStatusId UNIQUEIDENTIFIER,
          @ActualDeadLineDate DATETIME,
          @BugPriorityIdsXml XML,
          @UserStoryTypeId UNIQUEIDENTIFIER,
          @ProjectFeatureId UNIQUEIDENTIFIER,
          @IsParked BIT,
          @IsArchived BIT,
          @SearchText NVARCHAR(100) ,
          @SortBy NVARCHAR(100) ,
          @SortDirection VARCHAR(50),
          @PageSize INT ,
          @PageNumber INT ,
          @OperationsPerformedBy UNIQUEIDENTIFIER,
          @DependencyText NVARCHAR(250),
		  @UserStoryUniqueName NVARCHAR(100),
          @DeadLineDateFrom DATETIME,
          @DeadLineDateTo DATETIME,
          @Skip INT,
          @CompanyId UNIQUEIDENTIFIER,
          @ProjectId UNIQUEIDENTIFIER,
          @ProjectName NVARCHAR(250),
          @DateFrom DATETIME,
          @DateTo DATETIME,
		  @IsAutoLog BIT,
		  @EnableSprints BIT,
		  @EnableTestRepo BIT,
		  @EnableBugBoards BIT,
		  @EnableStartStop BIT,
          @Currentdate DATETIME,
		  @TeamMemberIdsXml XML,
		  @IsMyWorkOnly BIT,
		  @UserStoryStatusIdsXml XML,
		  @IsForUserStoryoverview BIT,
		  @ParentUserStoryId UNIQUEIDENTIFIER,
		  @UserStoryIdsXml XML,
		  @OwnerUserIdsXml XML,
		  @GoalStatusId UNIQUEIDENTIFIER,
		  @GoalName NVARCHAR(500),
		  @UserStoryTags NVARCHAR(250),
		  @UserStoryTypeIdsXml XML,
		  @IsAction BIT,
		  @IsTracked BIT = NULL,
          @IsProductive BIT = NULL,
		  @VersionName NVARCHAR(500) = NULL,
          @BugCausedUserIds XML,
          @DependencyUserIds XML,
          @ProjectFeatureIds XML,
	      @UpdatedDateFrom DATETIME = NULL,
          @UpdatedDateTo DATETIME = NULL,
	      @CreatedDateFrom DATETIME = NULL,
          @CreatedDateTo DATETIME = NULL,
		  @UserStoryTagsXml XML,
		  @GoalTags NVARCHAR(250)',
          @UserStoryId,
          @GoalId,
          @UserStoryName,
          @EstimatedTime,
          @DeadLineDate,
          @OwnerUserId,
          @DependencyUserId,
          @Order,
          @UserStoryStatusId,
          @ActualDeadLineDate,
          @BugPriorityIdsXml,
          @UserStoryTypeId,
          @ProjectFeatureId,
          @IsParked,
          @IsArchived,
          @SearchText,
          @SortBy,
          @SortDirection,
          @PageSize,
          @PageNumber,
          @OperationsPerformedBy,
          @DependencyText,
		  @UserStoryUniqueName,
          @DeadLineDateFrom ,
          @DeadLineDateTo,
          @Skip,
          @CompanyId,
          @ProjectId,
          @ProjectName,
          @DateFrom,
          @DateTo,
		  @IsAutoLog,
		  @EnableSprints,
		  @EnableTestRepo,
		  @EnableBugBoards,
		  @EnableStartStop,
          @Currentdate,
		  @TeamMemberIdsXml,
		  @IsMyWorkOnly,
		  @UserStoryStatusIdsXml,
		  @IsForUserStoryoverview,
		  @ParentUserStoryId,
		  @UserStoryIdsXml,
		  @OwnerUserIdsXml,
		  @GoalStatusId,
		  @GoalName,
		  @UserStoryTags,
		  @UserStoryTypeIdsXml,
		  @IsAction,
		  @IsTracked ,
	      @IsProductive ,
		  @VersionName ,
          @BugCausedUserIds ,
          @DependencyUserIds ,
          @ProjectFeatureIds ,
	      @UpdatedDateFrom ,
          @UpdatedDateTo ,
	      @CreatedDateFrom ,
          @CreatedDateTo,
		  @UserStoryTagsXml,
		  @GoalTags

    END TRY  
    BEGIN CATCH 
        
         THROW

    END CATCH
END

GO