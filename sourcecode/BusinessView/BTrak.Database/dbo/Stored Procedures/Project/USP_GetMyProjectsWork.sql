-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-06-08 00:00:00.000'
-- Purpose      To get the work for Mywork dashboard
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--  EXEC [dbo].[USP_GetMyProjectsWork] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetMyProjectsWork]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER =NULL,
  @TeamMemberId  XML =NULL,
  @UserStoryStatusId  UNIQUEIDENTIFIER =NULL,
  @PageSize INT = 10,
  @PageNumber INT = 1,
  @SearchText NVARCHAR(100) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)=NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
         
         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
          DECLARE @Temp TABLE
          (
          ChildId UNIQUEIDENTIFIER,
          ParentId UNIQUEIDENTIFIER
          )
          INSERT INTO @Temp(ChildId)
          SELECT ChildId  FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)
                         
           SELECT 
                 US.Id AS UserStoryId ,
                 US.UserStoryName,
                 US.EstimatedTime,
                 US.DeadLineDate,
                 US.OwnerUserId,
                 OU.FirstName +' '+ISNULL(OU.SurName,'') AS OwnerName,
                 OU.ProfileImage AS OwnerProfileImage,
                 US.DependencyUserId,
                 DU.FirstName +' ' + ISNULL(DU.SurName,'')  DependencyName, 
                 DU.ProfileImage AS DependencyProfileImage,
                 US.UserStoryStatusId,
                 USS.[Status] UserStoryStatusName,
                 USS.StatusHexValue UserStoryStatusColor,
                 IsStarted= CASE WHEN (SELECT Id FROM UserStoryStatus WHERE --IsDevInprogress = 1 
									   USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' AND InActiveDateTime IS NULL) = US.UserStoryStatusId THEN 1 ELSE 0 END,
                 US.[Order],
                 US.ParkedDateTime UserStoryParkedDateTime,
                 (CASE WHEN (SELECT Id FROM BoardType WHERE IsBugBoard = 1 AND InActiveDateTime IS NULL) = G.BoardTypeId THEN 1 
                       WHEN (SELECT Id FROM BoardType WHERE IsBugBoard = 1 AND InActiveDateTime IS NULL) = G.BoardTypeId AND USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' THEN 1--AND USS.IsNotStarted = 1 																																								
                       WHEN (SELECT Id FROM BoardType WHERE IsBugBoard = 1 AND InActiveDateTime IS NULL) = G.BoardTypeId AND USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' THEN 1 ELSE 0 --USS.IsNew = 1
                     END) CanUserStoryPark,
                 US.ArchivedDateTime,
                 (CASE WHEN (SELECT Id FROM BoardType WHERE IsBugBoard = 1 AND InActiveDateTime IS NULL) = G.BoardTypeId THEN 1 
                       WHEN (SELECT Id FROM BoardType WHERE IsBugBoard = 1 AND InActiveDateTime IS NULL) = G.BoardTypeId AND USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' THEN 1--AND USS.IsNotStarted = 1
                       WHEN (SELECT Id FROM BoardType WHERE IsBugBoard = 1 AND InActiveDateTime IS NULL) = G.BoardTypeId AND USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' THEN 1 ELSE 0 --USS.IsNew = 1
                     END)CanArchive,
                 US.CreatedDateTime,
                 US.CreatedByUserId,
                 US.UserStoryTypeId,
                 UST.UserStoryTypeName, 
                 BU.UserId BugCausedUserId,
                 BCU.FirstName +' '+ISNULL(BCU.SurName,'') AS  BugCausedUserName,
                 BCU.ProfileImage BugCausedUserProfileImage,
                 BP.Id BugPriorityId,
                 BP.PriorityName BugPriority,
                 BP.[Description] BugPriorityDescription,
                 BP.Color BugPriorityColor,
                 G.Id AS GoalId,
                 G.ProjectId,
                 G.BoardTypeId,
                -- G.ArchivedDateTime,
                 G.GoalName,
                 G.GoalStatusId,
                 G.GoalShortName,
                 G.GoalStatusColor,
				 G.OnboardProcessDate,
                -- G.IsArchived,
                 G.IsLocked,
                 G.IsProductiveBoard,
                 G.IsToBeTracked,
                -- G.IsParked GoalIsParked,
                 G.IsApproved,
                 G.IsCompleted,
                 G.ParkedDateTime,
                 G.[Version],
                 G.GoalResponsibleUserId,
                 GRU.FirstName + ' ' + GRU.SurName GoalResponsibleUserName,
                 GRU.ProfileImage AS GoalResponsibleProfileImage,
                 G.ConfigurationId,
                 G.ConsiderEstimatedHoursId,    
                 G.CreatedByUserId,
                 G.CreatedDateTime,
                 GS.GoalStatusName,
                 GS.IsParked GoalStatusIsParked,
                 GS.IsArchived GoalStatusIsarchived,
                 BT.BoardTypeName,
                 BT.BoardTypeUIId,
                 P.ProjectName,
                 P.ProjectStatusColor,
                 P.ProjectResponsiblePersonId,
                 US.ProjectFeatureId,
                 PF.ProjectFeatureName,
				 US.TimeStamp,
                 US.WorkFlowId,
                 S.SprintName,
				 S.InActiveDateTime AS SprintInActiveDateTime,
				 US.SprintId,
				 CASE WHEN US.GoalId IS NULL AND US.SprintId IS NULL THEN 1
				      WHEN US.GoalId IS NOT NULL AND US.SprintId IS NULL THEN 0
					  ELSE NULL
				 END AS IsSprintUserStory,
                 TotalCount = (SELECT COUNT(1) FROM [dbo].[Project] P  WITH (NOLOCK)
                                WHERE UserId =  US.OwnerUserId AND P.Id IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL) AND P.InActiveDateTime IS NULL)
             FROM [UserStory]US 
               INNER JOIN [dbo].[Project] P  WITH (NOLOCK) ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
			   LEFT JOIN [dbo].[Goal] G  WITH (NOLOCK) ON US.GoalId = G.Id AND US.InActiveDateTime IS NULL  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
               LEFT JOIN [dbo].[Sprints]S WITH (NOLOCK) ON US.SprintId = S.Id AND S.InActiveDateTime IS NULL
			   LEFT JOIN [ProjectFeature]PF  WITH (NOLOCK) ON   PF.ProjectId =  US.ProjectFeatureId AND PF.InActiveDateTime IS NULL
               INNER JOIN UserStoryStatus USS  WITH (NOLOCK) ON US.UserStoryStatusId = USS.Id AND USS.InActiveDateTime IS NULL
               LEFT JOIN [UserStoryType] UST  WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
               LEFT JOIN  [BugCausedUser] BU  WITH (NOLOCK) ON BU.UserStoryId = US.Id AND BU.InActiveDateTime IS NULL
               LEFT JOIN [BugPriority]BP  WITH (NOLOCK) ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
               LEFT JOIN [dbo].[User] OU  WITH (NOLOCK) ON OU.Id = US.OwnerUserId
               LEFT JOIN [dbo].[User] DU  WITH (NOLOCK) ON DU.Id = US.DependencyUserId
               LEFT JOIN [User] BCU  WITH (NOLOCK) ON BCU.Id = BU.UserId
               LEFT JOIN [dbo].[GoalStatus] GS  WITH (NOLOCK) ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL
               LEFT JOIN [User] GRU  WITH (NOLOCK) ON G.GoalResponsibleUserId = GRU.Id
			   LEFT JOIN [BoardType]BT WITH (NOLOCK) ON BT.Id = G.BoardTypeId
			   LEFT JOIN [BoardType]BTS WITH (NOLOCK) ON BTS.Id = S.BoardTypeId
             WHERE USS.CompanyId = @CompanyId
             AND (((BT.IsBugBoard =  1 OR BTS.IsBugBoard = 1) AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' OR USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC' OR ((SELECT COUNT(1) FROM @Temp)>1) AND USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'))
                 OR ((BT.IsBugBoard =  1 OR BTS.IsBugBoard = 1)AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'))
                 OR ((BT.IsBugBoard =  1 OR BTS.IsBugBoard = 1) AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'))
              )
			 --AND ((BT.IsSuperAgile =  1 AND (USS.IsAnalysisCompleted = 1 OR USS.IsNotStarted = 1 OR USS.IsDevInprogress = 1 OR USS.IsDevCompleted = 1 OR USS.IsBlocked = 1 OR ((SELECT COUNT(1) FROM @Temp)>1) AND USS.IsDeployed = 1))
    --             OR (BT.IsKanbanBug = 1AND (USS.IsNew = 1 OR USS.IsInprogress = 1))
    --             OR (BT.IsKanban = 1 AND (USS.IsNotStarted = 1 OR USS.IsInprogress = 1))
    --          )
             AND ((US.OwnerUserId IN (SELECT ChildId FROM @Temp WHERE (@TeamMemberId IS NULL OR ChildId IN (SELECT X.Y.value('(text())[1]', 'uniqueidentifier') FROM @TeamMemberId.nodes('/GenericListOfGuid/ListItems/guid') X(Y)))))
              OR (US.DependencyUserId IN (SELECT ChildId FROM @Temp WHERE (@TeamMemberId IS NULL OR ChildId IN (SELECT X.Y.value('(text())[1]', 'uniqueidentifier') FROM @TeamMemberId.nodes('/GenericListOfGuid/ListItems/guid') X(Y))))))
             AND (@UserStoryStatusId IS NULL OR USS.Id = @UserStoryStatusId)
             AND (GS.IsActive = 1 OR (S.IsReplan = 0 AND S.SprintStartDate IS NOT NULL))
             AND US.ArchivedDateTime IS NULL AND US.InActiveDateTime IS NULL
             AND US.ParkedDateTime IS NULL 
           
          ORDER BY US.DeadLineDate
		  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
        FETCH NEXT @PageSize ROWS ONLY
      
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