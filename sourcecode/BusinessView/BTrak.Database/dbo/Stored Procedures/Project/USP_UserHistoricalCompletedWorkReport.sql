-------------------------------------------------------------------------------
-- Author       Siva Kumar Garadappagari
-- Created      '2021-01-13 00:00:00.000'
-- Purpose      To Get the User Work Report
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------
--EXEC [USP_UserHistoricalCompletedWorkReport] @OperationsPerformedBy = 'f418e5ad-7430-4692-a7f5-646e6eeef842',@DateFrom = '2020-04-01',@DateTo = '2020-04-29',@IsTableView = 1
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UserHistoricalCompletedWorkReport]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @DateFrom DATETIME = NULL,
 @DateTo DATETIME = NULL,
 @CreateDateFrom DATETIME = NULL,
 @CreateDateTo DATETIME = NULL,
 @SearchText NVARCHAR(100) = NULL,
 @PageSize INT = 200,
 @PageNumber INT = 1,
 @SortBy NVARCHAR(40) = NULL,
 @SortDirection NVARCHAR(40) = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @BoardTypeId UNIQUEIDENTIFIER = NULL,
 @NoOfReplansMin INT = NULL,
 @NoOfReplansMax INT = NULL,
 @LineManagerId UNIQUEIDENTIFIER = NULL,
 @IsProject BIT = NULL,
 @IsTableView BIT = 1
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
		 
		    IF (@DateFrom IS NOT NULL) SET @DateFrom = CONVERT(DATE,@DateFrom)

		    IF (@DateTo IS NOT NULL) SET @DateTo = CONVERT(DATE,@DateTo)

		    IF (@CreateDateFrom IS NOT NULL) SET @CreateDateFrom = CONVERT(DATE,@CreateDateFrom)

		    IF (@CreateDateTo IS NOT NULL) SET @CreateDateTo = CONVERT(DATE,@CreateDateTo)

			--IF(@LineManagerId IS NULL) SET @LineManagerId = @UserId

			IF(@IsProject IS NULL)SET @IsProject = 0

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT *
		    INTO #EmployeeReportedMembers
		    FROM [dbo].[Ufn_GetEmployeeReportedMembers](ISNULL(@LineManagerId,@OperationsPerformedBy),@CompanyId)
		  
			IF (@SortBy IS NULL) SET @SortBy ='UpdatedDateTime'
			IF (@SortDirection IS NULL) SET @SortDirection ='DESC'
			IF(@IsTableView = 1 OR @IsTableView IS NULL)
			BEGIN

			SELECT P.Id AS ProjectId
		          ,P.ProjectName
				  ,G.Id AS GoalId
		          ,G.GoalName
				  ,G.GoalUniqueName
				  ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS Developer
				  ,U.ProfileImage
				  ,J.JoinedDate
				  --,TZJ.TimeZoneName JoinedDateTimeZoneName
				  --,TZJ.TimeZoneAbbreviation  JoinedDateTimeZoneAbbreviation
				  ,U.Id AS UserId
				  ,US.Id AS UserStoryId
				  ,US.UserStoryUniqueName
				  ,US.UserStoryName
				  ,IIF(Spr.Id IS NULL,US.DeadLineDate,Spr.SprintEndDate) AS DeadLineDate
				  ,IIF(Spr.Id IS NULL,TZD.TimeZoneName,TZD.TimeZoneName) AS DeadLineDateTimeZoneName
				  ,IIF(Spr.Id IS NULL,TZD.TimeZoneAbbreviation,TZD.TimeZoneAbbreviation) AS DeadLineDateTimeZoneAbbreviation
				  ,US.OwnerUserId
				  ,ISNULL(AUN.QaApprovedDate,NULL) AS QaApprovedDate 
				  ,TZQ.TimeZoneName QaApprovedDateTimeZoneName
				  ,TZQ.TimeZoneAbbreviation QaApprovedDateTimeZoneAbbreviation
				  ,AUN.ApprovedUserName AS ApprovedUserName
				  ,AUN.ProfileImage AS ApprovedProfileImage 
				  ,AUN.ApprovedUserId 
				  ,ISNULL(WST1.DeployedDate,NULL) AS LatestDeployedDate
				  ,TZD1.TimeZoneName DeployedDateTimeZoneName
				  ,TZD1.TimeZoneAbbreviation DeployedDateTimeZoneAbbreviation
				  ,ISNULL(WST2.LatestDevCompletedDate,NULL) AS LatestDevCompletedDate
				  ,TZDC.TimeZoneName DevCompletedDateTimeZoneName
				  ,TZDC.TimeZoneAbbreviation DevCompletedDateTimeZoneAbbreviation
				  ,ISNULL(WST3.LatestDevInprogressDate,NULL) AS LatestDevInprogressDate
				  ,TZDI.TimeZoneName DevInprogressDateTimeZoneName
				  ,TZDI.TimeZoneAbbreviation DevInprogressDateTimeZoneAbbreviation
				  ,USS.[Status] AS CurrentStatus
				  ,IIF(US.SprintEstimatedTime IS NULL,IIF(FLOOR(ISNULL(US.EstimatedTime,0)) = 0,IIF(CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(US.EstimatedTime)) + 'h' )  +' '+ IIF(CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60) + 'm'),CONVERT(NVARCHAR(25),US.SprintEstimatedTime) + 'Story points') EstimatedTime
				  ,IIF(FLOOR(ISNULL(SP.SpentTime,0)) = 0,IIF(CAST((ISNULL(SP.SpentTime,0) *60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(SP.SpentTime)) + 'h' )  +' '+ IIF(CAST((ISNULL(SP.SpentTime,0) *60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(SP.SpentTime,0) *60)AS int)%60) + 'm') SpentTime
				  ,ISNULL(S.BouncedBackCount,0) AS BouncedBackCount
				  ,USS.StatusHexValue
				  ,BT.BoardTypeName
				  ,ISNULL(UBC.BugsCount,0) BugsCount
				  ,ISNULL(URC.RepalnUserStoriesCount,0) RepalnUserStoriesCount
				  ,ISNULL(G.IsProductiveBoard,0) IsProductive
				  ,US.InActiveDateTime
				  --,TZI.TimeZoneName InActiveDateTimeZoneName
				  --,TZI.TimeZoneAbbreviation InActiveDateTimeZoneAbbreviation
				  ,US.ParkedDateTime
				  --,TZP.TimeZoneName ParkedDateTimeZoneName
				  --,TZP.TimeZoneAbbreviation ParkedDateTimeZoneAbbreviation
				  ,G.ParkedDateTime AS GoalParkedDateTime
				  ,G.InactiveDateTime AS GoalInactiveDateTime
				  ,P.InActiveDateTime AS ProjectInactiveDateTime
				  ,Spr.SprintName
				  ,Spr.Id AS SprintId
				  ,Spr.InActiveDateTime AS SprintInactiveDatetime
				  ,US.UpdatedDateTime
				  ,TZU.TimeZoneName UpdatedDateTimeZoneName
				  ,TZU.TimeZoneAbbreviation UpdatedDateTimeZoneAbbreviation 
				  ,FORMAT(US.UpdatedDateTime,'dd-MMM-yyyy')+' '+ISNULL(TZU.TimeZoneAbbreviation,'') SheetUpdatedDateTime
				  ,FORMAT(ISNULL(US.DeadLineDate,Spr.SprintEndDate),'dd-MMM-yyyy')+' '+ISNULL(ISNULL(TZU.TimeZoneAbbreviation,TZS.TimeZoneAbbreviation),'') SheetDeadLineDate
				  ,FORMAT(AUN.QaApprovedDate,'dd-MMM-yyyy')+' '+ISNULL(TZQ.TimeZoneAbbreviation,'') SheetQaApprovedDate
				  ,FORMAT(WST1.DeployedDate,'dd-MMM-yyyy')+' '+ISNULL(TZD1.TimeZoneAbbreviation,'')SheetDeployedDate
				  ,FORMAT(WST2.LatestDevCompletedDate,'dd-MMM-yyyy')+' '+ISNULL(TZDC.TimeZoneAbbreviation,'')SheetLatestDevCompletedDate
				  ,FORMAT(WST3.LatestDevInprogressDate,'dd-MMM-yyyy')+' '+ISNULL(TZDI.TimeZoneAbbreviation,'')SheetLatestDevInprogressDate
				  ,TotalCount = COUNT(1) Over()
		  FROM Project P
		  --JOIN (SELECT UP.ProjectId FROM [UserProject] UP 
		  --             WHERE UP.UserId = @UserId 
				--	      AND UP.InActiveDateTime IS NULL GROUP BY UP.ProjectId) UP ON UP.ProjectId = P.Id
		     JOIN UserStory US ON US.ProjectId = P.Id AND P.InactiveDateTime IS NULL AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
		       AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		       AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
		       AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
		       AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
			   AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
		       AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo))
		  JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'
		  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
		  JOIN [User] U ON U.Id = US.OwnerUserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId 
		  JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
		  LEFT JOIN #EmployeeReportedMembers ER ON ER.ChildId = US.OwnerUserId
		  LEFT JOIN Job J ON J.EmployeeId = E.Id AND J.ActiveTo IS NULL
		 -- LEFT JOIN TimeZone TZJ ON TZJ.Id = J.JoinedDateTimeZone 
		  LEFT JOIN TimeZone TZD ON TZD.Id = US.DeadLineDateTimeZone 
		  LEFT JOIN TimeZone TZU ON TZU.Id = US.UpdatedDateTimeZoneId AND US.UpdatedDateTime IS NOT NULL
		  --LEFT JOIN TimeZone TZI ON TZI.Id = US.InActiveDateTimeZoneId 
    --      LEFT JOIN TimeZone TZP ON TZI.Id = US.ParkedDateTimeZoneId 
		  LEFT JOIN Goal G ON G.ProjectId = P.Id AND P.CompanyId = @CompanyId AND G.Id = US.GoalId
		  LEFT JOIN Sprints Spr ON Spr.ProjectId = P.Id AND US.SprintId = Spr.Id
		  LEFT JOIN TimeZone TZS ON TZS.Id = Spr.SprintEndDateTimeZoneId 
		  LEFT JOIN BoardType BT ON (BT.Id = G.BoardTypeId OR BT.Id = Spr.BoardTypeId)
		  LEFT JOIN (SELECT US.ParentUserStoryId,COUNT(1) BugsCount
		             FROM UserStory US
					 JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
					 WHERE UST.IsBug = 1 AND UST.CompanyId = @CompanyId AND US.ParentUserStoryId IS NOT NULL AND US.InActiveDateTime IS NULL
					 GROUP BY ParentUserStoryId) UBC ON UBC.ParentUserStoryId = US.Id 

		  LEFT JOIN (SELECT USR.UserStoryId,COUNT(1) RepalnUserStoriesCount
		             FROM UserStoryReplan USR
					 GROUP BY USR.UserStoryId) URC ON URC.UserStoryId = US.Id  

		  --LEFT JOIN(SELECT US.Id,MAX(USWST.CreatedDateTime) AS QaApprovedDate
		  --                  FROM Project P
		  --                    JOIN UserStory US ON US.ProjectId = P.Id
				--			      AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		  --                        AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
				--			       AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
				--				   AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
				--				   AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
				--				   AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo))--AND US.DeadLineDate IS NOT NULL
				--			  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id AND USWST.InActiveDateTime IS NULL
				--			  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
				--			  JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId AND USS.Id = US.UserStoryStatusId AND USS.TaskStatusId ='FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'
				--			--  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 6
				--			  GROUP BY US.Id) WST ON WST.Id = US.Id

							  						  
           LEFT JOIN(SELECT USWST.UserStoryId,USN.FirstName +' '+ ISNULL(USN.SurName,'') ApprovedUserName,USN.ProfileImage,USN.Id ApprovedUserId,USWSTInner.QaApprovedDate FROM UserStoryWorkflowStatusTransition USWST 
			  INNER JOIN (SELECT US.Id,MAX(USWST.CreatedDateTime) AS QaApprovedDate
		                    FROM Project P
		                      JOIN UserStory US ON US.ProjectId = P.Id 
							      AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		                          AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
							       AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
								   AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
								   AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
								   AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) --AND US.DeadLineDate IS NOT NULL
							  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id AND USWST.InActiveDateTime IS NULL
							  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId AND USS.Id = US.UserStoryStatusId AND USS.TaskStatusId ='FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'
							  --JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 6
							  JOIN [User] USN ON USN.Id = USWST.CreatedByUserId                                                                   
							  GROUP BY US.Id) USWSTInner ON USWST.CreatedDateTime = USWSTInner.QaApprovedDate AND USWSTInner.Id = USWST.UserStoryId
				JOIN [User] USN ON USN.Id = USWST.CreatedByUserId
                GROUP BY USWST.UserStoryId,USN.FirstName +' '+ ISNULL(USN.SurName,''),USN.ProfileImage,USN.Id,USWSTInner.QaApprovedDate ) AUN ON AUN.UserStoryId = US.Id
			LEFT JOIN UserStoryWorkflowStatusTransition USWTQ ON USWTQ.CreatedDateTime = AUN.QaApprovedDate AND USWTQ.UserStoryId = AUN.UserStoryId
          LEFT JOIN TimeZone TZQ ON TZQ.Id = USWTQ.TransitionTimeZone
		  LEFT JOIN(SELECT US.Id,MAX(USWST.CreatedDateTime) AS DeployedDate
		                    FROM Project P
		                      JOIN UserStory US ON US.ProjectId = P.Id 
							      AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		                          AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
							      AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
								  AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
								  AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
								  AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo))  --AND US.DeadLineDate IS NOT NULL
							  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id AND USWST.InActiveDateTime IS NULL
							  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId AND USS.TaskStatusId ='5C561B7F-80CB-4822-BE18-C65560C15F5B'
							--  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 3                                                                    
							  GROUP BY US.Id) WST1 ON WST1.Id = US.Id
		  LEFT JOIN UserStoryWorkflowStatusTransition USWTD ON USWTD.CreatedDateTime = WST1.DeployedDate AND USWTD.UserStoryId = WST1.Id
		  LEFT JOIN TimeZone TZD1 ON TZD1.Id = USWTD.TransitionTimeZone
		  LEFT JOIN(SELECT US.Id,MAX(USWST.CreatedDateTime) AS LatestDevCompletedDate
		                    FROM Project P
		                      JOIN UserStory US ON US.ProjectId = P.Id 
							        AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		                            AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
							        AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
								    AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
								    AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
								    AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo))  --AND US.DeadLineDate IS NOT NULL
							  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id AND USWST.InActiveDateTime IS NULL
							  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.FromWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId AND USS.TaskStatusId ='6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
							 -- JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 2 
							  JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId AND USS1.CompanyId = @CompanyId AND USS1.TaskStatusId ='6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
							 -- JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.[Order] = 2                                                                        
							  GROUP BY US.Id) WST2 ON WST2.Id = US.Id
        LEFT JOIN UserStoryWorkflowStatusTransition USWTC ON USWTC.CreatedDateTime = WST2.LatestDevCompletedDate AND USWTC.UserStoryId = WST2.Id
		LEFT JOIN TimeZone TZDC ON TZDC.Id = USWTC.TransitionTimeZone
		  LEFT JOIN(SELECT US.Id,MAX(USWST.CreatedDateTime) AS LatestDevInprogressDate
		                    FROM Project P
		                      JOIN UserStory US ON US.ProjectId = P.Id 
							       AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		                           AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
							       AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
								   AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
								   AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
								   AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo))  --AND US.DeadLineDate IS NOT NULL
							  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id AND USWST.InActiveDateTime IS NULL
							  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.FromWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId
							  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND (TS.[Order] = 1 OR  TS.[Order] = 6 OR  TS.[Order] = 3) 
							  JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId AND USS1.CompanyId = @CompanyId AND USS1.TaskStatusId ='6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
							 -- JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.[Order] = 2                                                                     
							  GROUP BY US.Id) WST3 ON WST3.Id = US.Id
           LEFT JOIN UserStoryWorkflowStatusTransition USTDI ON USTDI.CreatedDateTime = WST3.LatestDevInprogressDate AND USTDI.UserStoryId = WST3.Id
		   LEFT JOIN TimeZone TZDI ON TZDI.Id = USTDI.TransitionTimeZone
		  LEFT JOIN (SELECT US.Id,SUM(UST.SpentTimeInMin)/60.0 AS SpentTime 
		                    FROM UserStorySpentTime UST JOIN UserStory US ON UST.UserStoryId = US.Id 
							AND (@UserId IS NULL OR UST.UserId = @UserId)
		                    AND (@LineManagerId IS NULL OR (UST.UserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
						    AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
							AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
							AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
							AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) 
							GROUP BY US.Id) SP ON SP.Id = US.Id

		  LEFT JOIN (SELECT US.Id
		                               ,COUNT(1) AS BouncedBackCount
		                                FROM UserStory US
										  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id 
										              AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		                                              AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
										              AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
													  AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
													  AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
													  AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) 
										  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL
										  JOIN UserStoryStatus USS ON WEST.FromWorkflowUserStoryStatusId = USS.Id AND USS.CompanyId = @CompanyId
										  JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id AND USS1.CompanyId = @CompanyId 
										  AND ( USS.TaskStatusId = 'FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' OR  USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B') 
										  AND (  USS1.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
										  --JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND (TS.[Order] = 3 OR TS.[Order] = 6)
										  --JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.[Order] = 2
										  GROUP BY US.Id ) S ON S.Id = US.Id
          WHERE (@ProjectId IS NULL OR P.Id = @ProjectId)
		     AND (@BoardTypeId IS NULL OR BT.Id = @BoardTypeId)
			 AND ((@IsProject = 0 AND ER.ChildId IS NOT NULL) OR @IsProject = 1)
			 AND (@NoOfReplansMin IS NULL OR ISNULL(URC.RepalnUserStoriesCount,0) >= @NoOfReplansMin )
			 AND (@NoOfReplansMax IS NULL OR ISNULL(URC.RepalnUserStoriesCount,0) <= @NoOfReplansMax )
		     AND (@SearchText IS NULL 
		          OR (@SearchText LIKE G.GoalName) 
			      OR (@SearchText LIKE P.ProjectName)
			      OR (@SearchText LIKE US.UserStoryName)
				  OR (@SearchText LIKE Spr.SprintName))
		  ORDER BY 
		          CASE WHEN @SortDirection = 'ASC' OR @SortDirection IS NULL THEN
		             CASE WHEN @SortBy = 'GoalName' THEN CAST(G.GoalName AS SQL_VARIANT)
					      WHEN @SortBy = 'ProjectName' THEN CAST(P.ProjectName AS SQL_VARIANT)
					      WHEN @SortBy = 'SprintName' THEN CAST(Spr.SprintName AS SQL_VARIANT)
					      WHEN @SortBy = 'UserStoryName' THEN CAST(US.UserStoryName AS SQL_VARIANT)
						  WHEN @SortBy = 'BouncedBackCount' THEN ISNULL(S.BouncedBackCount,0)
						  WHEN @SortBy = 'LatestDeployedDate' THEN CAST(ISNULL(WST1.DeployedDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'CurrentStatus' THEN CAST(USS.[Status] AS SQL_VARIANT)
						  WHEN @SortBy = 'SpentTime' THEN ISNULL(SP.SpentTime,0)
						  WHEN @SortBy = 'EstimatedTime' THEN US.EstimatedTime
						  WHEN @SortBy = 'ApprovedDate' THEN CAST((IIF(TS.[Order] = 4,US.CreatedDateTime, NULL)) AS SQL_VARIANT)
						  WHEN @SortBy = 'BoardTypeName' THEN CAST(BT.BoardTypeName AS SQL_VARIANT)
						  WHEN @SortBy = 'LatestDevCompletedDate' THEN CAST(ISNULL(WST2.LatestDevCompletedDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'LatestDevInprogressDate' THEN CAST(ISNULL(WST3.LatestDevInprogressDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'QaApprovedDate' THEN CAST(ISNULL(AUN.QaApprovedDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'BugsCount' THEN ISNULL(UBC.BugsCount,0)
						  WHEN @SortBy = 'RepalnUserStoriesCount' THEN ISNULL(URC.RepalnUserStoriesCount,0)
						  WHEN @SortBy = 'IsProductive' THEN CAST(ISNULL(G.IsProductiveBoard,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'Developer' THEN CAST((U.FirstName + ' ' + ISNULL(U.SurName,'')) AS SQL_VARIANT)
						  WHEN @SortBy = 'DeadLineDate' THEN CAST((IIF(Spr.Id IS NULL,US.DeadLineDate,Spr.SprintEndDate)) AS SQL_VARIANT)
						  WHEN @SortBy = 'ApprovedUserName' THEN CAST(AUN.ApprovedUserName AS SQL_VARIANT)
						  WHEN @SortBy = 'UpdatedDateTime' THEN CAST(ISNULL(US.UpdatedDateTime,NULL) AS SQL_VARIANT)
		             END
				  END ASC,
				  CASE WHEN @SortDirection = 'DESC'THEN
		             CASE WHEN @SortBy = 'GoalName' THEN CAST(G.GoalName AS SQL_VARIANT)
					      WHEN @SortBy = 'ProjectName' THEN CAST(P.ProjectName AS SQL_VARIANT)
						  WHEN @SortBy = 'SprintName' THEN CAST(Spr.SprintName AS SQL_VARIANT)
					      WHEN @SortBy = 'UserStoryName' THEN CAST(US.UserStoryName AS SQL_VARIANT)
						  WHEN @SortBy = 'BouncedBackCount' THEN ISNULL(S.BouncedBackCount,0)
						  WHEN @SortBy = 'LatestDeployedDate' THEN CAST(ISNULL(WST1.DeployedDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'CurrentStatus' THEN CAST(USS.[Status] AS SQL_VARIANT)
						  WHEN @SortBy = 'SpentTime' THEN ISNULL(SP.SpentTime,0)
						  WHEN @SortBy = 'EstimatedTime' THEN US.EstimatedTime
						  WHEN @SortBy = 'ApprovedDate' THEN CAST((IIF(TS.[Order] = 4,US.CreatedDateTime, NULL)) AS SQL_VARIANT)
						  WHEN @SortBy = 'BoardTypeName' THEN CAST(BT.BoardTypeName AS SQL_VARIANT)
						  WHEN @SortBy = 'LatestDevCompletedDate' THEN CAST(ISNULL(WST2.LatestDevCompletedDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'LatestDevInprogressDate' THEN CAST(ISNULL(WST3.LatestDevInprogressDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'QaApprovedDate' THEN CAST(ISNULL(AUN.QaApprovedDate,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'BugsCount' THEN ISNULL(UBC.BugsCount,0)
						  WHEN @SortBy = 'RepalnUserStoriesCount' THEN ISNULL(URC.RepalnUserStoriesCount,0)
						  WHEN @SortBy = 'IsProductive' THEN CAST(ISNULL(G.IsProductiveBoard,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'Developer' THEN CAST((U.FirstName + ' ' + ISNULL(U.SurName,'')) AS SQL_VARIANT)
						  WHEN @SortBy = 'DeadLineDate' THEN CAST((IIF(Spr.Id IS NULL,US.DeadLineDate,Spr.SprintEndDate)) AS SQL_VARIANT)
						  WHEN @SortBy = 'ApprovedUserName' THEN CAST(AUN.ApprovedUserName AS SQL_VARIANT)
						  WHEN @SortBy = 'UpdatedDateTime' THEN CAST(ISNULL(US.UpdatedDateTime,NULL) AS SQL_VARIANT)
		             END
				  END DESC

			    OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
		        
                FETCH NEXT @PageSize ROWS ONLY

			END
			ELSE
			BEGIN
			SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS Developer
				  ,J.JoinedDate
				  ,PMC.ProjectsCount
				  ,ISNULL(L.LoggedHours,0) AS LoggedHours
				  ,PRO.Productivity 
				  ,ISNULL(Com.Verified,0) AS VerifiedUserStories
				  ,ISNULL(Bounced.BouncedBackUserStories,0) AS BouncedBackUserStories
				  ,ReportTo=(STUFF((SELECT ','+CAST(UR.FirstName+' '+ISNULL(UR.SurName,'') AS VARCHAR)
				                    FROM Employee E 
									JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND E.UserId = @UserId
												           AND (ER.ActiveTo IS NULL)
									JOIN Employee RE ON RE.Id = ER.ReportToEmployeeId
									JOIN [User] UR ON UR.Id = RE.UserId AND UR.IsActive = 1
									 FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
				  ,ISNULL(AUC.AssignedUserStoriesCount,0) AssignedUserStoriesCount
		  FROM [User] U
		  JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
		  LEFT JOIN Job J ON J.EmployeeId = E.Id AND J.ActiveTo IS NULL
		  LEFT JOIN (SELECT UserId,SUM(Productivity) AS Productivity FROM [dbo].[Ufn_GetProductivityIndexForAnIndividual](@UserId,@DateFrom,@DateTo) GROUP BY UserId) PRO ON PRO.UserId = U.Id
		  JOIN (SELECT UserId,COUNT(1) ProjectsCount
		             FROM UserProject UP 
					 WHERE (InActiveDateTime < @DateTo OR InActiveDateTime IS NULL)
					 GROUP BY UserId) PMC ON PMC.UserId = U.Id 

		  LEFT JOIN (SELECT UserId,SUM(SpentTimeInMin)/60.0 AS LoggedHours 
		                    FROM UserStorySpentTime UST 
							  JOIN  UserStory US ON US.Id = UST.userStoryId 
							    AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
								AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
								AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
								AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
								AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) 
		                    GROUP BY UserId) L ON L.UserId = U.Id

		  LEFT JOIN (SELECT US.OwnerUserId,COUNT(1) AS Verified
		                   FROM UserStory US
						     JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
							            AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
										AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
										AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
										AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) 
							            AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
						     JOIN Goal G ON G.Id = US.GoalId
							 JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
						  GROUP BY US.OwnerUserId
						 ) Com ON Com.OwnerUserId = U.Id

						 
		  LEFT JOIN (SELECT US.OwnerUserId,COUNT(1) AS AssignedUserStoriesCount
		                   FROM UserStory US
						     JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
							            AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
										AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
										AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
										AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) 
							            AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
						  GROUP BY US.OwnerUserId
						 ) AUC ON AUC.OwnerUserId = U.Id
						 		 
		  LEFT JOIN (SELECT B.OwnerUserId,B.BouncedBackUserStories 
		                    FROM (SELECT US.OwnerUserId,US.Id,COUNT(1)OVER() AS BouncedBackUserStories 
		                          FROM UserStory US 
						          JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id
							            AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
										AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
										AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
										AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
										AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo)) 
							      JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId 
								  JOIN UserStoryStatus USS ON WEST.FromWorkflowUserStoryStatusId = USS.Id AND USS.CompanyId = @CompanyId
								  JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id AND USS1.CompanyId = @CompanyId
								  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 3
								  JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.[Order] = 2
						      GROUP BY US.OwnerUserId,US.Id)B 
						GROUP BY B.OwnerUserId,B.BouncedBackUserStories) Bounced ON Bounced.OwnerUserId = U.Id
          WHERE (@UserId IS NULL OR U.Id = @UserId) AND U.IsActive = 1
		    AND E.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](ISNULL(@LineManagerId,@UserId),@CompanyId))
			END
			
			END
				ELSE
					
					RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

    END CATCH
END
GO