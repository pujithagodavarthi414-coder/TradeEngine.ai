-------------------------------------------------------------------------------
-- Author      Geetha Ch
-- Created      '2020-02-01 00:00:00.000'
-- Purpose      To Get Work Items By Logged In UserId
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchWorkItemsByLoggedInId] @OperationsPerformedBy='EB4013EC-1F8E-43AE-89A4-996B3EE61BCA',@IsIncludeUnAssigned = 0--@UserStoryId='15fd4787-a637-4d11-95a2-b9099d613ef6'
--@UserStoryStatusIdsXml='
--<GenericListOfGuid>
--<ListItems>
--<guid>19eec7a9-805c-4d76-9d3b-5085d92d2731</gtuid>
--</ListItems>
--</GenericListOfGuid>'

CREATE PROCEDURE [dbo].[USP_SearchWorkItemsByLoggedInId]
(
    @SearchText NVARCHAR(250) = NULL,
    @Tags NVARCHAR(250) = NULL,
    @BugPriorityIdsXml XML = NULL,  
    @UserStoryStatusIdsXml XML = NULL,
    @UserStoryTypeIdsXml XML = NULL,
    @UserIdsXml XML = NULL,
    @ActionCategoryIdsXml XML = NULL,
    @BranchIdsXml XML = NULL,
	@UserStoryIdsXml XML = NULL,
    @IsIncludeUnAssigned BIT = 1,
	@IsExcludeOthers BIT = 1,
    @IsAction BIT = NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
    @UserStoryId UNIQUEIDENTIFIER = NULL,
	@WorkspaceDashboardId UNIQUEIDENTIFIER = NULL,
	@IsUserActions BIT = 0,
	@IsMyWork BIT = 0,
    @IsSameUser BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @BusinessUnitIds NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY
        
        IF(@SearchText = '') SET @SearchText = NULL
        
		IF(@Tags = '') SET @Tags = NULL

        IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL
		
        IF(@IsAction IS NULL) SET @IsAction = 0
        
		CREATE TABLE #BugPriorityIds 
		(
			Id UNIQUEIDENTIFIER 
		)

		 IF(@SearchText IS NOT NULL)SET @SearchText =  '%'+ @SearchText + '%' 
       
	     IF(@Tags IS NOT NULL)SET @Tags =  '%'+ @Tags + '%' 


		CREATE TABLE #UserStoryStatusIds
		(
			Id UNIQUEIDENTIFIER 
		)
			
		CREATE TABLE #UserStoryTypeIds
		(
			Id UNIQUEIDENTIFIER 
		)

        CREATE TABLE #UserIds
		(
			Id UNIQUEIDENTIFIER 
		)

        CREATE TABLE #BranchIds
		(
			Id UNIQUEIDENTIFIER 
		)

		 CREATE TABLE #UserStoryIds
		(
			Id UNIQUEIDENTIFIER 
		)
        
		CREATE TABLE #ActionCategoryIds
		(
			Id UNIQUEIDENTIFIER 
		)

	

		IF(@BugPriorityIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #BugPriorityIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @BugPriorityIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END
		
		IF(@UserStoryStatusIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #UserStoryStatusIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @UserStoryStatusIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END

		IF(@UserIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #UserIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @UserIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END

		IF(@ActionCategoryIdsXml IS NOT NULL)
		BEGIN

		    INSERT INTO #ActionCategoryIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @ActionCategoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END

        IF(@BranchIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #BranchIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @BranchIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END
        IF(@UserStoryTypeIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #UserStoryTypeIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @UserStoryTypeIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END

		IF(@UserStoryIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #UserStoryIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @UserStoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)
		END

		IF(@IsIncludeUnAssigned IS NULL) SET @IsIncludeUnAssigned = 0

        IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL

		IF(@WorkspaceDashboardId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceDashboardId = NULL

        IF(@PageSize IS NULL) SET @PageSize = 1000
        
        IF(@PageNumber IS NULL) SET @PageNumber = 1

        IF(@IsSameUser IS NULL) SET @IsSameUser = 1

		IF(@IsUserActions IS NULL)SET @IsUserActions = 0
        
        DECLARE @CompanyId UNIQUEIDENTIFIER =  (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
		
        DECLARE @IsActionsPage BIT = CASE WHEN ISNULL(@IsAction,0) = 1 AND ISNULL(@IsUserActions,0) = 0 THEN 1 ELSE 0 END

		SELECT  DISTINCT ChildId
		INTO #EmployeeReportedMembers
		FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)

        DECLARE @AdHocWorkFlowId UNIQUEIDENTIFIER = (SELECT Id FROM Workflow WHERE CompanyId = @CompanyId AND WorkFlow = 'Adhoc Workflow' AND InactiveDateTime IS NULL)
        
        DECLARE @AdhocProjectId UNIQUEIDENTIFIER = (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Adhoc project' AND InActiveDateTime IS NULL)
        DECLARE @InductionProjectId UNIQUEIDENTIFIER = (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Induction project' AND InActiveDateTime IS NULL)
		DECLARE @ExitProjectId UNIQUEIDENTIFIER = (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Exit project' AND InActiveDateTime IS NULL)

		CREATE TABLE #Projects
		(
		 ProjectId UNIQUEIDENTIFIER
		)
		INSERT INTO #Projects 
		SELECT Id FROM Project WHERE Id IN (SELECT  ProjectId FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) AND InActiveDateTime IS NULL

		INSERT INTO #Projects(ProjectId)
		SELECT @AdhocProjectId

		INSERT INTO #Projects(ProjectId)
		SELECT @InductionProjectId

		INSERT INTO #Projects(ProjectId)
		SELECT @ExitProjectId

        DECLARE @HavePermission NVARCHAR(500)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
		DECLARE @EnableStartStop BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%')
		IF(@IsExcludeOthers IS NULL) SET @IsExcludeOthers = 1
        IF (@HavePermission = '1')
        BEGIN
            
            SELECT InnerUS.* 
                   ,(SELECT COUNT(1) AS BugsCount
                     FROM UserStory TUS
                          INNER JOIN UserStoryType UST ON UST.Id = TUS.UserStoryTypeId AND InnerUS.UserStoryId = TUS.Id
                                     AND UST.InActiveDateTime IS NULL AND TUS.ParkedDateTime IS NULL
                                     AND TUS.InActiveDateTime IS NULL AND UST.IsBug = 1 AND UST.CompanyId = @CompanyId
                          INNER JOIN UserStoryStatus USS ON USS.Id = TUS.UserStoryStatusId
                                     AND USS.InActiveDateTime IS NULL AND TUS.ParentUserStoryId IS NOT NULL
                                     AND USS.TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76') --Verification completed,Done
                          LEFT JOIN [UserStoryScenario] USSE ON USSE.TestCaseId = TUS.TestCaseId AND USSE.InActiveDateTime IS NULL
                          WHERE  (TUS.TestCaseId IS NULL OR USSE.TestCaseId IS NOT NULL)
                      ) AS BugsCount
                   ,(SELECT MAX(TransitionDateTime) TransitionDateTime
                            FROM UserStoryWorkflowStatusTransition WITH (NOLOCK)
                            WHERE UserStoryId = InnerUS.UserStoryId
                     ) AS TransitionDateTime
				,(SELECT  CASE WHEN (select Top(1) UserStoryId from UserStorySpentTime USPt
								  where USPt.UserStoryId = InnerUS.UserStoryId AND USPt.StartTime IS NOT NULL  AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy
								  GROUP BY UserStoryId) IS NULL THEN 1 ELSE 0 END ) AutoLog
				,(SELECT BreakType From UserStorySpentTime USPt  where USPt.UserStoryId = InnerUS.UserStoryId AND  USPt.UserId = @OperationsPerformedBy
							AND TimeStamp = (SELECT Max(TimeStamp) From UserStorySpentTime where UserStoryId = InnerUS.UserStoryId AND UserId = @OperationsPerformedBy )
							) BreakType
				,(select top(1) CAST(USPT.StartTime AS  datetime) StartTime  from UserStorySpentTime USPT
						where USPT.UserStoryId = InnerUS.UserStoryId AND USPT.StartTime IS NOT NULL AND USPT.EndTime IS NULL  AND  USPT.UserId = @OperationsPerformedBy) StartTime
				,(select top(1)CAST( USPt.EndTime AS datetime)EndTime  from UserStorySpentTime USPt
						where USPt.UserStoryId = InnerUS.UserStoryId AND USPt.StartTime IS NOT NULL AND USPT.EndTime IS NULL AND  USPt.UserId = @OperationsPerformedBy) EndTime
                ,(CASE WHEN ((InnerUS.IsDateTimeConfiguration = 1 AND SYSDATETIMEOFFSET() > InnerUS.DeadLineDate)
                                OR (InnerUS.IsDateTimeConfiguration = 0 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,InnerUS.DeadLineDate)))
                            AND (InnerUS.TaskStatusId IN ('F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')) --ToDo,Inprogress
                          THEN 1 ELSE 0 END) AS IsOnTrack
				,CASE WHEN InnerUS.ProjectId = @AdhocProjectId OR @InductionProjectId = InnerUS.ProjectId OR @ExitProjectId = InnerUS.ProjectId THEN 1 ELSE 0 END AS IsAdhocUserStory
				,(SELECT CF.Id AS CustomFieldId,
										CF.FieldName AS FormName,
										CF.FormKeys,
										CFF.FormDataJson,
										CFF.CreatedDateTime FROM [dbo].[CustomField] CF
										INNER JOIN [dbo].[CustomFormFieldMapping] CFF ON CFF.FormId = CF.Id AND CFF.FormReferenceId = InnerUS.UserStoryId
										 WHERE CF.InactiveDateTime IS NULL AND CF.CompanyId = @CompanyId
										FOR XML PATH('UserStoryCustomFieldsModel'), ROOT('UserStoryCustomFieldsModel'), TYPE) AS UserStoryCustomFieldsXml

            FROM (
                  SELECT * 
                  FROM 
                    (SELECT US.Id AS UserStoryId
                   ,US.UserStoryName
                   ,OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS OwnerName
                   ,DU.FirstName + ' ' + ISNULL(DU.SurName,'') AS DependencyName
                   ,US.EstimatedTime
                   ,US.DeadLineDate
				   ,US.CreatedDateTime
                   ,US.VersionName
                   ,USS.[Status] AS UserStoryStatusName
                   ,USS.StatusHexValue AS UserStoryStatusColor
				   ,TSS.[Order] StatusOrder
                   ,USS.Id AS UserStoryStatusId
                   ,OU.Id AS OwnerUserId
                   ,DU.Id AS DependencyUserId
                   ,US.ParentUserStoryId
                   ,OU.ProfileImage AS OwnerProfileImage
                   ,DU.ProfileImage AS DependencyProfileImage
                   ,US.BugPriorityId
				   ,US.ReferenceId
				   ,US.ReferenceTypeId
                   ,BP.PriorityName AS BugPriority
                   ,BP.[Description] AS BugPriorityDescription
                   ,BP.Color AS BugPriorityColor
				   ,(SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%IsWorkItemStartFunctionalityRequired%') AS IsAutoLog 
				   ,@EnableStartStop AS IsEnableStartStop
                   ,BCU.UserId AS BugCausedUserId
                   ,PUS.GoalId AS ParentUserStoryGoalId
                   ,G.TestSuiteId
                   ,US.TestSuiteSectionId
                   ,US.TestCaseId
                   ,US.UserStoryTypeId
                   ,UST.IsBug AS IsBugBoard
                   ,BCUD.FirstName + ' ' + ISNULL(BCUD.SurName,'') AS BugCausedUserName
                   ,BCUD.ProfileImage AS BugCausedUserProfileImage
                   ,BP.Icon
                   ,US.[Order]
				   ,US.ActionCategoryId
				   ,ACC.ActionCategoryName
                   ,PF.ProjectFeatureName
                   ,P.Id AS ProjectId
				   ,P.IsDateTimeConfiguration
                   ,G.Id AS GoalId
                   ,US.[TimeStamp]
                   ,PF.Id AS ProjectFeatureId
                   ,US.UserStoryUniqueName
                   ,GS.Id AS GoalStatusId
                   ,US.Tag
				   ,US.SprintId
				   ,S.SprintName
				   ,S.InActiveDateTime AS SprintInActiveDateTime
				   ,US.WorkflowId AS WorkflowId
                   --,WFS.Id AS WorkFlowStatusId
                   ,UST.Color AS UserStoryTypeColor
                   ,USS.TaskStatusId
                   ,UST.IsFillForm
                   ,UST.IsLogTimeRequired
                   ,UST.IsAction
                   ,US.CustomApplicationId
				   ,US.WorkFlowTaskId
				   ,US.FormId
                   ,US.GenericFormSubmittedId
				   ,CASE WHEN US.GoalId IS NULL AND US.SprintId IS NOT NULL THEN 1
				         WHEN US.GoalId IS NOT NULL AND US.SprintId IS NULL THEN 0
						 ELSE NULL
						 END AS IsSprintUserStory,
                   S.IsReplan AS isReplan,
				   S.SprintStartDate AS sprintStartDate,
				   S.SprintEndDate AS sprintEndDate
                   ,CASE WHEN US.SprintId IS NOT NULL THEN 1 ELSE 0 END AS IsFromSprints,
				   (SELECT AC.Id FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id = US.AuditConductQuestionId) ConductId,
				   (SELECT ACQ.QuestionId FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id =  US.AuditConductQuestionId) QuestionId,
				   (SELECT ACQ.Id FROM AuditConduct AC JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = AC.Id AND ACQ.Id =  US.AuditConductQuestionId) AuditConductQuestionId,
				   TotalCount = COUNT(1) OVER()
            FROM UserStory US
			     INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL
                            AND P.InActiveDateTime IS NULL
                            AND P.CompanyId = @CompanyId
                 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
                            AND USS.InActiveDateTime IS NULL
                 INNER JOIN TaskStatus TSS ON TSS.Id = USS.TaskStatusId
				  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
                            AND UST.InActiveDateTime IS NULL
                 LEFT JOIN Goal G ON G.Id = US.GoalId
                            AND US.InActiveDateTime IS NULL
                            AND US.ParkedDateTime IS NULL
                            AND G.InActiveDateTime IS NULL
				 LEFT JOIN Sprints S ON S.Id = US.SprintId
				            AND US.InActiveDateTime IS NULL
							AND US.ParkedDateTime IS NULL
							AND S.InActiveDateTime IS NULL
							AND (S.IsReplan = 0 OR S.IsReplan IS NULL) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
				 LEFT JOIN ActionCategory ACC ON ACC.Id = US.ActionCategoryId AND ACC.InActiveDateTime IS NULL
				-- LEFT JOIN 
				--(SELECT distinct ACO.ProjectId, ACO.Id ConductId, ACQ.Id ConductQuestionId, ACQ.Id AuditConductQuestionId, ACQ.QuestionId FROM 
				--AuditConduct ACO 
				--JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACO.Id AND ACO.InActiveDateTime Is NULL
				--AND ACQ.InActiveDateTime IS NULL)
				--AQ ON AQ.ProjectId = US.ProjectId
                 --LEFT JOIN WorkflowStatus WFS ON WFS.UserStoryStatusId = USS.Id
                 LEFT JOIN [User] OU ON OU.Id = US.OwnerUserId
                            AND OU.InActiveDateTime IS NULL AND OU.IsActive = 1
                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
                            AND GS.IsActive = 1
                 LEFT JOIN GoalWorkFlow GF ON GF.GoalId = G.Id
                            AND GF.InActiveDateTime IS NULL
                 LEFT JOIN [User] DU ON DU.Id = US.DependencyUserId
                            AND DU.InActiveDateTime IS NULL AND DU.IsActive = 1
                 LEFT JOIN UserStory PUS ON PUS.Id = US.ParentUserStoryId
                            AND PUS.InActiveDateTime IS NULL
                            AND PUS.ParkedDateTime IS NULL
                 LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
                           AND BP.InActiveDateTime IS NULL
                 LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
                           AND BCU.InActiveDateTime IS NULL
                 LEFT JOIN [User] BCUD ON BCUD.Id = BCU.UserId
                            AND BCUD.InActiveDateTime IS NULL
                 LEFT JOIN ProjectFeature PF ON PF.Id = US.ProjectFeatureId
                           AND PF.InactiveDateTime IS NULL
				LEFT JOIN WorkspaceDashboards WD ON WD.Id = US.WorkspaceDashboardId
							AND WD.InActiveDateTime IS NULL
                LEFT JOIN #UserIds UI ON @IsAction = 1 AND UI.Id = US.OwnerUserId
                LEFT JOIN Employee E ON @IsAction = 1 AND E.UserId = US.OwnerUserId
                LEFT JOIN EmployeeBranch EB ON @IsAction = 1 AND EB.EmployeeId = E.Id
                LEFT JOIN #BranchIds BI ON @IsAction = 1 AND BI.Id = EB.BranchId
				LEFT JOIN #EmployeeReportedMembers ER ON ER.ChildId = US.OwnerUserId
				LEFT JOIN #ActionCategoryIds AC ON AC.Id = US.ActionCategoryId
				LEFT JOIN #Projects P1 ON P1.ProjectId = US.ProjectId
                WHERE (@SearchText IS NULL OR US.UserStoryName LIKE  @SearchText)
					  AND (@Tags IS NULL OR US.Tag LIKE  @Tags )
					  AND (ISNULL(@IsMyWork,0) = 0 OR P1.ProjectId IS NOT NULL)
					  AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
                      AND (@BusinessUnitIds IS NULL 
                             OR E.Id IN (SELECT EmployeeId 
                                        FROM [Ufn_GetAccessibleMembersForBusinessUnit]((SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy),@BusinessUnitIds,@CompanyId))) --TODO
					  AND (@IsUserActions = 0 OR US.OwnerUserId = @OperationsPerformedBy)
					  AND (@UserStoryId IS NULL OR @UserStoryId IS NOT NULL OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
					  AND (@BugPriorityIdsXml IS NULL OR US.BugPriorityId IN (SELECT Id FROM #BugPriorityIds))
					  AND (@ProjectId IS NULL OR P.Id = @ProjectId)
					  AND (@UserStoryStatusIdsXml IS NULL OR US.UserStoryStatusId IN (SELECT Id FROM #UserStoryStatusIds))
					  AND (@UserStoryTypeIdsXml IS NULL OR US.UserStoryTypeId IN (SELECT Id FROM #UserStoryTypeIds))
                    	  AND (@UserStoryIdsXml IS NULL OR US.Id IN (SELECT Id FROM #UserStoryIds))
                      AND (@UserStoryIdsXml IS NOT NULL OR (@UserStoryId IS NULL OR US.Id = @UserStoryId))
					  AND (@UserStoryIdsXml IS NOT NULL 
                           OR (US.OwnerUserId IS NULL 
                               OR OU.Id = @OperationsPerformedBy 
                               --OR US.CreatedByUserId = @OperationsPerformedBy 
                               OR @IsActionsPage = 1 
                               OR ((US.ProjectId = @AdhocProjectId OR US.ProjectId = @InductionProjectId OR US.ProjectId = @ExitProjectId ) AND ER.ChildId IS NOT NULL)) 
                           OR US.AuditConductQuestionId IS NOT NULL)
                    AND (@UserStoryIdsXml IS NOT NULL OR (GS.IsActive = 1 OR (P.Id = @AdhocProjectId OR P.Id = @InductionProjectId OR P.Id = @ExitProjectId) OR (S.IsReplan = 0 AND S.SprintStartDate IS NOT NULL)))
                    AND (@UserStoryId IS NULL OR US.Id = @UserStoryId)
					 --AND (@IsIncludeUnAssigned = 0 OR (@IsIncludeUnAssigned = 1 AND (US.OwnerUserId IS  NULL
					 --OR (P.Id IN (SELECT ProjectId FROM  UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) OR P.ProjectName = 'Adhoc project'))
					 -- OR US.Id IN (SELECT UST.UserStoryId from UserStorySpentTime UST WHERE UST.StartTime is not null and UST.EndTime IS NULL ) ))
					 AND ((@IsIncludeUnAssigned = 0 AND (P.Id IN (SELECT ProjectId FROM  UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) OR P.Id = @AdhocProjectId OR P.Id = @ExitProjectId OR P.Id = @InductionProjectId)) 
					 OR (@IsIncludeUnAssigned = 1 AND US.OwnerUserId IS NOT NULL 
					        OR US.Id IN (SELECT UST.UserStoryId FROM UserStorySpentTime UST WHERE UST.StartTime IS NOT NULL AND UST.EndTime IS NULL ) ))
					  AND (@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (ISNULL(UST.IsBug,0) = 0)))
                     AND (@IsAction = 0 AND (@UserStoryIdsXml IS NOT NULL OR (@UserStoryStatusIdsXml IS NULL AND  (USS.TaskStatusId NOT IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76') OR P.Id = @AdhocProjectId OR P.Id = @InductionProjectId OR P.Id = @ExitProjectId)) OR 
					  (@UserStoryStatusIdsXml IS NOT NULL OR P.Id = @AdhocProjectId OR P.Id = @InductionProjectId OR P.Id = @ExitProjectId)) OR @IsAction = 1)
					  AND ( (@IsAction = 1 AND UST.IsAction = 1 AND US.OwnerUserId IS NOT NULL ) 
                            OR(ISNULL(@IsAction,0) = 0 AND ((@UserStoryIdsXml IS NOT NULL OR ((US.OwnerUserId IS NULL OR OU.Id = @OperationsPerformedBy) 
							OR ((US.ProjectId = @AdhocProjectId OR US.ProjectId = @InductionProjectId OR US.ProjectId = @ExitProjectId )) 
							OR ((US.ProjectId = @AdhocProjectId OR US.ProjectId = @InductionProjectId OR US.ProjectId = @ExitProjectId) AND ER.ChildId IS NOT NULL))) OR (@IsSameUser = 0 AND @UserStoryId IS NOT NULL AND US.Id = @UserStoryId))))
                      --AND (@IsAction = 0 AND ((@UserStoryStatusIdsXml IS NULL AND  (USS.TaskStatusId NOT IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76') OR P.Id = @AdhocProjectId OR P.Id = @InductionProjectId)) OR 
					   --(@UserStoryStatusIdsXml IS NOT NULL OR P.Id = @AdhocProjectId OR P.Id = @InductionProjectId)) OR @IsAction = 1)
                      AND ( ((@WorkspaceDashboardId IS  NULL AND (((@IsExcludeOthers = 1 AND US.WorkspaceDashboardId IS NOT NULL) OR (@IsExcludeOthers = 1 AND  US.WorkspaceDashboardId IS NULL)) OR (ISNULL(@IsExcludeOthers,0) = 0 AND US.WorkspaceDashboardId IS NULL)))
					   OR  (@WorkspaceDashboardId IS NOT NULL AND (((@IsExcludeOthers = 1 AND US.WorkspaceDashboardId IS NOT NULL)OR (@IsExcludeOthers = 1 AND  US.WorkspaceDashboardId IS NULL)) OR (ISNULL(@IsExcludeOthers,0) = 0 AND US.WorkspaceDashboardId = @WorkspaceDashboardId))))) 
					  
					  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                     AND (@UserIdsXml IS NULL OR UI.Id IS NOT NULL)
                     AND (@ActionCategoryIdsXml IS NULL OR AC.Id IS NOT NULL)
                     AND (@BranchIdsXml IS NULL OR BI.Id IS NOT NULL)) TT
                ORDER BY  
				CASE WHEN TT.DeadLineDate IS  NULL THEN  1 END ASC
				    ,TT.DeadLineDate,StatusOrder,UserStoryStatusName,
                    --CASE WHEN @IsAction = 0 THEN StartTime END DESC,
                    CASE WHEN @IsAction = 1 THEN CAST(DeadLineDate AS SQL_VARIANT) END ASC,
                    CASE WHEN @IsAction = 1 THEN CAST([Order] AS SQL_VARIANT) END ASC
                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                FETCH NEXT @pageSize ROWS ONLY	
           ) InnerUS

        END
        ELSE
        BEGIN
            RAISERROR (@HavePermission,11, 1)
        END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO