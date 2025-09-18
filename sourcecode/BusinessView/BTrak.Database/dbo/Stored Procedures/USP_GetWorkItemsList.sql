-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2019-09-12 00:00:00.000'
-- Purpose      To Get the User Work Report
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------
--EXEC [USP_GetWorkItemsList] @OperationsPerformedBy = 'f418e5ad-7430-4692-a7f5-646e6eeef842'
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetWorkItemsList]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @SearchText NVARCHAR(100) = NULL,
 @UserStorySearchText NVARCHAR(800) = NULL,
 @PageSize INT = 200,
 @PageNumber INT = 1,
 @SortBy NVARCHAR(40) = NULL,
 @SortDirection NVARCHAR(40) = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @BoardTypeId UNIQUEIDENTIFIER = NULL,
 @NoOfReplansMin INT = NULL,
 @NoOfReplansMax INT = NULL,
 @LineManagerId UNIQUEIDENTIFIER = NULL,
 @GoalSearchText NVARCHAR(800) = NULL,
 @VerifiedOn DATE = NULL,
 @VerifiedBy UNIQUEIDENTIFIER = NULL,
 @BranchId UNIQUEIDENTIFIER = NULL,
 @UserStoryPriorityId UNIQUEIDENTIFIER = NULL,
 @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
 @IsGoalDealyed BIT = 0,
 @IsUserStoryDealyed BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@LineManagerId IS NULL) SET @LinemanagerId = @OperationsPerformedBy

		IF(@UserStorySearchText = '') SET @UserStorySearchText = NULL

		SET @UserStorySearchText = '%' + RTRIM(LTRIM(@UserStorySearchText)) + '%'

		IF(@GoalSearchText = '') SET @GoalSearchText = NULL

		SET @GoalSearchText = '%' + RTRIM(LTRIM(@GoalSearchText)) + '%'

        IF (@HavePermission = '1')
        BEGIN
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT ChildId
		INTO #EmployeeReportedMembers
		FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)
		 
			

			SELECT US.Id AS UserStoryId
			      ,'('+ US.UserStoryUniqueName +')' + ' ' + US.UserStoryName UserStoryName
				  ,US.CreatedDateTime
				  ,U1.FirstName + ' ' + ISNULL(U1.SurName,'') AS CreatedBy	
				  ,U1.ProfileImage 	CreatedByProfileImage
				  ,US.CreatedByUserId
			      ,P.Id AS ProjectId
		          ,P.ProjectName
				  ,G.Id AS GoalId
		          ,'('+ G.GoalUniqueName +')' + ' ' + G.GoalName GoalName
				  ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS Developer
				  ,U.ProfileImage DeveloperProfileImage
				  ,US.DeadLineDate
				  ,IIF(US.SprintEstimatedTime IS NULL,IIF(FLOOR(ISNULL(US.EstimatedTime,0)) = 0,IIF(CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(US.EstimatedTime)) + 'h' )  +' '+ IIF(CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60) + 'm'),CONVERT(NVARCHAR(25),US.SprintEstimatedTime) + 'Story points') EstimatedTime
				  ,IIF(FLOOR(ISNULL(SP.SpentTime,0)) = 0,IIF(CAST((ISNULL(SP.SpentTime,0) *60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(SP.SpentTime)) + 'h' )  +' '+ IIF(CAST((ISNULL(SP.SpentTime,0) *60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(SP.SpentTime,0) *60)AS int)%60) + 'm') SpentTime
				  ,US.OwnerUserId
				  ,Dinner.QaApprovedDate  QaApprovedDate 
				  ,AU.FirstName + ' ' + ISNULL(AU.SurName,'')  AS ApprovedUserName
				  ,AU.ProfileImage AS ApprovedUserProfileImage 
				  ,AU.Id ApprovedUserId 
				  ,ISNULL(G.IsProductiveBoard,0) IsBoardProductive
				  ,ISNULL(G.IsToBeTracked,0) IsBoardTracked
				  ,ISNULL(Dinner.BouncedBackCount,0) AS BouncedBackCount
			      ,ISNULL((SELECT COUNT(1) BugsCount FROM UserStory US1 JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND  UST.IsBug = 1 AND US1.ParentUserStoryId = US.Id  
					 WHERE UST.CompanyId = @CompanyId AND US1.ParentUserStoryId IS NOT NULL),0) AS BugsCount
				  ,ISNULL((SELECT COUNT(1) FROM [Comment] WHERE  ReceiverId = US.Id ),0) CommentsCount
				  ,ISNULL((SELECT COUNT(1)  FROM UserStoryReplan USR WHERE US.Id = USR.UserStoryId),0) AS RepalnUserStoriesCount
				  ,ISNULL((SELECT COUNT(1) FROM UserStoryScenario WHERE UserStoryId = US.Id),0) AS NumberOfTestScenarios 
				  ,IIF(BUN.Id IS NOT NULL, Dinner.BlockedDate,NULL) AS BlockedDate
				  ,BUN.FirstName + ' ' + ISNULL(BUN.SurName,'')  AS BlockeddBy
				  ,BUN.ProfileImage BlockedUserProfileImage 
				  ,BUN.Id BlockedUserId 
				  ,(CASE WHEN CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate) AND (USS.TaskStatusId IN ('F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')) 
										                                              THEN 'Yes' ELSE 'No' END) AS WorkItemIsInRed
				  ,(CASE WHEN G.GoalStatusColor = '#ff141c' THEN 'Yes' ELSE 'No' END) AS GoalIsInRed
				  ,GRU.FirstName + ' ' + ISNULL(GRU.SurName,'') AS GoalResponsibleUser	
				  ,GRU.ProfileImage AS GoalResponsibleUserProfileImage
				  ,GRU.Id AS GoalResponsibleUserId
				  ,PRU.FirstName + ' ' + ISNULL(PRU.SurName,'') AS ProjectResponsiblePerson	
				  ,PRU.ProfileImage AS ProjectResponsiblePersonProfileImage
				  ,PRU.Id AS ProjectResponsiblePersonId
				  ,AEBN.BranchName AS AssigneeBranchName
				  ,U2.FirstName + ' ' + ISNULL(U2.SurName,'') AS LastUpdatedBy
				  ,U2.ProfileImage 	LastUpdatedUserProfileImage
				  ,U2.Id AS LastUpdatedUserId
				  ,US.UpdatedDateTime AS LastUpdatedDate
				  ,UST.UserStoryTypeName AS WorkItemType
				  ,BUP.PriorityName AS WorkItemPriority
				  ,US.InActiveDateTime
				  ,US.ParkedDateTime
				  ,G.ParkedDateTime AS GoalParkedDateTime
				  ,G.InactiveDateTime AS GoalInactiveDateTime
				  ,P.InActiveDateTime AS ProjectInactiveDateTime
				  ,Spr.SprintName
				  ,Spr.Id AS SprintId
				  ,Spr.InActiveDateTime AS SprintInactiveDatetime
				  ,TZ.TimeZoneName  ApprovedDateTimeZoneName
				  ,TZC.TimeZoneName CreatedDateTimeZoneName
				  ,TZD.TimeZoneName DeadlineDateTimeZoneName
				  ,TZB.TimeZoneName BlockedTimeZoneName
				  ,TZ.TimeZoneAbbreviation  ApprovedDateTimeZoneAbbreviation
				  ,TZC.TimeZoneAbbreviation CreatedDateTimeZoneAbbreviation
				  ,TZD.TimeZoneAbbreviation DeadlineDateTimeZoneAbbreviation
				  ,TZB.TimeZoneAbbreviation BlockedTimeZoneAbbreviation
				  ,TotalCount = COUNT(1) Over()
		  FROM Project P
		  JOIN (SELECT ProjectId FROM [UserProject] UP 
		               WHERE UP.UserId = @OperationsPerformedBy 
					      AND UP.InActiveDateTime IS NULL GROUP BY UP.ProjectId) UP ON UP.ProjectId = P.Id  AND P.CompanyId = @CompanyId
		  JOIN UserStory US ON US.ProjectId = P.Id AND P.InactiveDateTime IS NULL AND (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers))
		       AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		 -- JOIN (SELECT ChildId FROM [Ufn_GetEmployeeReportedMembers](@LineManagerId,@CompanyId)) T ON T.ChildId = US.OwnerUserId
		  JOIN [User] U ON U.Id = US.OwnerUserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
		  JOIN [User] U1 ON U1.Id = US.CreatedByUserId AND U1.IsActive = 1 AND U1.CompanyId = @CompanyId
		  JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
	      LEFT JOIN Goal G ON G.ProjectId = P.Id AND G.Id = US.GoalId
		  LEFT JOIN Sprints Spr ON Spr.ProjectId = P.Id AND US.SprintId = Spr.Id
		  LEFT JOIN BoardType BT ON (BT.Id = G.BoardTypeId OR BT.Id = Spr.BoardTypeId)
		  LEFT JOIN UserStoryPriority USP ON USP.Id = US.UserStoryPriorityId 
		  LEFT JOIN BugPriority BUP ON BUP.Id = US.BugPriorityId 
		  LEFT JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
		  LEFT JOIN [UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId 
		  LEFT JOIN [User] GRU ON GRU.Id = G.GoalResponsibleUserId AND GRU.IsActive = 1 AND GRU.CompanyId = @CompanyId
		  LEFT JOIN [User] PRU ON PRU.Id = P.ProjectResponsiblePersonId AND PRU.IsActive = 1 AND PRU.CompanyId = @CompanyId
		  LEFT JOIN [User] U2 ON U2.Id = US.UpdatedByUserId AND U2.IsActive = 1 AND U2.CompanyId = @CompanyId
		  LEFT JOIN [User] BUN ON BUN.Id = US.DependencyUserId AND USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC'
		  LEFT JOIN [EmployeeBranch] AEB ON AEB.EmployeeId = E.Id 
		  LEFT JOIN [Branch] AEBN ON AEBN.Id = AEB.BranchId 
		  LEFT JOIN TimeZone TZC ON TZC.Id = US.CReatedDateTimeZone
		  LEFT JOIN TimeZone TZD ON TZD.Id = US.DeadlineDateTimeZone
		
		 -- LEFT JOIN (SELECT US.Id, COUNT(1) AS CommentsCount
		 --   FROM  [dbo].[Comment] C
		 --         INNER JOIN [dbo].[UserStory] US WITH (NOLOCK) ON C.ReceiverId = US.Id 
			--WHERE C.CompanyId = @CompanyId
			--GROUP BY US.Id) USC ON USC.Id = US.Id 

			
 --Need to add in Select
		 -- LEFT JOIN (SELECT US.Id, COUNT(1) AS NumberOfTestScenarios
		 --   FROM  [dbo].[UserStoryScenario] USTS
		 --         INNER JOIN [dbo].[UserStory] US WITH (NOLOCK) ON USTS.UserStoryId = US.Id 
			--	  INNER JOIN [dbo].[UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId 
			--WHERE USS.CompanyId = @CompanyId
			--GROUP BY US.Id) USTS ON USTS.Id = US.Id 

		  --LEFT JOIN (SELECT US.ParentUserStoryId,COUNT(1) BugsCount
		  --           FROM UserStory US
				--	 JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND  UST.IsBug = 1   AND US.ProjectId IN (SELECT ProjectId FROM [UserProject] UP 
		  --             WHERE UP.UserId = @OperationsPerformedBy 
				--	      AND UP.InActiveDateTime IS NULL GROUP BY UP.ProjectId)
				--	 WHERE UST.CompanyId = @CompanyId AND US.ParentUserStoryId IS NOT NULL
				--	 GROUP BY ParentUserStoryId) UBC ON UBC.ParentUserStoryId = US.Id 

		  --LEFT JOIN (SELECT USR.UserStoryId,COUNT(1) RepalnUserStoriesCount
		  --           FROM UserStoryReplan USR
				--	 GROUP BY USR.UserStoryId) URC ON URC.UserStoryId = US.Id  

		  LEFT JOIN (SELECT US.Id,SUM(UST.SpentTimeInMin)/60.0 AS SpentTime 
		                    FROM UserStorySpentTime UST JOIN UserStory US ON UST.UserStoryId = US.Id 
							AND (@UserId IS NULL OR UST.UserId = @UserId)
							GROUP BY US.Id) SP ON SP.Id = US.Id
         LEFT JOIN (SELECT US.Id,COUNT(CASE WHEN  USS.TaskStatusId IN ('5C561B7F-80CB-4822-BE18-C65560C15F5B','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  
                                 AND USS1.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'THEN 1 END)  AS BouncedBackCount,
                                 MAX(CASE WHEN USS1.TaskStatusId ='166DC7C2-2935-4A97-B630-406D53EB14BC' THEN USWST.CreatedDateTime END) BlockedDate,
                                 MAX( CASE WHEN  USS1.TaskStatusId IN ('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' ,'884947DF-579A-447A-B28B-528A29A3621D') THEN USWST.CreatedDateTime END) QaApprovedDate
		                                FROM UserStory US
										  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id  AND (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers))
										  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL
										  JOIN UserStoryStatus USS ON WEST.FromWorkflowUserStoryStatusId = USS.Id 
										  JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id 
										  GROUP BY US.Id)Dinner ON Dinner.Id = US.Id
	        LEFT JOIN UserStoryWorkflowStatusTransition UWT ON UWT.CreatedDateTime = Dinner.QaApprovedDate AND UWT.UserStoryId = Dinner.Id
	        LEFT JOIN UserStoryWorkflowStatusTransition BTZ ON UWT.CreatedDateTime = Dinner.BlockedDate AND UWT.UserStoryId = Dinner.Id
			LEFT JOIN TimeZone TZB ON TZB.Id = BTZ.TransitionTimeZone 
			LEFT JOIN TimeZone TZ ON TZ.Id = UWT.TransitionTimeZone AND TZ.InActiveDateTime IS NULL
			LEFT JOIN [User]AU ON AU.Id = UWT.CreatedByUserId AND  USS.TaskStatusId IN('FF7CAC88-864C-426E-B52B-DFB5CA1AAC76' ,'884947DF-579A-447A-B28B-528A29A3621D')
          WHERE (@ProjectId IS NULL OR P.Id = @ProjectId)
		     AND (@BoardTypeId IS NULL OR BT.Id = @BoardTypeId)
		     AND (@UserStorySearchText IS NULL 
		          OR (('('+ US.UserStoryUniqueName +')' + ' ' + US.UserStoryName)) LIKE @UserStorySearchText)
			 AND (@GoalSearchText IS NULL 
		          OR ((('('+ G.GoalUniqueName +')' + ' ' + G.GoalName)) LIKE @GoalSearchText)
				  OR Spr.SprintName LIKE '%'+ @GoalSearchText  +'%')
			 AND (@VerifiedOn IS NULL OR CONVERT(DATE,Dinner.QaApprovedDate) = @VerifiedOn)
			 AND (@VerifiedBy IS NULL OR AU.Id = @VerifiedBy)
			 AND (@BranchId IS NULL OR AEBN.Id = @BranchId) 
			 AND (@UserStoryPriorityId IS NULL OR BUP.Id = @UserStoryPriorityId) 
			 AND (@UserStoryTypeId IS NULL OR UST.Id = @UserStoryTypeId)
			 AND (@IsUserStoryDealyed IS NULL OR @IsUserStoryDealyed = 0 OR (@IsUserStoryDealyed = 1 AND CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate) AND (USS.TaskStatusId IN ('F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0','166DC7C2-2935-4A97-B630-406D53EB14BC')))) 
			 AND (@IsGoalDealyed IS NULL OR @IsGoalDealyed = 0 OR (@IsGoalDealyed = 1 AND G.GoalStatusColor = '#ff141c')) 
		  ORDER BY 
		          CASE WHEN @SortDirection = 'ASC' OR @SortDirection IS NULL THEN
		             CASE WHEN @SortBy = 'UserStoryName' THEN  ('('+ US.UserStoryUniqueName +')' + ' ' + US.UserStoryName)
					      WHEN @SortBy = 'CreatedDateTime' OR @SortBy IS NULL THEN CAST(US.CreatedDateTime AS SQL_VARIANT)
					      WHEN @SortBy = 'CreatedBy' OR @SortBy IS NULL THEN U1.FirstName + ' ' + ISNULL(U1.SurName,'') 
						  WHEN @SortBy = 'ProjectName' THEN P.ProjectName 
						  WHEN @SortBy = 'GoalName' THEN  '('+ G.GoalUniqueName +')' + ' ' + G.GoalName
						  WHEN @SortBy = 'Developer' THEN U.FirstName + ' ' + ISNULL(U.SurName,'') 
						  WHEN @SortBy = 'DeadLineDate' OR @SortBy IS NULL THEN CAST(US.DeadLineDate AS SQL_VARIANT)
						  WHEN @SortBy = 'EstimatedTime' THEN CAST(US.EstimatedTime  AS SQL_VARIANT)
						  WHEN @SortBy = 'SpentTime' THEN  CAST(ISNULL(SP.SpentTime,0) AS SQL_VARIANT)
						  WHEN @SortBy = 'QaApprovedDate' OR @SortBy IS NULL THEN CAST(Dinner.QaApprovedDate AS SQL_VARIANT)
					      WHEN @SortBy = 'ApprovedUserName' OR @SortBy IS NULL THEN AU.FirstName + ' ' + ISNULL(AU.SurName,'')
						  WHEN @SortBy = 'IsBoardProductive' THEN CAST(ISNULL(G.IsProductiveBoard,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'IsBoardTracked' THEN CAST(ISNULL(G.IsToBeTracked,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'RepalnUserStoriesCount' THEN CAST(ISNULL((SELECT COUNT(1)  FROM UserStoryReplan USR WHERE US.Id = USR.UserStoryId),0) AS SQL_VARIANT)
						  WHEN @SortBy = 'BouncedBackCount' THEN CAST(ISNULL(Dinner.BouncedBackCount,0) AS SQL_VARIANT)
						  WHEN @SortBy = 'BugsCount' THEN CAST(ISNULL((SELECT COUNT(1) BugsCount FROM UserStory US1 JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND  UST.IsBug = 1 AND US1.ParentUserStoryId = US.Id  
					                              WHERE UST.CompanyId = @CompanyId AND US1.ParentUserStoryId IS NOT NULL),0) AS SQL_VARIANT)
						  WHEN @SortBy = 'NumberOfTestScenarios' THEN ISNULL((SELECT COUNT(1) FROM UserStoryScenario WHERE UserStoryId = US.Id),0)
						  WHEN @SortBy = 'BlockedDate' OR @SortBy IS NULL THEN CAST(Dinner.BlockedDate AS SQL_VARIANT)
					      WHEN @SortBy = 'BlockedBy' OR @SortBy IS NULL THEN  BUN.FirstName + ' ' + ISNULL(BUN.SurName,'') 
						  WHEN @SortBy = 'CommentsCount' THEN ISNULL((SELECT COUNT(1) FROM [Comment] WHERE  ReceiverId = US.Id ),0)
						  WHEN @SortBy = 'WorkItemIsInRed' THEN CAST((CASE WHEN CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate) AND USS.TaskStatusId IN ('F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
										                                              THEN 'Yes' ELSE 'No' END) AS SQL_VARIANT)
						  WHEN @SortBy = 'GoalIsInRed' THEN (CASE WHEN G.GoalStatusColor = '#ff141c' THEN 'Yes' ELSE 'No' END)
						  WHEN @SortBy = 'GoalResponsibleUser' OR @SortBy IS NULL THEN  GRU.FirstName + ' ' + ISNULL(GRU.SurName,'')
						  WHEN @SortBy = 'ProjectResponsiblePerson' OR @SortBy IS NULL THEN PRU.FirstName + ' ' + ISNULL(PRU.SurName,'') 
						  WHEN @SortBy = 'AssigneeBranchName' THEN  AEBN.BranchName 
						  WHEN @SortBy = 'LastUpdatedBy' THEN  U2.FirstName + ' ' + ISNULL(U2.SurName,'')
						  WHEN @SortBy = 'WorkItemType' THEN  UST.UserStoryTypeName 
						  WHEN @SortBy = 'WorkItemPriority' THEN BUP.PriorityName
						  WHEN @SortBy = 'SprintName' THEN Spr.SprintName
		             END
				  END ASC,
				  CASE WHEN @SortDirection = 'DESC'THEN
		             CASE WHEN @SortBy = 'UserStoryName' THEN CAST(('('+ US.UserStoryUniqueName +')' + ' ' + US.UserStoryName) AS SQL_VARIANT)
					      WHEN @SortBy = 'CreatedDateTime' OR @SortBy IS NULL THEN CAST(US.CreatedDateTime AS SQL_VARIANT)
					      WHEN @SortBy = 'CreatedBy' OR @SortBy IS NULL THEN CAST(U1.FirstName + ' ' + ISNULL(U1.SurName,'') AS SQL_VARIANT)
						  WHEN @SortBy = 'ProjectName' THEN CAST(P.ProjectName AS SQL_VARIANT)
						  WHEN @SortBy = 'GoalName' THEN CAST(('('+ G.GoalUniqueName +')' + ' ' + G.GoalName) AS SQL_VARIANT)
						  WHEN @SortBy = 'Developer' THEN CAST(U.FirstName + ' ' + ISNULL(U.SurName,'') AS SQL_VARIANT)
						  WHEN @SortBy = 'DeadLineDate' OR @SortBy IS NULL THEN CAST(US.DeadLineDate AS SQL_VARIANT)
						  WHEN @SortBy = 'EstimatedTime' THEN US.EstimatedTime
						  WHEN @SortBy = 'SpentTime' THEN ISNULL(SP.SpentTime,0)
						  WHEN @SortBy = 'QaApprovedDate' OR @SortBy IS NULL THEN CAST(Dinner.QaApprovedDate AS SQL_VARIANT)
					      WHEN @SortBy = 'ApprovedUserName' OR @SortBy IS NULL THEN AU.FirstName + ' ' + ISNULL(AU.SurName,'')
						  WHEN @SortBy = 'IsBoardProductive' THEN CAST(ISNULL(G.IsProductiveBoard,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'IsBoardTracked' THEN CAST(ISNULL(G.IsToBeTracked,NULL) AS SQL_VARIANT)
						  WHEN @SortBy = 'RepalnUserStoriesCount' THEN ISNULL((SELECT COUNT(1)  FROM UserStoryReplan USR WHERE US.Id = USR.UserStoryId),0)
						  WHEN @SortBy = 'BouncedBackCount' THEN ISNULL(Dinner.BouncedBackCount,0)
						  WHEN @SortBy = 'BugsCount' THEN CAST(ISNULL((SELECT COUNT(1) BugsCount FROM UserStory US1 JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND  UST.IsBug = 1 AND US1.ParentUserStoryId = US.Id  
					                              WHERE UST.CompanyId = @CompanyId AND US1.ParentUserStoryId IS NOT NULL),0) AS SQL_VARIANT)
						  WHEN @SortBy = 'NumberOfTestScenarios' THEN ISNULL((SELECT COUNT(1) FROM UserStoryScenario WHERE UserStoryId = US.Id),0)
						  WHEN @SortBy = 'BlockedDate' OR @SortBy IS NULL THEN CAST(Dinner.BlockedDate AS SQL_VARIANT)
					      WHEN @SortBy = 'BlockedBy' OR @SortBy IS NULL THEN BUN.FirstName + ' ' + ISNULL(BUN.SurName,'') 
						  WHEN @SortBy = 'CommentsCount' THEN ISNULL((SELECT COUNT(1) FROM [Comment] WHERE ReceiverId = US.Id ),0)
						  WHEN @SortBy = 'WorkItemIsInRed' THEN CAST((CASE WHEN CONVERT(DATE,GETDATE()) > CONVERT(DATE,US.DeadLineDate ) AND USS.TaskStatusId IN ('F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
										                                              THEN 'Yes' ELSE 'No' END) AS SQL_VARIANT)
						  WHEN @SortBy = 'GoalIsInRed' THEN CAST((CASE WHEN G.GoalStatusColor = '#ff141c' THEN 'Yes' ELSE 'No' END) AS SQL_VARIANT)
						  WHEN @SortBy = 'GoalResponsibleUser' OR @SortBy IS NULL THEN CAST(GRU.FirstName + ' ' + ISNULL(GRU.SurName,'') AS SQL_VARIANT)
						  WHEN @SortBy = 'ProjectResponsiblePerson' OR @SortBy IS NULL THEN CAST(PRU.FirstName + ' ' + ISNULL(PRU.SurName,'') AS SQL_VARIANT)
						  WHEN @SortBy = 'AssigneeBranchName' THEN CAST(AEBN.BranchName AS SQL_VARIANT)
						  WHEN @SortBy = 'LastUpdatedBy' THEN CAST(U2.FirstName + ' ' + ISNULL(U2.SurName,'') AS SQL_VARIANT)
						  WHEN @SortBy = 'WorkItemType' THEN CAST(UST.UserStoryTypeName AS SQL_VARIANT)
						  WHEN @SortBy = 'WorkItemPriority' THEN CAST(BUP.PriorityName AS SQL_VARIANT)
						  WHEN @SortBy = 'SprintName' THEN CAST(Spr.SprintName AS SQL_VARIANT)
		             END
				  END DESC

			    OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
		        
                FETCH NEXT @PageSize ROWS ONLY

			END
				ELSE
					
					RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

    END CATCH
END