-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-30 00:00:00.000'
-- Purpose      To Get Unread announcements
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetReadAndUnReadUsersOfAnnouncement] @OperationsPerformedBy = '6D6C3BC3-DECA-4BC6-8D27-67911CE36129'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetReadAndUnReadUsersOfAnnouncement]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@AnnouncementId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
	
	 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	 
	 IF (@AnnouncementId = '00000000-0000-0000-0000-000000000000') SET @AnnouncementId = NULL

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	 
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	 
	 IF (@HavePermission = '1')
     BEGIN
			
		SELECT  A.Id AS AnnouncementId,
				A.Announcement,
				A.CreatedByUserId AS AnnouncedById,
				U.ProfileImage AS AnnouncedByUserImage,
				U.FirstName + ' ' + ISNULL(U.SurName,'') AS AnnouncedBy,
				A.CreatedDateTime As AnnouncedOn,
				UAR.ReadDateTime,
				CASE WHEN UAR.ReadDateTime IS NULL THEN 0 ELSE 1 END AS IsRead,
				UAR.UserId AS AnnouncedToUserId,
				AU.ProfileImage AS AnnouncedToUserImage,
				AU.FirstName + ' ' + ISNULL(AU.SurName,'') AS AnnouncedToUser,
				TotalAnnouncements = COUNT(1) OVER()
			FROM Announcement A
				INNER JOIN [User] U ON U.Id = A.CreatedByUserId
				INNER JOIN UserAnnouncementRead UAR ON UAR.AnnouncementId = A.Id
						AND UAR.InActiveDateTime IS NULL
				INNER JOIN [User] AU ON AU.Id = UAR.UserId AND AU.InActiveDateTime IS NULL
			WHERE A.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId
					AND (@AnnouncementId IS NULL OR @AnnouncementId = A.Id)

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