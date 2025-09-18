-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-23 00:00:00.000'
-- Purpose      To Get UserStory By UserStoryId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetUserStoryById]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId='D06D0B85-BA72-47D7-AE0E-01EC75E11373'

CREATE PROCEDURE [dbo].[USP_GetUserStoryById]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

       SET NOCOUNT ON

	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		    SELECT US.Id AS UserStoryId,
		           US.GoalId,
			       US.UserStoryName,
			       US.EstimatedTime,
			       US.DeadLineDate,
			       US.OwnerUserId,
				   OU.FirstName +' '+ISNULL(OU.SurName,'') AS OwnerName,
                   OU.FirstName AS OwnerFirstName,
                   OU.SurName AS OwnerSurName,
                   OU.UserName AS OwnerEmail,
                   OU.[Password] AS OwnerPassword,
                   OU.IsPasswordForceReset AS OwnerIsPasswordForceReset,
                   OU.IsActive AS OwnerIsActive,
                   OU.TimeZoneId AS OwnerTimeZoneId,
                   OU.MobileNo AS OwnerMobileNo,
                   OU.IsAdmin AS OwnerIsAdmin,
                   OU.IsActiveOnMobile AS OwnerIsActiveOnMobile,
                   OU.ProfileImage AS OwnerProfileImage,
                   OU.RegisteredDateTime AS OwnerRegisteredDateTime,
                   OU.LastConnection AS OwnerLastConnection,
				   G.ProjectId,
				   P.ProjectName,
			       P.ProjectResponsiblePersonId,
			       CASE WHEN P.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS ProjectIsArchived,
			       P.InactiveDateTime AS ProjectArchivedDateTime,
			       P.ProjectStatusColor,
			       P.CreatedDateTime AS ProjectCreatedDateTime,
			       P.CreatedByUserId,
			       G.BoardTypeId,
			       G.BoardTypeApiId,
			       G.GoalBudget,
			       G.GoalName,
			       G.GoalStatusId,
			       G.GoalShortName,
			       G.GoalStatusColor,
			       G.IsLocked,
			       G.IsProductiveBoard,
			       G.IsToBeTracked,
			       G.OnboardProcessDate,
			       G.IsApproved,
			       G.ParkedDateTime,
			       G.[Version],
			       G.GoalResponsibleUserId,
			       G.ConfigurationId,
			       G.ConsiderEstimatedHoursId,
			       US.DependencyUserId,
				   DU.FirstName +' '+ISNULL(OU.SurName,'') AS DependencyName,
                   DU.FirstName AS DependencyFirstName,
                   DU.SurName AS DependencySurName,
                   DU.UserName AS DependencyEmail,
                   DU.[Password] AS DependencyPassword,
                   DU.IsPasswordForceReset AS DependencyIsPasswordForceReset,
                   DU.IsActive AS DependencyIsActive,
                   DU.TimeZoneId AS DependencyTimeZoneId,
                   DU.MobileNo AS DependencyMobileNo,
                   DU.IsAdmin AS DependencyIsAdmin,
                   DU.IsActiveOnMobile AS DependencyIsActiveOnMobile,
                   DU.ProfileImage AS DependencyProfileImage,
                   DU.RegisteredDateTime AS DependencyRegisteredDateTime,
			       US.[Order],
			       US.UserStoryStatusId,
				   USS.[Status] AS UserStoryStatusName,
			       USS.StatusHexValue AS UserStoryStatusColor,
			       USS.IsArchived AS UserStoryStatusIsArchived,
			       USS.ArchivedDateTime AS UserStoryStatusArchivedDateTime,
			       US.ActualDeadLineDate,
			       US.ArchivedDateTime AS UserStoryArchivedDateTime,
			       US.BugPriorityId,
				   BP.PriorityName AS BugPriority,
				   BP.Color AS BugPriorityColor,
				   BP.[Description] AS BugPriorityDescription,
				   BU.UserId AS BugCausedUserId,
				   BUU.FirstName +' '+ISNULL(OU.SurName,'') AS BugCausedUserName,
                   BUU.FirstName AS BugCausedUserFirstName,
                   BUU.SurName AS BugCausedUserSurName,
                   BUU.UserName AS BugCausedUserEmail,
                   BUU.[Password] AS BugCausedUserPassword,
                   BUU.IsPasswordForceReset AS BugCausedUserIsPasswordForceReset,
                   BUU.IsActive AS BugCausedUserIsActive,
                   BUU.TimeZoneId AS BugCausedUserTimeZoneId,
                   BUU.MobileNo AS BugCausedUserMobileNo,
                   BUU.IsAdmin AS BugCausedUserIsAdmin,
                   BUU.IsActiveOnMobile AS BugCausedUserIsActiveOnMobile,
                   BUU.ProfileImage AS BugCausedUserProfileImage,
                   BUU.RegisteredDateTime AS BugCausedUserRegisteredDateTime,
                   BUU.LastConnection AS BugCausedUserLastConnection,
			       US.UserStoryTypeId,
				   UST.UserStoryTypeName,
				   US.ProjectFeatureId,
				   PF.ProjectFeatureName,
			       US.ParkedDateTime,
			       US.CreatedByUserId,
			       US.CreatedDateTime,
				   US.UpdatedByUserId,
				   US.[ReviewerUserId],
				   US.UpdatedDateTime
			  FROM [dbo].[UserStory] US WITH (NOLOCK)
				   INNER JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = US.GoalId
			       INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = G.ProjectId
				   LEFT JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId
			       LEFT JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
				   LEFT JOIN [dbo].[User] OU WITH (NOLOCK) ON OU.Id = US.OwnerUserId
				   LEFT JOIN [dbo].[User] DU WITH (NOLOCK) ON DU.Id = US.DependencyUserId
				   LEFT JOIN [dbo].[BugPriority] BP ON BP.Id = US.BugPriorityId
				   LEFT JOIN [dbo].[BugCausedUser] BU ON BU.UserStoryId = US.Id
				   LEFT JOIN [dbo].[User] BUU WITH (NOLOCK) ON BUU.Id = BU.UserId
				   LEFT JOIN [dbo].[UserStoryType] UST WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId
				   LEFT JOIN [dbo].[ProjectFeature] PF WITH (NOLOCK) ON PF.Id = US.ProjectFeatureId
			  WHERE US.Id = @UserStoryId
		            AND P.CompanyId = @CompanyId

	   END TRY  
	   BEGIN CATCH 
		
		   THROW

	  END CATCH
END
GO

