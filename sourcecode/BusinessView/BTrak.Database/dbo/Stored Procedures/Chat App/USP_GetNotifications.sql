-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the Notifications Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetNotifications] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetNotifications]
(
	@NotificationId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@Summary NVARCHAR(500) = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
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

	       IF(@NotificationId = '00000000-0000-0000-0000-000000000000') SET  @NotificationId = NULL

	       IF(@NotificationTypeId = '00000000-0000-0000-0000-000000000000') SET  @NotificationTypeId = NULL

	       IF(@Summary = '') SET  @Summary = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Notification])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT N.Id AS NotificationId,
				   N.NotificationTypeId,
				   NT.NotificationTypeName,
				   NT.FeatureId,
				   F.FeatureName,
				   N.NotificationJson,
				   N.Summary AS NotificationSummary,
				   N.CreatedByUserId,
				   N.CreatedDateTime AS NotificationCreatedDateTime
			  FROM [dbo].[Notification] N WITH (NOLOCK)
				   INNER JOIN [dbo].[NotificationType] NT WITH (NOLOCK) ON NT.Id = N.NotificationTypeId AND (NT.InActiveDateTime IS NULL) AND (N.InActiveDateTime IS NULL)
				   INNER JOIN [dbo].[Feature] F WITH (NOLOCK) ON F.Id = NT.FeatureId
				   INNER JOIN [dbo].[UserNotificationRead] UNR ON UNR.NotificationId = N.Id  AND UNR.InActiveDateTime IS NULL AND UNR.ReadDateTime IS NULL
			  WHERE F.Id IN (SELECT FM.FeatureId
			                 FROM FeatureModule FM 
			                      INNER JOIN CompanyModule CM ON FM.ModuleId = CM.ModuleId AND CM.CompanyId = @CompanyId
								             AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
							)
					AND (@NotificationId IS NULL OR N.Id = @NotificationId)
					AND (@NotificationTypeId IS NULL OR N.NotificationTypeId = @NotificationTypeId)
					AND (UNR.UserId = @OperationsPerformedBy)
					AND (@Summary IS NULL OR N.Summary = @Summary)
					AND (@SearchText IS NULL OR (N.Summary LIKE @SearchText)
											 OR (NT.NotificationTypeName LIKE @SearchText)
											 OR (F.FeatureName LIKE @SearchText))
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'Summary' THEN N.Summary
							     WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,N.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'Summary' THEN N.Summary
							     WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,N.CreatedDateTime,121) AS sql_variant)
							END
					  END DESC
			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize Rows ONLY
	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END