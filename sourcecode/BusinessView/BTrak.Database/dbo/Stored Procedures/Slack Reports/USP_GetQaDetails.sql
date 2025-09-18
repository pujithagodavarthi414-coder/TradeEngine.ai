----------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-06-03 00:00:00.000'
-- Purpose      To Get Qa Status
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------
--EXEC [dbo].[USP_GetQaDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetQaDetails]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SelectDate DATETIME  = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	IF (@HavePermission = '1')
	BEGIN
     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     
	  DECLARE @Projects TABLE
        (
			RowNumber INT IDENTITY(1,1),
            ProjectName VARCHAR(250),
			ProjectId UNIQUEIDENTIFIER,
			UserStoriesCountMoreThan8Hours INT,
			UserStoriesWaitingForApproval INT,
			Frequency INT,
			LongRunningIssues INT
        )
		INSERT INTO @Projects (ProjectName,ProjectId)
		SELECT P.ProjectName, P.Id FROM Project P WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId
		DECLARE @Count INT  = (SELECT COUNT(1) FROM @Projects)
		DECLARE @PId UNIQUEIDENTIFIER 
		WHILE (@Count > 0)
		BEGIN
			SET @PId = (SELECT ProjectId FROM @Projects WHERE RowNumber = @Count)
			DECLARE @UserStoriesWaitingForApproval INT = (SELECT COUNT(1)
				FROM (SELECT P.Id AS ProjectId,
							 P.ProjectName,
							 (CASE WHEN G.GoalShortName IS NULL OR G.GoalShortName = '' THEN G.GoalName ELSE GoalShortName END) Goal,
							 US.UserStoryName UserStory,
							 U.FirstName + ' ' + ISNULL(U.Surname,'') DeveloperName,
							 MAX(TransitionDateTime) DeployedDateTime,
							 DATENAME(WEEkDAY,MAX(TransitionDateTime)) DeployedWeek,
							 [dbo].[Ufn_GetQAActionDate](MAX(TransitionDateTime)) QADeadline
							FROM Goal G
							     JOIN UserStory US WITH (NOLOCK) ON US.GoalId = G.Id AND (US.UserStoryStatusId IN (SELECT Id FROM UserStoryStatus WHERE (TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B') --(IsDeployed = 1 OR IsResolved = 1) 
								 AND CompanyId = @CompanyId))
							     JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId
							     JOIN [User] U WITH (NOLOCK) ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
							     JOIN Project P WITH (NOLOCK) ON P.Id = G.ProjectId AND P.Id = @PId AND P.InActiveDateTime IS NULL
								 JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
								 JOIN BoardType BT ON BT.Id = G.BoardTypeId
							WHERE --(BT.IsSuperAgile = 1 OR BT.IsKanbanBug = 1)
								   --AND 
							       GS.IsActive = 1 
								    AND G.ProjectId = @PId
							       AND U.IsActive = 1 
								   AND (US.ParkedDateTime IS NULL)
								   AND  G.ParkedDateTime IS NULL
							       --AND (G.IsArchived IS NULL OR G.IsArchived = 0) 
								   AND G.InActiveDateTime IS NULL
								   AND US.ArchivedDateTime IS NULL AND US.InActiveDateTime IS NULL
								   AND (US.IsForQa = 0 OR US.IsForQa IS NULL)
							       
							GROUP BY US.Id,G.GoalShortName,G.GoalName,US.UserStoryName,U.FirstName + ' ' + ISNULL(U.Surname,''),P.Id,P.ProjectName) T)
			UPDATE @Projects SET UserStoriesWaitingForApproval = @UserStoriesWaitingForApproval WHERE RowNumber = @Count
		   
			 DECLARE @UserStoriesCountMoreThan8Hours INT = (SELECT Count(1) FROM (
			SELECT * FROM (SELECT US.Id,
				             US.UserStoryName UserStory,
				             MAX(TransitionDateTime) DeployedDateTime,
				             [dbo].[Ufn_GetQAActionDate](MAX(TransitionDateTime)) QADeadline
				FROM Goal G
				     JOIN UserStory US WITH (NOLOCK) ON US.GoalId = G.Id AND (US.UserStoryStatusId IN (SELECT Id FROM UserStoryStatus WHERE (TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B') --(IsDeployed = 1 OR IsResolved = 1) 
					 AND CompanyId = @CompanyId))
				     JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId
				     JOIN [User] U WITH (NOLOCK) ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
				     JOIN Project P WITH (NOLOCK) ON P.Id = G.ProjectId AND P.Id = @PId AND P.InActiveDateTime IS NULL
					 JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					 JOIN BoardType BT ON BT.Id = G.BoardTypeId
				WHERE --(BT.IsSuperAgile = 1 OR BT.IsKanbanBug = 1)
					   --AND 
				       GS.IsActive = 1 
    				   AND G.ProjectId = @PId
				       AND U.IsActive = 1 
				       AND (G.InActiveDateTime IS NULL) 
					   --AND G.ArchivedDateTime IS NULL
					   AND US.ArchivedDateTime IS NULL
					   AND (US.IsForQa = 0 OR US.IsForQa IS NULL)
				       AND P.CompanyId = @CompanyId
							GROUP BY US.Id,P.Id,P.ProjectName,G.GoalShortName,G.GoalName,US.UserStoryName,U.FirstName + ' ' + ISNULL(U.Surname,'')
							) T
							WHERE GETUTCDATE() > T.QADeadline
				     GROUP BY T.Id,T.UserStory,T.DeployedDateTime,T.QADeadline)FTINNER)
					 UPDATE @Projects SET UserStoriesCountMoreThan8Hours = @UserStoriesCountMoreThan8Hours WHERE RowNumber = @Count
					 
	 SET @PId = (SELECT ProjectId FROM @Projects WHERE RowNumber = @Count)
		DECLARE @Frequency FLOAT = (SELECT ISNULL(SUM(DATEDIFF(HOUR,FTINNER3.LatestDeployedDate,FTINNER4.LatestActionDate)),0)/(CASE WHEN Count(1) = 0 THEN 1 ELSE Count(1)END) FROM
	((SELECT * FROM (SELECT US.Id UserStoryId,MAX(USW.TransitionDateTime) LatestDeployedDate,[dbo].[Ufn_GetQAActionDate](MAX(TransitionDateTime)) QADeadline
	     FROM UserStory US 
	     LEFT JOIN UserStoryWorkflowStatusTransition USW ON USW.UserStoryId = US.Id
	     JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USW.WorkflowEligibleStatusTransitionId AND WFEST.InActiveDateTime IS NULL
		 INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId
		            AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' -- From Inpregress trasition
	     JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
	     JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL 
	     JOIN Project P ON P.Id = G.ProjectId AND P.Id = @PId AND P.InActiveDateTime IS NULL
	     JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
	     JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
	                     JOIN BoardType BT ON BT.Id = G.BoardTypeId
	     WHERE 
		 --((WFEST.IsFromDevCompletedTransition = 1 AND WFEST.IsToDeployedTransition = 1) 
	     --          OR (WFEST.IsFromInprogressTransition = 1 AND WFEST.IsToResolvedTransition = 1)) AND 
				P.CompanyId = @CompanyId
	     --AND (BT.IsSuperAgile = 1 OR BT.IsKanbanBug = 1)
	                       AND GS.IsActive = 1 
						   AND G.ProjectId = @PId
	                       AND U.IsActive = 1 
	                       AND (G.InActiveDateTime IS NULL) 
	                       AND US.ArchivedDateTime IS NULL
						   AND US.InActiveDateTime IS NULL
						   AND (US.IsForQa = 0 OR US.IsForQa IS NULL)
	     GROUP BY US.Id) FTINNER
		 WHERE FTINNER.LatestDeployedDate > GETUTCDATE()-1) FTINNER3
		 JOIN 
		 (SELECT * FROM (
		 SELECT US.Id UserStoryId,MAX(USW.TransitionDateTime) LatestActionDate
	     FROM UserStory US 
	     LEFT JOIN UserStoryWorkflowStatusTransition USW ON USW.UserStoryId = US.Id
	     JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USW.WorkflowEligibleStatusTransitionId
		 INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId
		            AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
	     JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
	     JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
	     JOIN Project P ON P.Id = G.ProjectId AND P.Id = @PId AND P.InActiveDateTime IS NULL
	     JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
	     JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
	                     JOIN BoardType BT ON BT.Id = G.BoardTypeId
	     WHERE P.CompanyId = @CompanyId 
	           --AND (BT.IsSuperAgile = 1 OR BT.IsKanbanBug = 1)
	           AND GS.IsActive = 1 
			   AND G.ProjectId = @PId
	           AND U.IsActive = 1 
	           AND (G.InActiveDateTime IS NULL) 
	           AND US.InActiveDateTime IS NULL
	           AND US.ArchivedDateTime IS NULL
			   AND (US.IsForQa = 0 OR US.IsForQa IS NULL)
	     GROUP BY US.Id
		 )FTINNER1
		 WHERE FTINNER1.LatestActionDate > GETUTCDATE()-1) FTINNER4 ON FTINNER3.UserStoryId =  FTINNER4.UserStoryId))
		  UPDATE @Projects SET Frequency = @Frequency WHERE RowNumber = @Count
					 
	 DECLARE @LongRunningIssues INT = (SELECT COUNT(1) FROM
			(SELECT US.Id UserStoryId
	     FROM UserStory US 
	     LEFT JOIN UserStoryWorkflowStatusTransition USW ON USW.UserStoryId = US.Id
	     JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USW.WorkflowEligibleStatusTransitionId
	     JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
	     JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
	     JOIN Project P ON P.Id = G.ProjectId AND P.Id = @PId AND P.InActiveDateTime IS NULL
	     JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
	     JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
	                     JOIN BoardType BT ON BT.Id = G.BoardTypeId
	     WHERE P.CompanyId = @CompanyId --AND 
	           --(BT.IsKanbanBug = 1)
			   AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
			   --AND (USS.IsNew = 1 OR USS.IsInprogress = 1)
	           AND GS.IsActive = 1 
			   AND G.ProjectId = @PId
	           AND U.IsActive = 1 
	           AND (G.InActiveDateTime IS NULL) 
	           AND US.InActiveDateTime IS NULL
	           AND US.ArchivedDateTime IS NULL
			   AND DATEDIFF(DAY,US.CreatedDateTime,GETUTCDATE()) > 5
			   AND (US.IsForQa = 0 OR US.IsForQa IS NULL)
	     GROUP BY US.Id) FTINNER5)
		 UPDATE @Projects SET LongRunningIssues = @LongRunningIssues WHERE RowNumber = @Count
					  SET @Count = @Count -1
	 END
	  SELECT ProjectName AS [Project], Frequency AS [Frequency],UserStoriesWaitingForApproval AS [Userstories waiting for approval], UserStoriesCountMoreThan8Hours AS [Userstories crossing deadline],  LongRunningIssues AS [Long running issues] from @Projects
    END
	END TRY  
    BEGIN CATCH 
        THROW
    END CATCH
END