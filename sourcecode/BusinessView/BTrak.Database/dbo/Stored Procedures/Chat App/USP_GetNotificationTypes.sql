-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the NotificationTypes Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetNotificationTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetNotificationTypes]
(
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeName NVARCHAR(250) = NULL,
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

	       IF(@NotificationTypeId = '00000000-0000-0000-0000-000000000000') SET  @NotificationTypeId = NULL

	       IF(@FeatureId = '00000000-0000-0000-0000-000000000000') SET  @FeatureId = NULL

	       IF(@NotificationTypeName = '') SET  @NotificationTypeName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [NotificationType])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT NT.Id AS NotificationTypeId,
				   NT.FeatureId,
				   NT.NotificationTypeName,
				   F.FeatureName,
				   NT.CreatedByUserId,
				   NT.CreatedDateTime
			  FROM [dbo].[NotificationType] NT WITH (NOLOCK)
				   INNER JOIN [dbo].[Feature] F WITH (NOLOCK) ON F.Id = NT.FeatureId AND (NT.InActiveDateTime IS NULL)
			  WHERE F.Id IN (SELECT FM.FeatureId
			                 FROM FeatureModule FM 
			                      INNER JOIN CompanyModule CM ON FM.ModuleId = CM.ModuleId AND CM.CompanyId = @CompanyId
								             AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
							)
					AND (@NotificationTypeId IS NULL OR NT.Id = @NotificationTypeId)
					AND (@FeatureId IS NULL OR NT.FeatureId = @FeatureId)
					AND (@NotificationTypeName IS NULL OR NT.NotificationTypeName = @NotificationTypeName)
					AND (@SearchText IS NULL OR (NT.NotificationTypeName LIKE @SearchText)
											 OR (F.FeatureName LIKE @SearchText))
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,NT.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,NT.CreatedDateTime,121) AS sql_variant)
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
