CREATE PROCEDURE [dbo].[USP_SearchGoalReplans]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @PageNumber INT = NULL,
  @PageSize INT = NULL,
  @SearchText NVARCHAR(100) = NULL,
  @SortBy NVARCHAR(100) = 'GoalReplanCreatedDateTime',
  @SortDirection NVARCHAR(100) = 'DESC'
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
	        
			IF (@GoalId = '00000000-0000-0000-0000-000000000000') SET @GoalId = NULL

			IF(@PageNumber IS NULL) SET @PageNumber = 1

			IF(@PageSize IS NULL) SET @PageSize = CASE WHEN (SELECT COUNT(1) FROM GoalReplan GR INNER JOIN UserStoryReplan USR ON GR.Id = USR.GoalReplanId) < 1 THEN 10 ELSE (SELECT COUNT(1) FROM GoalReplan GR INNER JOIN UserStoryReplan USR ON GR.Id = USR.GoalReplanId) END

			SET @SearchText = '%' + @SearchText + '%'

		    SELECT GR.Id AS GoalReplanId,
			       GR.GoalId,
				   G.GoalName,
				   G.GoalShortName,
				   GR.GoalReplanTypeId,
				   GRT.GoalReplanTypeName,
				   GR.Reason,
				   GR.CreatedDateTime AS GoalReplanCreatedDateTime,
				   TZ.TimeZoneName,
                   TZ.TimeZoneAbbreviation,
				   GR.CreatedByUserId AS GoalReplanCreatedByUserId,
				   GR.UpdatedDateTime AS GoalReplanUpdatedDateTime,
				   GR.UpdatedByUserId AS GoalReplanUpdatedByUserId,
				   USR.Id UserStoryReplanId,
				   USR.UserStoryId,
				   US.UserStoryName,
				   USR.UserStoryReplanTypeId,
				   USRT.ReplanTypeName AS UserStoryReplanTypeName,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.OldDeadLine') AS UserStoryOldDeadLine,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.NewDeadLine') AS UserStoryNewDeadLine,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.OldEstimatedTime') AS OldEstimatedTime,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.NewEstimatedTime') AS NewEstimatedTime,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.ExistedOwner') AS UserStoryExistedOwner,
				   OU.FirstName AS ExistedOwnerFirstName,
				   OU.SurName AS ExistedOwnerSurName,
				   OU.FirstName+' '+ OU.SurName AS ExistedOwnerFullName,
				   OU.ProfileImage AS ExistedOwnerProfileImage,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.NewOwner') AS UserStoryNewOwner,
				   NU.FirstName AS NewOwnerFirstName,
				   NU.SurName AS NewOwnerSurName,
				   NU.FirstName+' '+ NU.SurName AS NewOwnerFullName,
				   NU.ProfileImage AS NewOwnerProfileImage,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.OldUserStory') AS OldUserStory,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.NewUserStory') AS NewUserStory,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.ExistedDependency') AS UserStoryExistedDependency,
				   OD.FirstName AS ExistedDependencyFirstName,
				   OD.SurName AS ExistedDependencySurName,
				   OD.FirstName+' '+ OD.SurName AS ExistedDependencyFullName,
				   OD.ProfileImage AS ExistedDependencyProfileImage,
				   JSON_VALUE(USR.UserStoryReplanJson,'$.NewDependency') AS UserStoryNewDependency,
				   ND.FirstName AS NewDependencyFirstName,
				   ND.SurName AS NewDependencySurName,
				   ND.FirstName+' '+ ND.SurName AS NewDependencyFullName,
				   ND.ProfileImage AS NewDependencyProfileImage,
				   DATEDIFF(DAY,GETDATE(),US.DeadLineDate) AS UserStoryDeadLineInDays,
				   US.DeadLineDate AS UserStoryDeadLineDate,
				   DATEDIFF(DAY,GETDATE(),(SELECT MAX(US1.DeadLineDate) FROM UserStory US1 WHERE US1.GoalId = GR.GoalId)) AS GoalDeadLineInDays,
				   GoalDeadLineDate = (SELECT MAX(US1.DeadLineDate) FROM UserStory US1 WHERE US1.GoalId = GR.GoalId) 
				   FROM GoalReplan GR INNER JOIN UserStoryReplan USR ON GR.Id = USR.GoalReplanId 
				   INNER JOIN GoalReplanType GRT ON GRT.Id = GR.GoalReplanTypeId
				   INNER JOIN UserStoryReplanType USRT ON USRT.Id = USR.UserStoryReplanTypeId
				   INNER JOIN Goal G ON G.Id = GR.GoalId 
				   INNER JOIN UserStory US ON US.Id = USR.UserStoryId
				   LEFT JOIN [User] OU ON OU.Id = JSON_VALUE(USR.UserStoryReplanJson,'$.ExistedOwner')
				   LEFT JOIN [User] NU ON NU.Id = JSON_VALUE(USR.UserStoryReplanJson,'$.NewOwner')
				   LEFT JOIN [User] OD ON OD.Id = JSON_VALUE(USR.UserStoryReplanJson,'$.ExistedDependency')
				   LEFT JOIN [User] ND ON ND.Id = JSON_VALUE(USR.UserStoryReplanJson,'$.NewDependency')
				   LEFT JOIN TimeZone TZ ON TZ.Id = GR.CreatedDateTimeZone
			  WHERE (@GoalId IS NULL OR @GoalId = GR.GoalId)
			        AND (@SearchText IS NULL OR (US.UserStoryName LIKE @SearchText)
						                     OR (US.UserStoryName LIKE @SearchText)
                                             OR (G.GoalName LIKE @SearchText)	
						                     OR (GRT.GoalReplanTypeName LIKE @SearchText)
						                     OR (GR.Reason LIKE @SearchText)
						                     OR (USRT.ReplanTypeName LIKE @SearchText)
						                     OR (CONVERT(NVARCHAR(250),GR.CreatedDateTime,121)  LIKE @SearchText)
						                     OR (CONVERT(NVARCHAR(250),US.DeadLineDate,121)  LIKE @SearchText)
						                     OR (OU.FirstName+' '+ OU.SurName  LIKE @SearchText)
						                     OR (OD.FirstName+' '+ OD.SurName  LIKE @SearchText)
						                     OR (ND.FirstName+' '+ ND.SurName  LIKE @SearchText)
						                     OR (NU.FirstName+' '+ NU.SurName  LIKE @SearchText))
						ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
					              CASE WHEN @SortBy = 'GoalName' THEN G.GoalName
								       WHEN @SortBy = 'GoalShortName' THEN G.GoalShortName
								       WHEN @SortBy = 'GoalReplanTypeName' THEN GRT.GoalReplanTypeName
								       WHEN @SortBy = 'Reason' THEN GR.Reason
								       WHEN @SortBy = 'GoalReplanCreatedDateTime' THEN Cast(GR.CreatedDateTime as sql_variant)
								       WHEN @SortBy = 'GoalReplanCreatedByUserId' THEN Cast(GR.CreatedByUserId as sql_variant)
								       WHEN @SortBy = 'UserStoryName' THEN US.UserStoryName
								       WHEN @SortBy = 'UserStoryReplanTypeName' THEN USRT.ReplanTypeName
					                   END 
								  END ASC,
								  CASE WHEN @SortDirection = 'DESC' THEN
					                   CASE WHEN @SortBy = 'GoalName' THEN G.GoalName
								            WHEN @SortBy = 'GoalShortName' THEN G.GoalShortName
								            WHEN @SortBy = 'GoalReplanTypeName' THEN GRT.GoalReplanTypeName
								            WHEN @SortBy = 'Reason' THEN GR.Reason
								            WHEN @SortBy = 'GoalReplanCreatedDateTime' THEN Cast(GR.CreatedDateTime as sql_variant)
								            WHEN @SortBy = 'GoalReplanCreatedByUserId' THEN Cast(GR.CreatedByUserId as sql_variant)
								            WHEN @SortBy = 'UserStoryName' THEN US.UserStoryName
								            WHEN @SortBy = 'UserStoryReplanTypeName' THEN USRT.ReplanTypeName
					                        END 
									   END DESC
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