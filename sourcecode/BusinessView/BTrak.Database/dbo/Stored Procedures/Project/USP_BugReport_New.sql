-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-12 00:00:00.000'
-- Purpose      To Get Bug Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_BugReport_New]@OperationsPerformedBy='721363AB-037A-4506-A1B8-B3C2C17F594B',@ShowGoalLevel='1'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_BugReport_New]
(
   @SelectedDate DATETIME = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @AssigneeId UNIQUEIDENTIFIER = NULL,
   @ShowGoalLevel BIT = 1,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @ProjectFeatureId UNIQUEIDENTIFIER=NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(100)=NULL,
   @SearchText  NVARCHAR(100)=NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
    
	IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

	
	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN
	IF(@SelectedDate IS NULL)
	BEGIN
		SELECT @SelectedDate = GETUTCDATE()
	END

	IF(@ProjectId = '00000000-0000-0000-0000-000000000000')
	BEGIN
			SET @ProjectId = NULL
	END

	IF(@AssigneeId = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SET @AssigneeId = NULL
	END
	
	SET @SearchText = '%'+ @SearchText+'%'

	IF(@SortDirection IS NULL )
	BEGIN
		SET @SortDirection = 'ASC'
	END

	IF(@SortBy IS NULL)
	BEGIN	
		SET @SortBy = 'ParameterName'	
	END

	DECLARE @SelectedDate1 DATE = CONVERT(DATE,@SelectedDate)

   IF(@ShowGoalLevel = 0)
   BEGIN
	

	SELECT  ParameterName
	       ,GL.P0Left 
		   ,GL.P1Left 
		   ,GL.P2Left 
		   ,GL.P3Left 
		   ,GL.P0Fixed
		   ,GL.P1Fixed
		   ,GL.P2Fixed
		   ,GL.P3Fixed
		   ,GL.P0Added
		   ,GL.P1Added
		   ,GL.P2Added
		   ,GL.P3Added
	       ,GL.P0Approved
		   ,GL.P1Approved 
		   ,GL.P2Approved
		   ,GL.P3Approved
		   ,GL.P0UnAssigned
		   ,GL.P1UnAssigned 
		   ,GL.P2UnAssigned
		   ,GL.P3UnAssigned
		   ,GL.NoPriority
		   ,GL.NoPriorityAdded
	       ,COUNT(1)OVER() AS TotalCount 
	FROM(
			SELECT ISNULL(G.GoalShortName,G.GoalName) AS ParameterName
			       ,ISNULL(Bug.P0Left,0) P0Left
				   ,ISNULL(Bug.P1Left,0) P1Left
				   ,ISNULL(Bug.P2Left,0) P2Left
				   ,ISNULL(Bug.P3Left,0) P3Left
				   ,ISNULL(Bug.P0Fixed,0) P0Fixed
				   ,ISNULL(Bug.P1Fixed,0) P1Fixed
				   ,ISNULL(Bug.P2Fixed,0) P2Fixed
				   ,ISNULL(Bug.P3Fixed,0) P3Fixed
				   ,ISNULL(Bug.P0Added,0) P0Added
				   ,ISNULL(Bug.P1Added,0) P1Added
				   ,ISNULL(Bug.P2Added,0) P2Added
				   ,ISNULL(Bug.P3Added,0) P3Added				  
				   ,ISNULL(Bug.P0Approved,0) P0Approved
				   ,ISNULL(Bug.P1Approved,0) P1Approved
				   ,ISNULL(Bug.P2Approved,0) P2Approved
				   ,ISNULL(Bug.P3Approved,0) P3Approved
				   ,ISNULL(Bug.P0UnAssigned,0) P0UnAssigned
				   ,ISNULL(Bug.P1UnAssigned,0) P1UnAssigned
				   ,ISNULL(Bug.P2UnAssigned,0) P2UnAssigned
				   ,ISNULL(Bug.P3UnAssigned,0) P3UnAssigned
				   ,ISNULL(Bug.NoPriority,0) NoPriority
				   ,ISNULL(Bug.NoPriorityAdded,0) NoPriorityAdded
				  
			FROM Goal G 
			     INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
				            AND GS.IsActive = 1 AND GS.InactiveDateTime IS NULL
				 INNER JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId
				            AND P.InactiveDateTime IS NULL
				 INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId 
				            AND BT.InactiveDateTime IS NULL AND BT.IsBugBoard = 1
			    LEFT JOIN (
							SELECT COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsCritical = 1 THEN 1 ELSE NULL END) AS P0Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsHigh = 1 THEN 1  END) AS P1Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsMedium = 1 THEN 1  END) AS P2Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsLow = 1 THEN 1  END) AS P3Left
								   ,COUNT(CASE WHEN BP.IsCritical = 1 AND T.UserStoryId IS NOT NULL THEN 1  END) AS P0Fixed
						           ,COUNT(CASE WHEN BP.IsHigh = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P1Fixed
						           ,COUNT(CASE WHEN BP.IsMedium = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P2Fixed
						           ,COUNT(CASE WHEN BP.IsLow = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P3Fixed
								   ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsCritical = 1 AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D') THEN 1  END) AS P0Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsHigh = 1 AND     (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')  THEN 1  END) AS P1Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsMedium = 1 AND   (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')  THEN 1  END) AS P2Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsLow = 1 AND      (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')  THEN 1  END) AS P3Approved
								   ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsCritical = 1 THEN 1 END) AS P0Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsHigh = 1 THEN 1  END) AS P1Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsMedium = 1 THEN 1  END) AS P2Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsLow = 1 THEN 1  END) AS P3Added
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsCritical = 1  THEN 1  END)  AS P0UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsHigh = 1  THEN 1  END)  AS P1UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsMedium = 1  THEN 1  END)  AS P2UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsLow = 1  THEN 1 END)  AS P3UnAssigned
								   ,COUNT(CASE WHEN  US.OwnerUserId IS NULL AND US.BugPriorityId IS NULL THEN 1  END) AS NoPriority
								   ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND US.BugPriorityId IS NULL THEN 1  END) as NoPriorityAdded
								   ,US.GoalId
							FROM UserStory US  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1 AND UST.CompanyId = @CompanyId AND UST.InActiveDateTime IS NULl
							     INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = @CompanyId
								            AND USS.InactiveDateTime IS NULL
											AND US.ArchivedDateTime IS NULL
								LEFT JOIN (
					                        SELECT UW.UserStoryId
								            FROM
								             UserStoryWorkflowStatusTransition UW --ON US.Id = UW.UserStoryId 
											 INNER JOIN (SELECT UserStoryId,MAX(TransitionDateTime) TransitionDateTime FROM UserStoryWorkflowStatusTransition GROUP BY UserStoryId) UWInner 
											 ON UWInner.TransitionDateTime = UW.TransitionDateTime AND UWInner.UserStoryId = UW.UserStoryId
					                         INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
				                                        AND CONVERT(DATE,UW.TransitionDateTime) = @SelectedDate1
					                         INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId  AND TUSS.CompanyId = @CompanyId
					                                    AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
					             ) T ON T.UserStoryId = US.Id
								 INNER JOIN Goal G ON G.Id = US.GoalId
								            AND G.InactiveDateTime IS NULL
								 INNER JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId
											AND P.InactiveDateTime IS NULL
								 INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
								            AND BT.InactiveDateTime IS NULL
											AND BT.IsBugBoard = 1
								 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
								            AND GS.InactiveDateTime IS NULL
								 LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
								            AND BP.InactiveDateTime IS NULL
								 LEFT JOIN [User] U ON U.Id = US.OwnerUserId 
								            AND U.InActiveDateTime IS NULL AND U.IsActive = 1
								 LEFT JOIN [Employee] E ON E.UserId = U.Id
								 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
											AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
											AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							WHERE CAST(US.CreatedDateTime AS DATE) <= @SelectedDate1
							      AND (@ProjectId IS NULL OR @ProjectId = G.ProjectId)
							      AND (@ProjectFeatureId IS NULL OR US.ProjectFeatureId = @ProjectFeatureId)
							      AND (@AssigneeId IS NULL OR @AssigneeId = US.OwnerUserId)
								  AND US.InactiveDateTime IS NULL
								  AND US.ParkedDateTime IS NULL
								  AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							GROUP BY US.GoalId
			             ) Bug ON G.Id = Bug.GoalId
					WHERE (@ProjectId IS NULL OR @ProjectId = G.ProjectId)
					UNION ALL
					SELECT S.SprintName AS ParameterName
			       ,ISNULL(Bug.P0Left,0) P0Left
				   ,ISNULL(Bug.P1Left,0) P1Left
				   ,ISNULL(Bug.P2Left,0) P2Left
				   ,ISNULL(Bug.P3Left,0) P3Left
				   ,ISNULL(Bug.P0Fixed,0) P0Fixed
				   ,ISNULL(Bug.P1Fixed,0) P1Fixed
				   ,ISNULL(Bug.P2Fixed,0) P2Fixed
				   ,ISNULL(Bug.P3Fixed,0) P3Fixed
				   ,ISNULL(Bug.P0Added,0) P0Added
				   ,ISNULL(Bug.P1Added,0) P1Added
				   ,ISNULL(Bug.P2Added,0) P2Added
				   ,ISNULL(Bug.P3Added,0) P3Added
				   ,ISNULL(Bug.P0Approved,0) P0Approved
				   ,ISNULL(Bug.P1Approved,0) P1Approved
				   ,ISNULL(Bug.P2Approved,0) P2Approved
				   ,ISNULL(Bug.P3Approved,0) P3Approved
				   ,ISNULL(Bug.P0UnAssigned,0) P0UnAssigned
				   ,ISNULL(Bug.P1UnAssigned ,0) P1UnAssigned 
				   ,ISNULL(Bug.P2UnAssigned,0) P2UnAssigned
				   ,ISNULL(Bug.P3UnAssigned,0) P3UnAssigned
				    ,ISNULL(Bug.NoPriority,0) NoPriority
					,ISNULL(Bug.NoPriorityAdded,0) NoPriorityAdded
				   
			FROM Sprints S 
			     INNER JOIN Project P ON P.Id = S.ProjectId AND P.CompanyId = @CompanyId
				            AND P.InactiveDateTime IS NULL
							 AND S.InactiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) 
										AND S.SprintStartDate IS  NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
				 INNER JOIN BoardType BT ON BT.Id = S.BoardTypeId 
				            AND BT.InactiveDateTime IS NULL AND BT.IsBugBoard = 1
			    LEFT JOIN (
							SELECT COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsCritical = 1 THEN 1  END) AS P0Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsHigh = 1 THEN 1  END) AS P1Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsMedium = 1 THEN 1  END) AS P2Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsLow = 1 THEN 1  END) AS P3Left
								   ,COUNT(CASE WHEN BP.IsCritical = 1 AND T.UserStoryId IS NOT NULL THEN 1  END) AS P0Fixed
						           ,COUNT(CASE WHEN BP.IsHigh = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P1Fixed
						           ,COUNT(CASE WHEN BP.IsMedium = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P2Fixed
						           ,COUNT(CASE WHEN BP.IsLow = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P3Fixed
								   ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsCritical = 1  AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D') THEN 1  END) AS P0Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsHigh = 1      AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')  THEN 1  END) AS P1Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsMedium = 1    AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')  THEN 1 ELSE NULL END) AS P2Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsLow = 1       AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D')  THEN 1 ELSE NULL END) AS P3Approved
								   ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsCritical = 1 THEN 1 ELSE NULL END) AS P0Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsHigh = 1 THEN 1 ELSE NULL END) AS P1Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsMedium = 1 THEN 1  END) AS P2Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsLow = 1 THEN 1  END) AS P3Added
								  	,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsCritical = 1  THEN 1  END)  AS P0UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsHigh = 1  THEN 1  END)  AS P1UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsMedium = 1  THEN 1  END)  AS P2UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsLow = 1  THEN 1  END)  AS P3UnAssigned
								   ,COUNT(CASE WHEN  US.OwnerUserId IS NULL AND US.BugPriorityId IS NULL THEN 1  END) AS NoPriority
								   ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1  AND US.BugPriorityId IS NULL THEN 1  END) NoPriorityAdded
								   ,US.SprintId
							FROM UserStory US INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1 AND UST.CompanyId = @CompanyId AND UST.InActiveDateTime IS NULl
							     INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = @CompanyId
								            AND US.InactiveDateTime IS NULL
								            AND USS.InactiveDateTime IS NULL
											AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL 
								LEFT JOIN (
					                        SELECT UW.UserStoryId
								            FROM
								             UserStoryWorkflowStatusTransition UW --ON US.Id = UW.UserStoryId 
											 INNER JOIN (SELECT UserStoryId,MAX(TransitionDateTime) TransitionDateTime FROM UserStoryWorkflowStatusTransition GROUP BY UserStoryId) UWInner 
											 ON UWInner.TransitionDateTime = UW.TransitionDateTime AND UWInner.UserStoryId = UW.UserStoryId
					                         INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
				                                        AND CONVERT(DATE,UW.TransitionDateTime) = @SelectedDate1
					                         INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId AND TUSS.CompanyId = @CompanyId
					                                    AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
					             ) T On T.UserStoryId = US.Id
								 INNER JOIN Sprints S ON S.Id = US.SprintId AND S.InactiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS  NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
								            
								 INNER JOIN Project P ON P.Id = S.ProjectId AND P.CompanyId = @CompanyId
											AND P.InactiveDateTime IS NULL
								 INNER JOIN BoardType BT ON BT.Id = S.BoardTypeId
								            AND BT.InactiveDateTime IS NULL
											AND BT.IsBugBoard = 1								 
								 LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
								            AND BP.InactiveDateTime IS NULL
								 LEFT JOIN [User] U ON U.Id = US.OwnerUserId 
								            AND U.InActiveDateTime IS NULL AND U.IsActive = 1
								 LEFT JOIN [Employee] E ON E.UserId = U.Id
								 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
											AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
											AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							WHERE CAST(US.CreatedDateTime AS DATE) <= @SelectedDate
							      AND (@ProjectId IS NULL OR @ProjectId = S.ProjectId)
							      AND (@ProjectFeatureId IS NULL OR US.ProjectFeatureId = @ProjectFeatureId)
							      AND (@AssigneeId IS NULL OR @AssigneeId = US.OwnerUserId)
								  AND US.InactiveDateTime IS NULL
								  AND US.ParkedDateTime IS NULL
								  AND  (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							GROUP BY US.SprintId
			             ) Bug ON S.Id = Bug.SprintId
					WHERE (@ProjectId IS NULL OR @ProjectId = S.ProjectId)
					)	GL 
				WHERE(@SearchText IS NULL OR (((CONVERT(NVARCHAR(250), GL.ParameterName) LIKE  @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Approved) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0UnAssigned) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Approved) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1UnAssigned) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Approved) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2UnAssigned) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3Approved) LIKE @SearchText)
								                OR (CONVERT(NVARCHAR(250),GL.P3Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.NoPriority) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3UnAssigned) LIKE @SearchText))))
																													
				ORDER BY 
				CASE WHEN( @SortDirection= 'DESC' )THEN
                    CASE WHEN @SortBy = 'ParameterName' THEN Cast(GL.ParameterName as sql_variant) 
                           WHEN @SortBy = 'P0Added' THEN GL.P0Added
							WHEN @SortBy = 'P0Approved' THEN GL.P0Approved
							WHEN @SortBy = 'P0Fixed' THEN GL.P0Fixed
							WHEN @SortBy = 'P0Left' THEN GL.P0Left
							WHEN @SortBy = 'P0UnAssigned' THEN GL.P0UnAssigned
							WHEN @SortBy = 'P1Added' THEN GL.P1Added
							WHEN @SortBy = 'P1Approved' THEN GL.P1Approved
							WHEN @SortBy = 'P1Fixed' THEN GL.P1Fixed
							WHEN @SortBy = 'P1Left' THEN GL.P1Left
							WHEN @SortBy = 'P1UnAssigned' THEN GL.P1UnAssigned
							WHEN @SortBy = 'P2Added' THEN GL.P2Added
							WHEN @SortBy = 'P2Approved' THEN GL.P2Approved
							WHEN @SortBy = 'P2Fixed' THEN GL.P2Fixed
							WHEN @SortBy = 'P2Left' THEN GL.P2Left
							WHEN @SortBy = 'P2UnAssigned' THEN GL.P2UnAssigned
							WHEN @SortBy = 'P3Added' THEN GL.P3Added
							WHEN @SortBy = 'P3Approved' THEN GL.P3Approved
							WHEN @SortBy = 'P3Fixed' THEN GL.P3Fixed
							WHEN @SortBy = 'P3Left' THEN GL.P3Left
							WHEN @SortBy = 'P3UnAssigned' THEN GL.P3UnAssigned
							WHEN @SortBy = 'NoPriority' THEN GL.NoPriority
                        END
                END DESC,
                CASE WHEN @SortDirection = 'ASC' THEN
                        CASE WHEN @SortBy = 'ParameterName' THEN Cast(GL.ParameterName as sql_variant) 
                           WHEN @SortBy = 'P0Added' THEN GL.P0Added
							WHEN @SortBy = 'P0Approved' THEN GL.P0Approved
							WHEN @SortBy = 'P0Fixed' THEN GL.P0Fixed
							WHEN @SortBy = 'P0Left' THEN GL.P0Left
							WHEN @SortBy = 'P0UnAssigned' THEN GL.P0UnAssigned
							WHEN @SortBy = 'P1Added' THEN GL.P1Added
							WHEN @SortBy = 'P1Approved' THEN GL.P1Approved
							WHEN @SortBy = 'P1Fixed' THEN GL.P1Fixed
							WHEN @SortBy = 'P1Left' THEN GL.P1Left
							WHEN @SortBy = 'P1UnAssigned' THEN GL.P1UnAssigned
							WHEN @SortBy = 'P2Added' THEN GL.P2Added
							WHEN @SortBy = 'P2Approved' THEN GL.P2Approved
							WHEN @SortBy = 'P2Fixed' THEN GL.P2Fixed
							WHEN @SortBy = 'P2Left' THEN GL.P2Left
							WHEN @SortBy = 'P2UnAssigned' THEN GL.P2UnAssigned
							WHEN @SortBy = 'P3Added' THEN GL.P3Added
							WHEN @SortBy = 'P3Approved' THEN GL.P3Approved
							WHEN @SortBy = 'P3Fixed' THEN GL.P3Fixed
							WHEN @SortBy = 'P3Left' THEN GL.P3Left
							WHEN @SortBy = 'P3UnAssigned' THEN GL.P3UnAssigned
							WHEN @SortBy = 'NoPriority' THEN GL.NoPriority
                    END
                END ASC

				OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                FETCH NEXT @PageSize ROWS ONLY															
   END
   ELSE
   BEGIN

	 	 SELECT GL.P0Left 
		   ,GL.P1Left 
		   ,GL.P2Left 
		   ,GL.P3Left 
		   ,GL.P0Fixed
		   ,GL.P1Fixed
		   ,GL.P2Fixed
		   ,GL.P3Fixed
		   ,GL.P0Added
		   ,GL.P1Added
		   ,GL.P2Added
		   ,GL.P3Added
	       ,GL.P0Approved
		   ,GL.P1Approved 
		   ,GL.P2Approved
		   ,GL.P3Approved
		   ,GL.P0UnAssigned
		   ,GL.P1UnAssigned 
		   ,GL.P2UnAssigned
		   ,GL.P3UnAssigned
		   ,GL.NoPriority
		   ,ParameterName
		   ,NoPriorityAdded
	       ,COUNT(1)OVER() AS TotalCount 
	FROM(
			SELECT P.ProjectName AS ParameterName
			       ,ISNULL(SUM(Bug.P0Left),0) P0Left
				   ,ISNULL(SUM(Bug.P1Left),0) P1Left
				   ,ISNULL(SUM(Bug.P2Left),0) P2Left
				   ,ISNULL(SUM(Bug.P3Left),0) P3Left
				   ,ISNULL(SUM(Bug.P0Fixed),0) P0Fixed
				   ,ISNULL(SUM(Bug.P1Fixed),0) P1Fixed
				   ,ISNULL(SUM(Bug.P2Fixed),0) P2Fixed
				   ,ISNULL(SUM(Bug.P3Fixed),0) P3Fixed
				   ,ISNULL(SUM(Bug.P0Added),0) P0Added
				   ,ISNULL(SUM(Bug.P1Added),0) P1Added
				   ,ISNULL(SUM(Bug.P2Added),0) P2Added
				   ,ISNULL(SUM(Bug.P3Added),0) P3Added
				   ,ISNULL(SUM(Bug.P0Approved),0) P0Approved
				   ,ISNULL(SUM(Bug.P1Approved),0) P1Approved
				   ,ISNULL(SUM(Bug.P2Approved),0) P2Approved
				   ,ISNULL(SUM(Bug.P3Approved),0) P3Approved
				    ,ISNULL(SUM(Bug.P0UnAssigned),0) P0UnAssigned
				   ,ISNULL(SUM(Bug.P1UnAssigned),0) P1UnAssigned
				   ,ISNULL(SUM(Bug.P2UnAssigned),0) P2UnAssigned
				   ,ISNULL(SUM(Bug.P3UnAssigned),0) P3UnAssigned
				   ,ISNULL(SUM(Bug.NoPriority),0) NoPriority
			       ,ISNULL(SUM(Bug.NoPriorityAdded),0)  NoPriorityAdded
			FROM Project P 
			     LEFT JOIN (
							SELECT COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsCritical = 1 THEN 1  END) AS P0Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsHigh = 1 THEN 1  END) AS P1Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsMedium = 1 THEN 1  END) AS P2Left
							       ,COUNT(CASE WHEN (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0') AND BP.IsLow = 1 THEN 1  END) AS P3Left
								   ,COUNT(CASE WHEN BP.IsCritical = 1 AND T.UserStoryId IS NOT NULL THEN 1  END) AS P0Fixed
						           ,COUNT(CASE WHEN BP.IsHigh = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P1Fixed
						           ,COUNT(CASE WHEN BP.IsMedium = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P2Fixed
						           ,COUNT(CASE WHEN BP.IsLow = 1 AND T.UserStoryId IS NOT NULL  THEN 1  END) AS P3Fixed
								   ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsCritical = 1 AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D' ) THEN 1  END) AS P0Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsHigh = 1 AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'     OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D' ) THEN 1  END) AS P1Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsMedium = 1 AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'   OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D' ) THEN 1  END) AS P2Approved
						           ,COUNT(CASE WHEN CONVERT(DATE,US.UpdatedDateTime) = @SelectedDate1 AND BP.IsLow = 1 AND (USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'      OR  USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D' ) THEN 1  END) AS P3Approved
								   ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsCritical = 1 THEN 1  END) AS P0Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsHigh = 1 THEN 1  END) AS P1Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsMedium = 1 THEN 1  END) AS P2Added
						           ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1 AND BP.IsLow = 1 THEN 1  END) AS P3Added
								   ,COUNT(CASE WHEN CONVERT(DATE,US.CreatedDateTime) = @SelectedDate1  AND US.BugPriorityId IS NULL THEN 1  END) NoPriorityAdded
								   	,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsCritical = 1  THEN 1  END)  AS P0UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsHigh = 1  THEN 1  END)  AS P1UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsMedium = 1  THEN 1  END)  AS P2UnAssigned
								   ,COUNT(CASE WHEN US.OwnerUserId iS null AND BP.IsLow = 1  THEN 1  END)  AS P3UnAssigned
								   ,COUNT(CASE WHEN  US.OwnerUserId IS NULL AND US.BugPriorityId IS NULL THEN 1  END) AS NoPriority
								   ,US.GoalId
								   ,US.SprintId
								   ,GoalName
								   ,SprintName
								   ,US.ProjectId
							FROM UserStory US INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1 AND UST.CompanyId = @CompanyId AND UST.InActiveDateTime IS NULl
							     INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = @CompanyId
								            AND US.InactiveDateTime IS NULL
								            AND USS.InactiveDateTime IS NULL
											AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL
								LEFT JOIN (
					                        SELECT UW.UserStoryId
								            FROM
								             UserStoryWorkflowStatusTransition UW --ON US.Id = UW.UserStoryId 
											 INNER JOIN (SELECT UserStoryId,MAX(TransitionDateTime) TransitionDateTime FROM UserStoryWorkflowStatusTransition GROUP BY UserStoryId) UWInner 
											 ON UWInner.TransitionDateTime = UW.TransitionDateTime AND UWInner.UserStoryId = UW.UserStoryId
					                         INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
				                                        AND CONVERT(DATE,UW.TransitionDateTime) = @SelectedDate1
					                         INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId AND TUSS.CompanyId = @CompanyId
					                                    AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
					             ) T On T.UserStoryId = US.Id
								 LEFT JOIN Goal G ON G.Id = US.GoalId
								            AND G.InactiveDateTime IS NULL
								 INNER JOIN Project P ON P.Id = US.ProjectId AND P.CompanyId = @CompanyId
											AND P.InactiveDateTime IS NULL
								 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId
								            AND BT.InactiveDateTime IS NULL
											AND BT.IsBugBoard = 1								 
								 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
								            AND GS.InactiveDateTime IS NULL
								 LEFT JOIN Sprints S ON S.Id = US.SprintId and S.InactiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
								           AND S.SprintStartDate IS  NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
								 LEFT JOIN BoardType BT1 ON BT1.Id = S.BoardTypeId
								            AND BT1.InactiveDateTime IS NULL
											AND BT1.IsBugBoard = 1
								 LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
								            AND BP.InactiveDateTime IS NULL
								 LEFT JOIN [User] U ON U.Id = US.OwnerUserId 
								            AND U.InActiveDateTime IS NULL AND U.IsActive = 1
								 LEFT JOIN [Employee] E ON E.UserId = U.Id 
								 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
											AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
											AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							WHERE CAST(US.CreatedDateTime AS DATE) <= @SelectedDate
							      AND (@ProjectId IS NULL OR @ProjectId = US.ProjectId)
							      AND (@ProjectFeatureId IS NULL OR US.ProjectFeatureId = @ProjectFeatureId)
							      AND (@AssigneeId IS NULL OR @AssigneeId = US.OwnerUserId)
								  AND US.InactiveDateTime IS NULL
								  AND US.ParkedDateTime IS NULL
								  AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
								  AND ((US.GoalId IS NOT NULL AND BT.Id IS NOT NULL) OR (BT1.Id IS NOT NULL AND US.SprintId IS NOT NULL ))
							GROUP BY US.GoalId,US.SprintId,GoalName,SprintName,US.ProjectId
			             ) Bug ON P.Id = Bug.ProjectId
					WHERE (@ProjectId IS NULL OR @ProjectId = P.Id)
					      AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
					GROUP BY P.ProjectName
					)	GL 
				WHERE(@SearchText IS NULL OR (((CONVERT(NVARCHAR(250), GL.ParameterName) LIKE  @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Approved) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P0UnAssigned) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Approved) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P1UnAssigned) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Approved) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P2UnAssigned) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3Added) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3Approved) LIKE @SearchText)
								                OR (CONVERT(NVARCHAR(250),GL.P3Fixed) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3Left) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.NoPriority) LIKE @SearchText)
												OR (CONVERT(NVARCHAR(250),GL.P3UnAssigned) LIKE @SearchText))))
																													
				ORDER BY 
				CASE WHEN( @SortDirection= 'DESC' )THEN
                    CASE WHEN @SortBy = 'ParameterName' THEN Cast(GL.ParameterName as sql_variant) 
                           WHEN @SortBy = 'P0Added' THEN GL.P0Added
							WHEN @SortBy = 'P0Approved' THEN GL.P0Approved
							WHEN @SortBy = 'P0Fixed' THEN GL.P0Fixed
							WHEN @SortBy = 'P0Left' THEN GL.P0Left
							WHEN @SortBy = 'P0UnAssigned' THEN GL.P0UnAssigned
							WHEN @SortBy = 'P1Added' THEN GL.P1Added
							WHEN @SortBy = 'P1Approved' THEN GL.P1Approved
							WHEN @SortBy = 'P1Fixed' THEN GL.P1Fixed
							WHEN @SortBy = 'P1Left' THEN GL.P1Left
							WHEN @SortBy = 'P1UnAssigned' THEN GL.P1UnAssigned
							WHEN @SortBy = 'P2Added' THEN GL.P2Added
							WHEN @SortBy = 'P2Approved' THEN GL.P2Approved
							WHEN @SortBy = 'P2Fixed' THEN GL.P2Fixed
							WHEN @SortBy = 'P2Left' THEN GL.P2Left
							WHEN @SortBy = 'P2UnAssigned' THEN GL.P2UnAssigned
							WHEN @SortBy = 'P3Added' THEN GL.P3Added
							WHEN @SortBy = 'P3Approved' THEN GL.P3Approved
							WHEN @SortBy = 'P3Fixed' THEN GL.P3Fixed
							WHEN @SortBy = 'P3Left' THEN GL.P3Left
							WHEN @SortBy = 'P3UnAssigned' THEN GL.P3UnAssigned
							WHEN @SortBy = 'NoPriority' THEN GL.NoPriority
                        END
                END DESC,
                CASE WHEN @SortDirection = 'ASC' THEN
                        CASE WHEN @SortBy = 'ParameterName' THEN Cast(GL.ParameterName as sql_variant) 
                            WHEN @SortBy = 'P0Added' THEN GL.P0Added
							WHEN @SortBy = 'P0Approved' THEN GL.P0Approved
							WHEN @SortBy = 'P0Fixed' THEN GL.P0Fixed
							WHEN @SortBy = 'P0Left' THEN GL.P0Left
							WHEN @SortBy = 'P0UnAssigned' THEN GL.P0UnAssigned
							WHEN @SortBy = 'P1Added' THEN GL.P1Added
							WHEN @SortBy = 'P1Approved' THEN GL.P1Approved
							WHEN @SortBy = 'P1Fixed' THEN GL.P1Fixed
							WHEN @SortBy = 'P1Left' THEN GL.P1Left
							WHEN @SortBy = 'P1UnAssigned' THEN GL.P1UnAssigned
							WHEN @SortBy = 'P2Added' THEN GL.P2Added
							WHEN @SortBy = 'P2Approved' THEN GL.P2Approved
							WHEN @SortBy = 'P2Fixed' THEN GL.P2Fixed
							WHEN @SortBy = 'P2Left' THEN GL.P2Left
							WHEN @SortBy = 'P2UnAssigned' THEN GL.P2UnAssigned
							WHEN @SortBy = 'P3Added' THEN GL.P3Added
							WHEN @SortBy = 'P3Approved' THEN GL.P3Approved
							WHEN @SortBy = 'P3Fixed' THEN GL.P3Fixed
							WHEN @SortBy = 'P3Left' THEN GL.P3Left
							WHEN @SortBy = 'P3UnAssigned' THEN GL.P3UnAssigned
							WHEN @SortBy = 'NoPriority' THEN GL.NoPriority
                    END
                END ASC

				OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                FETCH NEXT @PageSize ROWS ONLY	

         END  
		END
		--ELSE 
  --      BEGIN
        
  --         RAISERROR (@HavePermission,11, 1)
        
  --      END
     END TRY  
	 BEGIN CATCH 
		
		THROW

	 END CATCH
END
GO