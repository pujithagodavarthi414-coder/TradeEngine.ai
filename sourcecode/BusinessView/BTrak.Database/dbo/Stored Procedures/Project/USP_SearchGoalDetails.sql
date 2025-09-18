-------------------------------------------------------------------------------
-- Author       Padmini
-- Created      '2019-07-01 00:00:00.000'
-- Purpose      To Search the Goal details with userstories
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_SearchGoalDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@PageSize = 100
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchGoalDetails]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @GoalUniqueName NVARCHAR(30) = NULL,
  @IsArchived BIT = NULL,
  @PageSize INT = 10,
  @PageNumber INT = 1,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)=NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM Goal WHERE Id = @GoalId)

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
         IF(@HavePermission = '1')
         BEGIN
		 
		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		  
		  IF(@SortDirection IS NULL )
	      BEGIN

	    	  SET @SortDirection = 'DESC'

	      END
	      
	      DECLARE @OrderByColumn NVARCHAR(250) 
		 
		  IF(@SortBy IS NULL)
		  BEGIN
		     SET @SortBy = 'CreatedDateTime'
		  END

	      ELSE
	      BEGIN
		  
	      	   SET @SortBy = @SortBy
		  
	      END
		  
		  IF(@GoalId = '00000000-0000-0000-0000-000000000000') SET @GoalId = NULL
		  
		  SELECT G.Id AS GoalId,
		         G.ProjectId,
		  	     G.BoardTypeId,
		  	     G.BoardTypeApiId,
		  	     G.GoalBudget,
		  	     G.GoalName,
		  	     G.GoalStatusId,
		  	     G.GoalShortName,
				 CASE WHEN G.GoalStatusColor IS NULL THEN '#b7b7b7' ELSE G.GoalStatusColor END AS GoalStatusColor,
		  	     G.IsLocked,
		  	     G.IsProductiveBoard,
		  	     G.IsToBeTracked,
		  	     G.OnboardProcessDate,
		  	     G.IsApproved,
				 G.IsCompleted,
		  	     G.ParkedDateTime,
		  	     G.[Version],
		  	     G.GoalResponsibleUserId,
		  	     GRU.FirstName + ' ' + GRU.SurName GoalResponsibleUserName,
				 GRU.ProfileImage AS GoalResponsibleProfileImage,
		  	     G.ConfigurationId,
		  	     CT.ConfigurationTypeName,
		  	     G.ConsiderEstimatedHoursId,
		  	     CH.ConsiderHourName,
		  	     G.CreatedByUserId,
		  	     G.CreatedDateTime,
		  	     G.UpdatedByUserId,
		  	     G.UpdatedDateTime,
		  	     GS.GoalStatusName,
		  	     GS.IsParked GoalStatusIsParked,
		  	     GS.IsArchived GoalStatusIsarchived,
		  	     BT.BoardTypeName,
		  	     CASE WHEN BT.[InActiveDateTime] IS NULL THEN 0 ELSE 1 END BoardTypeIsArchived,
		  	     CASE WHEN CT.[InActiveDateTime] IS NULL THEN 0 ELSE 1 END ConfigurationIsArchived,
		  	     P.ProjectName,
		  	     CASE WHEN P.InactiveDateTime IS NULL THEN 0 ELSE 1 END ProjectIsArchived,
		  	     P.ProjectStatusColor,
		  	     P.ProjectResponsiblePersonId,
		  	     U.UserName,
		  	     U.SurName,
		  	     U.Firstname,
		  	     U.IsActive UserIsActive,
		  	     U.IsAdmin,
		  	     U.ProfileImage,
		  	     U.CompanyId,
				 (SELECT MAX (DeadLineDate) FROM UserStory US WHERE US.GoalId = G.Id AND ParkedDateTime IS NULL AND ArchivedDateTime IS NULL  group by GoalId) AS GoalDeadLine ,
                 (SELECT SUM (US.EstimatedTime) FROM UserStory US WHERE US.GoalId = G.Id AND ParkedDateTime IS NULL AND ArchivedDateTime IS NULL  group by GoalId)  AS GoalEstimatedTime,     
		  	     WF.Id AS WorkFlowId,
		  	     WF.WorkFlow AS WorkFlowName,
				 BT.BoardTypeUIId,
				 (SELECT COUNT(1) FROM userstory US WHERE US.GoalId = G.Id AND ArchivedDateTime IS NULL AND ParkedDateTime IS NULL) ActiveUserStoryCount,
				 CASE WHEN G.ParkedDateTime IS NULL THEN NULL ELSE 1 END AS IsParked,
				 G.GoalUniqueName,

				 UserStoriesXML = (SELECT US.Id UserSToryId,US.UserStoryName,US.EstimatedTime,US.DeadLineDate,US.OwnerUserId,OU.FirstName + ' ' + OU.SurName OwnerName,
								OU.FirstName OwnerFirstName,OU.SUrName OwnerSurName ,OU.UserName OwnerEmail ,OU.[Password] OwnerPassword,
								OU.ProfileImage OwnerProfileImage,US.DependencyUserId,DU.FirstName + ' ' + DU.SurName DependencyName ,
								DU.FirstName DependencyFirstName ,DU.SUrName DependencySurName ,DU.[Password] OwnerPassword,
								DU.ProfileImage DependencyProfileImage,US.[Order],US.UserStoryStatusId,USS.[Status] UserStoryStatusName,
								USS.StatusHexValue UserStoryStatusColor,USS.IsArchived UserStoryStatusIsArchived,USS.ArchivedDateTime UserStoryStatusArchivedDateTime,
								US.ActualDeadLineDate,US.ArchivedDateTime UserStoryArchivedDateTime,US.BugPriorityId,BP.PriorityName BugPriority,BP.Color BugPriorityColor,
								BU.UserId BugCausedUserId,BUU.FirstName +' '+ ISNULL(BUU.SurName,' ') BugCausedUserName,BUU.FirstName BugCausedUserFirstName,
								BUU.SurName BugCausedUserSurName,BUU.ProfileImage  BugCausedUserProfileImage,
								US.UserStoryTypeId,US.ProjectFeatureId,UserStoriesCount = COUNT(1) OVER() 
								FROM UserStory US																		   
								      INNER JOIN [Goal] Gl ON Gl.Id = US.GoalId 
									  LEFT JOIN [User] OU ON OU.Id = US.OwnerUserId 
									  LEFT JOIN [User] DU ON DU.Id = US.DependencyUserId 
									  LEFT JOIN [dbo].[BugCausedUser] BU ON BU.Id = US.Id 
									  LEFT JOIN [dbo].[User] BUU ON BUU.Id = BU.UserId 
									  LEFT JOIN [dbo].[BugPriority] BP ON BP.Id = US.BugPriorityId 
									  LEFT JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
								 WHERE Gl.GoalResponsibleUserId =  G.GoalResponsibleUserId
								FOR XML PATH('UserStoryApiReturnModel'),ROOT('UserStories'), TYPE),
				 
				 TotalCount = COUNT(1) OVER()

		  FROM [dbo].[Goal] G
		  	   INNER JOIN [dbo].[Project] P ON P.Id = G.ProjectId 
		  	   INNER JOIN [dbo].[User] U ON U.Id = G.CreatedByUserId AND U.IsActive = 1 AND U.[InActiveDateTime] IS NULL
		  	   LEFT JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId
		  	   INNER JOIN [dbo].[BoardType] BT ON BT.Id = G.BoardTypeId
		  	   LEFT JOIN [User] GRU ON G.GoalResponsibleUserId = GRU.Id AND GRU.[InActiveDateTime] IS NULL
		  	   LEFT JOIN [dbo].[ConfigurationType] CT ON CT.Id = G.ConfigurationId 
		  	   LEFT JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId 
		  	   LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = BT.Id 
		  	   LEFT JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId 

		  WHERE  P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy)
				 AND (@GoalId IS NULL OR G.Id = @GoalId) 
		  	     AND (@IsArchived IS NULL OR (@IsArchived = 0 AND G.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND G.InActiveDateTime IS NOT NULL))
		  	     AND (P.CompanyId = @CompanyId) 
		  	     AND (@GoalUniqueName IS NULL OR G.GoalUniqueName = @GoalUniqueName) 
		  	     
		       ORDER BY 
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'GoalName') THEN GoalName
							  WHEN(@SortBy = 'GoalShortName') THEN GoalShortName
                              WHEN @SortBy = 'ProjectName' THEN ProjectName
							  WHEN @SortBy = 'GoalResponsibleUserName' THEN GRU.FirstName + ' ' + GRU.SurName
							  WHEN @SortBy = 'ConfigurationTypeName' THEN ConfigurationTypeName
                              WHEN @SortBy = 'WorkFlow' THEN WorkFlow
							  WHEN @SortBy = 'CreatedDateTime' THEN Cast(G.CreatedDateTime as sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
						  CASE WHEN(@SortBy = 'GoalName') THEN GoalName
							  WHEN(@SortBy = 'GoalShortName') THEN GoalShortName
                              WHEN @SortBy = 'ProjectName' THEN ProjectName
							  WHEN @SortBy = 'GoalResponsibleUserName' THEN GRU.FirstName + ' ' + GRU.SurName
							  WHEN @SortBy = 'ConfigurationTypeName' THEN ConfigurationTypeName
                              WHEN @SortBy = 'WorkFlow' THEN WorkFlow
							  WHEN @SortBy = 'CreatedDateTime' THEN Cast(G.CreatedDateTime as sql_variant)   
                          END
					  END DESC
		        OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		        
		        FETCH NEXT @PageSize ROWS ONLY
	
	END
    ELSE
    BEGIN
                      
         RAISERROR (@HavePermission,10, 1)
                   
    END     
	END TRY  
	BEGIN CATCH 
	
		  RAISERROR ('Unexpected error searching for goals.',11, 1)
		
	END CATCH
END
GO