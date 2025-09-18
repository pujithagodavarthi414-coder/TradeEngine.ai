-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get the UserNotificationReads Based on Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetUserNotificationReads] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetUserNotificationReads]
(
	@UserNotificationReadId UNIQUEIDENTIFIER = NULL,
	@NotificationId UNIQUEIDENTIFIER = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@ReadDateTime DATETIME = NULL,
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

	       IF(@UserNotificationReadId = '00000000-0000-0000-0000-000000000000') SET  @UserNotificationReadId = NULL

	       IF(@NotificationId = '00000000-0000-0000-0000-000000000000') SET  @NotificationId = NULL

	       IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [NotificationType])

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT UNR.Id AS UserNotificationReadId,
				   UNR.NotificationId,
				   UNR.UserId,
				   U.FirstName + ' ' + ISNULL(U.SurName,'') UserFullName,
				   U.ProfileImage,
 				   UNR.ReadDateTime,
				   UNR.CreatedByUserId,
				   UNR.CreatedDateTime
			  FROM [dbo].[UserNotificationRead] UNR
				   INNER JOIN [dbo].[Notification] N ON N.Id = UNR.NotificationId AND (N.InActiveDateTime IS NULL) AND (UNR.InActiveDateTime IS NULL)
				   INNER JOIN [dbo].[User] U ON U.Id = UNR.UserId
			  WHERE U.CompanyId = @CompanyId
					AND (@UserNotificationReadId IS NULL OR UNR.Id = @UserNotificationReadId)
					AND (@NotificationId IS NULL OR UNR.NotificationId = @NotificationId)
					AND (@UserId IS NULL OR UNR.UserId = @UserId)
					AND (@ReadDateTime IS NULL OR UNR.ReadDateTime = @ReadDateTime)
					AND (@SearchText IS NULL OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
											 OR (CONVERT(NVARCHAR(100),UNR.ReadDateTime,121) LIKE @SearchText))
			  ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'ReadDateTime' THEN CAST(CONVERT(DATETIME,UNR.ReadDateTime,121) AS sql_variant)
							     WHEN @SortBy = 'UserFullName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,UNR.CreatedDateTime,121) AS sql_variant)
							END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'ReadDateTime' THEN CAST(CONVERT(DATETIME,UNR.ReadDateTime,121) AS sql_variant)
							     WHEN @SortBy = 'UserFullName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
							     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,UNR.CreatedDateTime,121) AS sql_variant)
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


