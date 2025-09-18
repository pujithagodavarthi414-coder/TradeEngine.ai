-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the UserNotificationTypes Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetUserNotificationTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetUserNotificationTypes]
(
	@UserNotificationTypeId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@IsActive BIT = NULL,
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
           IF(@HavePermission = '1')
           BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	       IF(@UserNotificationTypeId = '00000000-0000-0000-0000-000000000000') SET  @UserNotificationTypeId = NULL

	       IF(@NotificationTypeId = '00000000-0000-0000-0000-000000000000') SET  @NotificationTypeId = NULL

	       IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [NotificationType])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT UNT.Id AS UserNotificationReadId,
				   UNT.NotificationTypeId,
				   NT.NotificationTypeName,
				   UNT.UserId,
				   U.FirstName + ' ' + ISNULL(U.SurName,'') UserFullName,
				   U.ProfileImage,
 				   UNT.IsActive,
 				   UNT.IsDefaultEnable,
				   UNT.CreatedByUserId,
				   UNT.CreatedDateTime
			  FROM [dbo].[UserNotificationType] UNT WITH (NOLOCK)
				   INNER JOIN [dbo].[NotificationType] NT WITH (NOLOCK) ON NT.Id = UNT.NotificationTypeId AND (NT.InActiveDateTime IS NULL) AND (UNT.InActiveDateTime IS NULL)
				   INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.Id = UNT.UserId
			  WHERE U.CompanyId = @CompanyId
					AND (@UserNotificationTypeId IS NULL OR UNT.Id = @UserNotificationTypeId)
					AND (@NotificationTypeId IS NULL OR UNT.NotificationTypeId = @NotificationTypeId)
					AND (@UserId IS NULL OR UNT.UserId = @UserId)
					AND (@IsActive IS NULL OR UNT.IsActive = @IsActive)
					AND (@IsDefaultEnable IS NULL OR UNT.IsDefaultEnable = @IsDefaultEnable)
					AND (@SearchText IS NULL OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
											 OR (NT.NotificationTypeName LIKE @SearchText))
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'UserFullName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,UNT.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'NotificationTypeName' THEN NT.NotificationTypeName
							     WHEN @SortBy = 'UserFullName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,UNT.CreatedDateTime,121) AS sql_variant)
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
