CREATE PROCEDURE [dbo].[USP_GetUserStoryLinks]
(
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@LinkUserStoryId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsSprintUserStories BIT = NULL
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

		 IF (@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL

		 IF (@LinkUserStoryId = '00000000-0000-0000-0000-000000000000') SET @LinkUserStoryId = NULL

		 IF (@IsSprintUserStories IS NULL) SET @IsSprintUserStories = 0

		     SELECT US.Id AS UserStoryId,
		                                US.UserStoryName,
										
                                        DU.FirstName + ''  + ISNULL(DU.SurName,'') AS DependencyName,
                                        OU.FirstName + '' + ISNULL(OU.SurName,'') AS OwnerName,
                                        ISNULL(US.EstimatedTime,0) EstimatedTime,
                                        US.DeadLineDate,
										US.ParkedDateTime AS UserStoryParkedDateTime,
										US.[IsForQa],
										US.VersionName,
										USS.[Status] AS UserStoryStatusName,
                                        USS.StatusHexValue AS UserStoryStatusColor,
										US.UserStoryStatusId,
										US.OwnerUserId,
										US.DependencyUserId,
										US.BugPriorityId,
										US.UserStoryUniqueName,
										BP.PriorityName AS BugPriority,
                                        BP.Color AS BugPriorityColor,
                                        BP.[Description] AS BugPriorityDescription,
										OU.ProfileImage AS OwnerProfileImage,
										BUU.UserId AS BugCausedUserId,
                                        BU.FirstName + ''  + ISNULL(BU.SurName,'') AS BugCausedUserName,
                                        BU.ProfileImage AS BugCausedUserProfileImage,
										DU.ProfileImage AS DependencyProfileImage,
										BP.Icon,
                                        US.[Order],
										UST.UserStoryTypeName,
										UST.Color AS UserStoryTypeColor,
										US.Tag,
					                    US.ProjectFeatureId,
										LU.Id AS LinkUserStoryId,
										LU.LinkUserStoryTypeId,
										LU.TimeStamp,
										LUT.LinkUserStoryTypeName,
										TotalCount = Count(1) OVER()
							FROM [dbo].[LinkUserStory]LU
							INNER JOIN [dbo].[UserStory]US ON LU.LinkUserStoryId = US.Id
						    INNER JOIN [UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId
							
                            LEFT JOIN [dbo].[User] OU WITH (NOLOCK) ON OU.Id = US.OwnerUserId 
							LEFT JOIN [dbo].[LinkUserStoryType]LUT ON LUT.Id = LU.LinkUserStoryTypeId
							LEFT JOIN [dbo].[BugPriority] BP WITH (NOLOCK) ON BP.Id = US.BugPriorityId 
                            LEFT JOIN [dbo].[BugCausedUser] BUU WITH (NOLOCK) ON BUU.UserStoryId = US.Id 
                            LEFT JOIN [dbo].[User] BU WITH (NOLOCK) ON BU.Id = BUU.UserId 
                            LEFT JOIN [dbo].[UserStoryType] UST WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId 
                            LEFT JOIN [dbo].[ProjectFeature] PF WITH (NOLOCK) ON PF.Id = US.ProjectFeatureId 
                            LEFT JOIN [dbo].[UserStoryPriority] USP WITH (NOLOCK) ON USP.Id = US.UserStoryPriorityId 
                            LEFT JOIN [dbo].[User] RU WITH (NOLOCK) ON RU.Id = US.ReviewerUserId 
                            LEFT JOIN [dbo].[User] DU WITH (NOLOCK) ON DU.Id = US.DependencyUserId 
							WHERE (@UserStoryId IS NULL OR LU.UserStoryId = @UserStoryId) 
							AND (@LinkUserStoryId IS NULL OR LU.Id = @LinkUserStoryId)
							AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							AND LU.InActiveDateTime IS NULL

	END
	END TRY
	BEGIN CATCH 
        
         THROW

    END CATCH

   END
   GO