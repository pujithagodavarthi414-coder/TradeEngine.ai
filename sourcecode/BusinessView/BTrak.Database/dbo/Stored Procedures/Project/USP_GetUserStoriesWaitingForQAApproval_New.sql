---------------------------------------------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoriesWaitingForQAApproval_New] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @PageNumber = 1,@PageSize = 8
---------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoriesWaitingForQAApproval_New]
(
   @IsUserstoryOutsideQa BIT = 0 ,
   @OwnerUserId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10,
   @SearchText VARCHAR(500) = NULL,
   @SortBy NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @IsReportingOnly BIT = NULL,
   @IsMyself BIT = NULL,
   @IsAll BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF(@HavePermission = '1')
        BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
			
				IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

				IF(@OwnerUserId = '00000000-0000-0000-0000-000000000000')SET @OwnerUserId = NULL
				
				IF(@SortDirection IS NULL)SET @SortDirection = 'DESC'
				
				DECLARE @OrderByColumn NVARCHAR(250) 

				IF(@SortBy IS NULL)SET @SortBy = 'DeployedDateTime'
				
				SET @SearchText = '%'+ @SearchText +'%'

				SELECT *, 
					CASE WHEN GETUTCDATE() >T.QADeadline THEN 'red' END [Status],
					CASE WHEN CONVERT(DATE,GETUTCDATE()) <=  CONVERT(DATE,T.QADeadline) THEN DATEDIFF(HOUR,GETUTCDATE(), T.QADeadline) ELSE 0 END Due,
					DATENAME(WEEkDAY, T.QADeadline) QADeadlineWeek,
					TotalCount = COUNT(1) OVER()
				FROM (SELECT P.Id AS ProjectId,
				             P.ProjectName,
				             (CASE WHEN G.GoalShortName IS NULL OR G.GoalShortName = '' THEN G.GoalName ELSE GoalShortName END) Goal,
				             S.SprintName AS Sprint,
							 US.UserStoryName UserStory,
							 US.Id UserStoryId,
				             U.Id UserId,
				             U.ProfileImage UserProfileImage,
				             U.FirstName + '' + ISNULL(U.Surname,'') DeveloperName,
				             UWInner.TransitionDateTime DeployedDateTime,
							 TZ.TimeZoneAbbreviation DeployedDateTimeZoneAbbreviation,
				              TZ.TimeZoneName DeployedDateTimeZoneName,
				             DATENAME(WEEkDAY,UWInner.TransitionDateTime) DeployedWeek,
				             [dbo].[Ufn_GetQAActionDate](UWInner.TransitionDateTime) QADeadline,
							 CASE WHEN US.SprintId IS NOT NULL THEN 1 ELSE 0 END AS IsFromSprint
				FROM UserStory US
				   	 INNER JOIN Project P WITH (NOLOCK) ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
					 INNER JOIN Userproject UP ON P.Id = UP.ProjectId AND UP.InActiveDateTime IS NULL AND UP.UserId =  @OperationsPerformedBy     
				     INNER JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId
					 INNER JOIN (SELECT UserStoryId, MAX(TransitionDateTime) TransitionDateTime FROM UserStoryWorkflowStatusTransition GROUP BY UserStoryId) UWInner ON UWInner.UserStoryId = UW.UserStoryId AND UWInner.TransitionDateTime = UW.TransitionDateTime
					 INNER JOIN UserStoryWorkflowStatusTransition UST ON UST.UserStoryId = UWInner.UserStoryId AND UST.TransitionDateTime = UWInner.TransitionDateTime
					 LEFT JOIN TimeZone TZ ON TZ.Id = UST.[TransitionTimeZone]
				     INNER JOIN [User] U WITH (NOLOCK) ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
					 INNER JOIN [Employee] E ON E.UserId = U.Id 
					 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
					            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					 	        AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
					 LEFT JOIN  Goal G WITH (NOLOCK) ON US.GoalId = G.Id AND  G.ParkedDateTime IS NULL AND  G.InActiveDateTime IS NULL
					 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 
					 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 AND S.SprintStartDate IS NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL))
				WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				      AND (US.ParkedDateTime IS NULL) AND US.ArchivedDateTime IS NULL AND US.InActiveDateTime IS NULL 
					  AND (US.OwnerUserId = @OwnerUserId OR @OwnerUserId IS NULL)
					  AND (US.UserStoryStatusId IN (SELECT Id FROM UserStoryStatus WHERE TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'--(IsDeployed = 1 OR IsResolved = 1) 
					  AND CompanyId = @CompanyId AND InActiveDateTime IS NULL))
				      AND (@ProjectId IS NULL OR P.Id = @ProjectId)
				      AND P.CompanyId = @CompanyId
					  AND ((@IsReportingOnly = 1 AND US.OwnerUSerId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) WHERE ChildId <>  @OperationsPerformedBy) OR (@IsMyself = 1 AND US.OwnerUSerId = @OperationsPerformedBy) OR @IsAll = 1 ))
				) T
				WHERE (@SearchText IS NULL 
				            OR ProjectName LIKE @SearchText
				            OR (Goal LIKE @SearchText OR  Sprint LIKE @SearchText)
				            OR UserStory LIKE @SearchText
				            OR DeveloperName LIKE @SearchText
							OR SUBSTRING(CONVERT(VARCHAR,DeployedDateTime, 106),1,2) + '-' + SUBSTRING(CONVERT(VARCHAR, DeployedDateTime, 106),4,3) + '-' + CONVERT(VARCHAR,DATEPART(YEAR,DeployedDateTime)) LIKE @SearchText
							OR CONVERT(VARCHAR,DATEPART(DAY,DeployedDateTime)) + '-' + SUBSTRING(CONVERT(VARCHAR, DeployedDateTime, 106),4,3) + '-' + CONVERT(VARCHAR,DATEPART(YEAR,DeployedDateTime)) LIKE @SearchText
							OR FORMAT(DeployedDateTime,'dd-MMM-yyyy') LIKE @SearchText)
				     GROUP BY T.ProjectId,T.ProjectName,T.Goal,T.Sprint,T.UserStory,T.DeveloperName,T.DeployedDateTime,T.DeployedWeek,T.QADeadline,T.UserId,
					 T.UserProfileImage,T.UserStoryId,T.IsFromSprint,T.DeployedDateTimeZoneAbbreviation,T.DeployedDateTimeZoneName 
                ORDER BY 
                     CASE WHEN @SortDirection = 'ASC' THEN
                          CASE WHEN @SortBy = 'DeployedDateTime' THEN Cast(MAX(T.DeployedDateTime) as sql_variant)
                               WHEN @SortBy = 'ProjectName' THEN T.ProjectName
                               WHEN @SortBy = 'Goal' THEN  T.Goal
							   WHEN @SortBy = 'Sprint' THEN  T.Sprint
                               WHEN @SortBy = 'UserStory' THEN T.UserStory
                               WHEN @SortBy = 'DeveloperName' THEN T.DeveloperName
                          END 
                     END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                            CASE WHEN @SortBy = 'DeployedDateTime' THEN Cast(MAX(T.DeployedDateTime) as sql_variant)
                               WHEN @SortBy = 'ProjectName' THEN T.ProjectName
                               WHEN @SortBy = 'Goal' THEN  T.Goal
							   WHEN @SortBy = 'Sprint' THEN  T.Sprint
                               WHEN @SortBy = 'UserStory' THEN T.UserStory
                               WHEN @SortBy = 'DeveloperName' THEN T.DeveloperName
                          END 
                     END DESC
                     OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
                     
                     FETCH NEXT @PageSize ROWS ONLY
       END
       ELSE
	   BEGIN

            RAISERROR(@HavePermission,11,1)

	   END
	END TRY  
	BEGIN CATCH 

		THROW

	END CATCH
END