-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-16 00:00:00.000'
-- Purpose      To Get the UserStoryTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryHistory]
(
  @UserStoryHistoryId UNIQUEIDENTIFIER = NULL,
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)= NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
	       IF(@UserStoryHistoryId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryHistoryId = NULL

	       IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryId = NULL
		   
	       IF(@OldValue = '') SET  @OldValue = NULL

	       IF(@NewValue = '') SET  @NewValue = NULL

	       IF(@FieldName = '') SET  @FieldName = NULL

	       IF(@SortBy IS NULL ) SET  @SortBy = 'CreatedDateTime'

	       IF(@SortDirection IS NULL ) SET  @SortDirection = 'DESC'

	       IF(@PageSize IS NULL ) SET  @PageSize = (SELECT COUNT(1) FROM [dbo].[UserStoryHistory])

	       IF(@PageNumber IS NULL ) SET  @PageNumber = 1

		   IF(@PageSize = 0)
		   BEGIN
				SELECT @PageSize = 10, @PageNumber = 1
		   END

		   SELECT T.*, TotalCount = COUNT(1) OVER() FROM
	       (SELECT UH.Id AS UserStoryHistoryId,
		          US.UserStoryName,
		          UH.OldValue,
				  UH.NewValue,
				  UH.FieldName,
				  UH.[Description],
				  UH.CreatedByUserId,
				  UH.CreatedDateTime,
				  U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
				  U.ProfileImage,
				  TZ.TimeZoneName,
				  TZ.TimeZoneAbbreviation
		   FROM  [dbo].[UserStoryHistory] UH WITH (NOLOCK)
				 INNER JOIN [dbo].[UserStory] US ON US.Id = UH.UserStoryId 
				 LEFT JOIN [dbo].[Goal] G ON G.Id = US.GoalId 
				 LEFT JOIN [dbo].[Project] P ON P.Id = G.ProjectId
				 INNER JOIN [dbo].[User] U ON U.Id = UH.CreatedByUserId AND U.InactiveDateTime IS NULL
				 LEFT JOIN [dbo].[TimeZone]TZ ON TZ.Id = UH.CreatedDateTimeZoneId
		   WHERE U.CompanyId = @CompanyId 
		         AND (@UserStoryHistoryId IS NULL OR UH.Id = @UserStoryHistoryId)
		         AND (@UserStoryId IS NULL OR UH.UserStoryId = @UserStoryId)
		         AND (@OldValue IS NULL OR UH.OldValue = @OldValue)
		         AND (@NewValue IS NULL OR UH.NewValue = @NewValue)
		         AND (@FieldName IS NULL OR UH.FieldName = @FieldName)
		         AND (@Description IS NULL OR UH.[Description] = @Description)
			UNION ALL
			SELECT USH.Id UserStoryHistoryId,
               US.UserStoryName,
               ISNULL(USH.OldValue,'null') OldValue,
               USH.NewValue, 
               USH.FieldName,
               USH.[Description],
			   USH.CreatedByUserId,
			   USH.CreatedDateTime,
               U.FirstName + ' ' + ISNULL(U.SurName,'') FullName,
			   U.ProfileImage,
			   TZ.TimeZoneName,
			   TZ.TimeZoneAbbreviation
        FROM CronExpressionHistory USH
               JOIN UserStory US ON US.Id = USH.CustomWidgetId AND US.SprintId IS NULL AND ((USH.[Description] ='CronExpressionPaused' AND NewValue IS NOT NULL AND NewValue <> '') OR (USH.[Description] <> 'CronExpressionPaused'))
               JOIN Project P ON US.ProjectId = P.Id 
               JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL AND USH.[Description] != 'CronExpressionChanged' 
			   LEFT JOIN [TimeZone]TZ ON TZ.Id = USH.CreatedDateTimeZoneId
          WHERE U.CompanyId = @CompanyId 
		         AND (@UserStoryHistoryId IS NULL OR USH.Id = @UserStoryHistoryId)
		         AND (@UserStoryId IS NULL OR US.Id = @UserStoryId)
		         AND (@OldValue IS NULL OR USH.OldValue = @OldValue)
		         AND (@NewValue IS NULL OR USH.NewValue = @NewValue)
		         AND (@FieldName IS NULL OR USH.FieldName = @FieldName)
		         AND (@Description IS NULL OR USH.[Description] = @Description))T
		   ORDER BY CASE WHEN @SortDirection  = 'ASC' THEN
						 CASE WHEN @SortBy = 'OldValue' THEN T.OldValue
						      WHEN @SortBy = 'NewValue' THEN T.NewValue
						      WHEN @SortBy = 'FieldName' THEN T.FieldName
						      WHEN @SortBy = 'Description' THEN T.[Description]
						      WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(DATETIME,T.CreatedDateTime)
						END 
						END ASC,
						CASE WHEN @SortDirection  = 'DESC' THEN
					    CASE WHEN @SortBy = 'OldValue' THEN T.OldValue
						     WHEN @SortBy = 'NewValue' THEN T.NewValue
						     WHEN @SortBy = 'FieldName' THEN T.FieldName
						     WHEN @SortBy = 'Description' THEN T.[Description]
						     WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(DATETIME,T.CreatedDateTime)
						END 
					END DESC 
		  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		  FETCH NEXT @PageSize ROWS ONLY

		END
		ELSE
           RAISERROR (@HavePermission,11, 1)
	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH

END
GO