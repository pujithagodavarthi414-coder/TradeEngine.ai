-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Announcements
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAnnouncements] @OperationsPerformedBy = '6D6C3BC3-DECA-4BC6-8D27-67911CE36129',@EmployeeId = 'A2D568D5-E45C-4ECA-8500-8AB0C15AA69A'
-------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_GetAnnouncements]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @EmployeeId UNIQUEIDENTIFIER = NULL,
     @AnnouncementId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            IF(@AnnouncementId = '00000000-0000-0000-0000-000000000000') SET @AnnouncementId = NULL

            IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Employee WHERE Id = @EmployeeId AND InActiveDateTime IS NULL)

			DECLARE @RoleNames NVARCHAR(MAX) = (STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),R.RoleName))
                                                      FROM UserRole UR
                                                           INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                                      AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                                      WHERE UR.UserId = @UserId
                                                      ORDER BY RoleName
                                                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))

            IF(@EmployeeId IS NOT NULL)
            BEGIN

			SELECT  A.Id AS AnnouncementId,
					A.Announcement,
					A.AnnouncedTo,
					A.AnnouncementLevel,
					A.CreatedByUserId AS AnnouncedById,
					U.ProfileImage AS AnnouncedByUserImage,
					U.FirstName + ' ' + ISNULL(U.SurName,'') AS AnnouncedBy,
					@RoleNames AS AnnouncedByRole,
					A.CreatedDateTime As AnnouncedOn,
					CASE WHEN A.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                    TotalAnnouncements = COUNT(1) OVER()
            FROM Announcement A
				 INNER JOIN [User] U ON U.Id = A.CreatedByUserId
				 INNER JOIN UserAnnouncementRead UAR ON UAR.AnnouncementId = A.Id
				            AND UAR.InActiveDateTime IS NULL
							AND UAR.UserId = @UserId
							--AND UAR.ReadDateTime IS NULL  --TODO
				WHERE A.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId
               ORDER BY A.CreatedDateTime DESC

			END 
			ELSE 
			BEGIN

						SELECT  A.Id AS AnnouncementId,
								A.Announcement,
								A.AnnouncementLevel,
								A.CreatedByUserId AS AnnouncedById,
								U.ProfileImage AS AnnouncedByUserImage,
								U.FirstName + ' ' + ISNULL(U.SurName,'') AS AnnouncedBy,
								STUFF((SELECT ',' + CAST(UAR.UserId AS NVARCHAR(36))
								        FROM UserAnnouncementRead UAR
									  WHERE UAR.AnnouncementId = @AnnouncementId
                                            AND UAR.InActiveDateTime IS NULL
								 FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')	AS AnnouncedTo,
								A.CreatedDateTime As AnnouncedOn
						        FROM Announcement A
							         INNER JOIN [User] U ON U.Id = A.CreatedByUserId AND A.Id = @AnnouncementId
								WHERE A.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId

			END
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
