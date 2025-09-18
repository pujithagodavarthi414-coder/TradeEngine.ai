-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-30 00:00:00.000'
-- Purpose      To Get Unread announcements
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetUnreadAnnouncementsOfAnUser] @OperationsPerformedBy = '6D6C3BC3-DECA-4BC6-8D27-67911CE36129',@UserId = 'A2D568D5-E45C-4ECA-8500-8AB0C15AA69A'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetUnreadAnnouncementsOfAnUser]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@UserId UNIQUEIDENTIFIER = NULL
    ,@MonthOfAnnounced DATETIME = NULL
	,@AnnouncementId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

	 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	 
	 IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
	 
	 IF (@AnnouncementId = '00000000-0000-0000-0000-000000000000') SET @AnnouncementId = NULL

	 IF(@MonthOfAnnounced IS NULL) SET @MonthOfAnnounced = GETDATE()

	 DECLARE @MonthStartDate DATETIME,@MonthEndDate DATETIME

	 SET @MonthStartDate = DATEADD(DAY,1,EOMONTH(@MonthOfAnnounced,-1))

	 SET @MonthEndDate = EOMONTH(@MonthOfAnnounced)

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	 
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	 
	 IF (@HavePermission = '1')
     BEGIN
		
			SELECT  A.Id AS AnnouncementId,
			        A.Announcement,
			        A.AnnouncedTo,
			        A.AnnouncementLevel,
			        A.CreatedByUserId AS AnnouncedById,
			        U.ProfileImage AS AnnouncedByUserImage,
			        U.FirstName + ' ' + ISNULL(U.SurName,'') AS AnnouncedBy,
			        A.CreatedDateTime As AnnouncedOn,
					UAR.ReadDateTime,
					CASE WHEN UAR.ReadDateTime IS NULL THEN 0 ELSE 1 END AS IsRead,
			        CASE WHEN A.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                    TotalAnnouncements = COUNT(1) OVER()
            FROM Announcement A
				 INNER JOIN [User] U ON U.Id = A.CreatedByUserId
				 INNER JOIN UserAnnouncementRead UAR ON UAR.AnnouncementId = A.Id
				            AND UAR.InActiveDateTime IS NULL
							AND UAR.UserId = @UserId
				WHERE A.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId
					  AND (CONVERT(DATE,A.CreatedDateTime) BETWEEN @MonthStartDate AND @MonthEndDate)
					  AND (@AnnouncementId IS NULL OR @AnnouncementId = A.Id)
               ORDER BY A.CreatedDateTime DESC

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
GO