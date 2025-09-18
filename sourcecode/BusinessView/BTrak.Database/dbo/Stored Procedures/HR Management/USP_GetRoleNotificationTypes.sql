-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the RoleNotificationTypes Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetRoleNotificationTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetRoleNotificationTypes]
(
	@RoleNotificationTypeId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@RoleId UNIQUEIDENTIFIER = NULL,
	@IsDefaultEnable BIT = NULL,
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

	       IF(@RoleNotificationTypeId = '00000000-0000-0000-0000-000000000000') SET  @RoleNotificationTypeId = NULL

	       IF(@NotificationTypeId = '00000000-0000-0000-0000-000000000000') SET  @NotificationTypeId = NULL

	       IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET  @RoleId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [NotificationType])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT RN.Id AS RoleNotificationTypeId,
				   RN.RoleId,
				   R.RoleName,
				   RN.NotificationTypeId,
				   NT.NotificationTypeName,
				   RN.IsDefaultEnable,
				   RN.CreatedByUserId,
				   RN.CreatedDateTime
			  FROM [dbo].[RoleNotificationType] RN WITH (NOLOCK)
				   INNER JOIN [dbo].[NotificationType] NT WITH (NOLOCK) ON NT.Id = RN.NotificationTypeId AND (NT.InActiveDateTime IS NULL) AND (RN.InActiveDateTime IS NULL)
				   INNER JOIN [dbo].[Role] R WITH (NOLOCK) ON R.Id = RN.RoleId
			  WHERE R.CompanyId = @CompanyId
					AND (@RoleNotificationTypeId IS NULL OR RN.Id = @RoleNotificationTypeId)
					AND (@NotificationTypeId IS NULL OR RN.NotificationTypeId = @NotificationTypeId)
					AND (@RoleId IS NULL OR RN.RoleId = @RoleId)
					AND (@IsDefaultEnable IS NULL OR RN.IsDefaultEnable = @IsDefaultEnable)
					AND (@SearchText IS NULL OR (NT.NotificationTypeName LIKE @SearchText)
											 OR (R.RoleName LIKE @SearchText))
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'RoleName' THEN R.RoleName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,RN.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'RoleName' THEN R.RoleName
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,RN.CreatedDateTime,121) AS sql_variant)
							END
					  END DESC
			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize Rows ONLY

	END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END

