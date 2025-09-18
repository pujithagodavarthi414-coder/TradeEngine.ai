CREATE PROCEDURE [dbo].[USP_GetAllUserStories]
 (
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(4000) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
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
		 DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

         IF(@SearchText = '') SET @SearchText = NULL

		  SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

          SELECT US.OwnerUserId
                 ,OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS OwnerName
                 ,OU.ProfileImage AS OwnerProfileImage
                 ,DU.ProfileImage AS DependencyProfileImage
                 ,DU.FirstName + ' ' + ISNULL(DU.SurName,'') AS DependencyName
                 ,US.[EstimatedTime]
                 ,US.[UserStoryName]
                 ,US.[DependencyUserId]
                 ,US.[Order]
                 ,US.[UserStoryStatusId]
                 ,US.Id AS UserStoryId
                 ,US.UserStoryTypeId
                 ,US.TimeStamp
				 ,US.UserStoryUniqueName
                 ,P.Id AS ProjectId
                 ,S.Id AS SprintId
				 ,P.ProjectName
                 ,S.SprintName
				 ,US.[Description]
				 ,UST.UserStoryTypeName
				 ,UST.Color AS UserStoryTypeColor
				 ,UST.IsLogTimeRequired
				 ,UST.IsQaRequired
				 ,USS.Status AS UserStoryStatusName
				 ,USS.StatusHexValue AS UserStoryStatusColor
				 ,US.InActiveDateTime AS UserStoryArchivedDateTime
				 ,US.ParkedDateTime AS UserStoryParkedDateTime
				 ,US.ParentUserStoryId
				 ,US.SprintEstimatedTime
				 ,USS.TaskStatusId
				 ,US.Tag
				 ,US.ParentUserStoryId
          FROM  UserStory US
                LEFT JOIN Sprints S ON S.Id = US.SprintId 
				LEFT JOIN Goal G ON G.Id = US.GoalId
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
                LEFT JOIN Project P ON P.Id = S.ProjectId AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
				INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
                LEFT JOIN [User] OU ON OU.Id = US.OwnerUserId AND OU.InActiveDateTime IS NULL
                LEFT JOIN [User] DU ON DU.Id = US.OwnerUserId AND DU.InActiveDateTime IS NULL
          WHERE   (@UserStoryId IS NULL OR @UserStoryId = US.Id) 
		      AND (@ProjectId IS NULL OR (S.ProjectId = @ProjectId OR G.ProjectId = @ProjectId))
              AND (@SearchText IS NULL OR US.UserStoryName LIKE @SearchText
                                       OR US.UserStoryUniqueName LIKE @SearchText)
			  AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL 
			  AND (@EnableBugBoards = 1 OR (@EnableBugBoards = 0 AND (UST.IsBug = 0 OR UST.IsBug = 1)))
			 
    END
     ELSE
        RAISERROR(@HavePermission,11,1)
     END TRY
     BEGIN CATCH
           THROW
    END CATCH
END