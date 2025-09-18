CREATE  PROCEDURE [dbo].[USP_GetSprintActivityWithUserStories]
( 
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @SprintId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @IsIncludeUserStoryView BIT = NULL,
    @IsIncludeLogTime BIT = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@PageNo INT = 1,
	@PageSize INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@UserId IS NOT NULL)
		BEGIN
		  DECLARE @UserStoryCount INT
		   SET @UserStoryCount = (SELECT COUNT(1) FROM [dbo].[User] WHERE Id = @UserId)
		   IF(@UserStoryCount = 0)
		   BEGIN
		     SET @UserId = NULL
		   END
		END

	   IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

       IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000
        IF (@HavePermission = '1')
        BEGIN

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            CREATE TABLE #GoalActivityList 
            (
                ProjectId UNIQUEIDENTIFIER,
                ProjectName NVARCHAR(MAX),
            	UserStoryOrSprintId UNIQUEIDENTIFIER,
            	UserStoryOrSprintName NVARCHAR(800),
            	OldValue NVARCHAR(MAX),
            	NewValue NVARCHAR(MAX),
            	FieldName NVARCHAR(250),
            	[Description] NVARCHAR(MAX),
            	[KeyValue] NVARCHAR(250),
            	UserName NVARCHAR(800),
				ProfileImage NVARCHAR(800),
				UserId UNIQUEIDENTIFIER,
				UniqueName NVARCHAR(800),
				CreatedDateTime DATETIMEOFFSET,
				IsSprint BIT
            )
            
            INSERT INTO #GoalActivityList(ProjectId,ProjectName,UserStoryOrSprintId,UserStoryOrSprintName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,UniqueName,CreatedDateTime,IsSprint)
			SELECT P.Id,
                   P.ProjectName,
                   S.Id,
                   S.SprintName,
            	   SH.OldValue,
            	   SH.NewValue,
            	   SH.FieldName,
            	   null,
            	   SH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   NULL,
				   SH.CreatedDateTime,
				   1
            	   FROM SprintHistory SH
				   JOIN Sprints S ON S.Id = SH.SprintId
                   JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                   AND (@SprintId IS NULL OR SH.SprintId = @SprintId)
            	   JOIN [User] U ON U.Id = SH.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   WHERE (@UserId IS NULL OR SH.CreatedByUserId = @UserId)
				   UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   ISNULL(USH.OldValue,'null'),
            	   USH.NewValue,
            	   USH.FieldName,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime,
				   0
            	   FROM UserStoryHistory USH
                   JOIN UserStory US ON US.Id = USH.UserStoryId 
            	   JOIN Sprints S ON S.Id = US.SprintId 
                   JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                   AND (@SprintId IS NULL OR S.Id = @SprintId)
            	   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   AND USH.[Description] != 'UserStoryViewed' AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
				   UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   null,
            	   null,
            	   null,
            	   C.[Comment],
            	   'Comment',
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   C.CreatedDateTime,
				   0
            	   FROM Comment C
                   JOIN UserStory US ON US.Id = C.ReceiverId 
            	   JOIN Sprints S ON S.Id = US.SprintId
                   JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                   AND (@SprintId IS NULL OR S.Id = @SprintId)
            	   JOIN [User] U ON U.Id = C.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   AND (@UserId IS NULL OR C.CreatedByUserId = @UserId)
            
            IF(@IsIncludeUserStoryView = 1)
            BEGIN
            
            INSERT INTO #GoalActivityList(ProjectId,Projectname,UserStoryOrSprintId,UserStoryOrSprintName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime)
            SELECT P.Id,
                   P.ProjectName,
                   US.Id UserStoryId,
                   US.UserStoryName,
            	   USH.OldValue,
            	   USH.NewValue,
            	   USH.FieldName,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime
            	   FROM UserStoryHistory USH
                   JOIN UserStory US ON US.Id = USH.UserStoryId 
            	   JOIN Sprints S ON S.Id = US.SprintId
                   JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                   AND (@SprintId IS NULL OR S.Id = @SprintId)
            	   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   AND USH.[Description] = 'UserStoryViewed' AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
            END
            
            IF(@IsIncludeLogTime = 1)
            BEGIN
            
            INSERT INTO #GoalActivityList(ProjectId,Projectname,UserStoryOrSprintId,UserStoryOrSprintName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime)		
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   null OldValue,
            	   UST.SpentTimeInMin/60 NewValue,
            	   null FieldName,
            	   UST.Comment,
            	   'UserStorySpentTime',
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   UST.CreatedDateTime
            	   FROM UserStorySpentTime UST
                   JOIN UserStory US ON US.Id = UST.UserStoryId 
            	   JOIN Sprints S ON S.Id = US.SprintId 
                   JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                   AND (@SprintId IS NULL OR S.Id = @SprintId)
            	   JOIN [User] U ON U.Id = UST.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   AND (@UserId IS NULL OR UST.CreatedByUserId = @UserId)
            END
            
            SELECT *,TotalCount = COUNT(1) OVER()
			FROM #GoalActivityList 
			ORDER BY CreatedDateTime DESC
			
			OFFSET ((@PageNo - 1) * @PageSize) ROWS
            FETCH NEXT @PageSize ROWS ONLY
            
            
            DROP TABLE #GoalActivityList 

	 END
	 ELSE
	    
		RAISERROR(@HavePermission,11,1)

     END TRY
     BEGIN CATCH
        
          THROW

    END CATCH
END