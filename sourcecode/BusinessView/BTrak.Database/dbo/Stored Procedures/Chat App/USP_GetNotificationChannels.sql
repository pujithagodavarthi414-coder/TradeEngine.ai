-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the NotificationChannels Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetNotificationChannels] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetNotificationChannels]
(
	@NotificationChannelId UNIQUEIDENTIFIER = NULL,
	@NotificationId UNIQUEIDENTIFIER = NULL,
	@ChannelName NVARCHAR(250) = NULL,
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

	       IF(@NotificationChannelId = '00000000-0000-0000-0000-000000000000') SET  @NotificationChannelId = NULL

	       IF(@NotificationId = '00000000-0000-0000-0000-000000000000') SET  @NotificationId = NULL

	       IF(@ChannelName = '') SET  @ChannelName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [NotificationChannel])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT NC.Id AS NotificationChannelId,
				   NC.NotificationId,
				   NC.Channel,
				   N.NotificationTypeId,
				   NT.NotificationTypeName,
				   NT.FeatureId,
				   F.FeatureName,
				   NC.CreatedByUserId,
				   NC.CreatedDateTime
			  FROM [dbo].[NotificationChannel] NC
				   INNER JOIN [dbo].[Notification] N ON N.Id = NC.NotificationId AND (N.InActiveDateTime IS NULL) AND (NC.InActiveDateTime IS NULL)
				   INNER JOIN [dbo].[NotificationType] NT ON NT.Id = N.NotificationTypeId AND (NT.InActiveDateTime IS NULL)
				   INNER JOIN [dbo].[Feature] F ON F.Id = NT.FeatureId
			  WHERE F.Id IN (SELECT FM.FeatureId
			                 FROM FeatureModule FM 
			                      INNER JOIN CompanyModule CM ON FM.ModuleId = CM.ModuleId AND CM.CompanyId = @CompanyId
								             AND CM.InActiveDateTime IS NULL AND FM.InActiveDateTime IS NULL
							)
					AND (@NotificationChannelId IS NULL OR NC.Id = @NotificationChannelId)
					AND (@NotificationId IS NULL OR NC.NotificationId = @NotificationId)
					AND (@ChannelName IS NULL OR NC.Channel = @ChannelName)
					AND (@SearchText IS NULL OR (NC.Channel LIKE @SearchText)
											 OR (NT.NotificationTypeName LIKE @SearchText)
											 OR (F.FeatureName LIKE @SearchText))
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'Channel' THEN NC.Channel
							     WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,NC.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'Summary' THEN N.Summary
							     WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'FeatureName' THEN F.FeatureName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,NC.CreatedDateTime,121) AS sql_variant)
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