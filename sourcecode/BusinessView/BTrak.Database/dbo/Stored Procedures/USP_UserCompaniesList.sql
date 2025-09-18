
-- EXEC [dbo].[USP_UserCompaniesList] @UserId='9dc43ec1-8f21-4c24-ae50-d528d752bf75'

CREATE PROCEDURE [dbo].[USP_UserCompaniesList]
(
 @UserId uniqueidentifier
)
AS
BEGIN

IF(@UserId = '00000000-0000-0000-0000-000000000000')
BEGIN
SET @UserId = NULL
END

DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))

IF (@HavePermission = '1')
  BEGIN

     DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @UserId),0)

				 SELECT C.Id AS CompanyId,
		         C.CompanyName,
				 UA.AuthToken,
				 U1.Id AS UserId,
				 C.SiteAddress,
				 CS2.[Value] AS CompanyMiniLogo
		         FROM [User] U1
				 JOIN [Company] C ON U1.CompanyId = C.Id AND U1.UserName = U1.UserName AND ((U1.InActiveDateTime IS NULL AND U1.IsActive = 1) OR @IsSupport = 1)
				 LEFT JOIN [UserAuthToken] UA ON UA.UserId = U1.Id
		         LEFT JOIN [CompanySettings] CS2 ON CS2.CompanyId = U1.CompanyId AND CS2.[Key] = 'MiniLogo'
				 WHERE U1.UserName = (SELECT UserName FROM [USER] WHERE ID = @UserId) AND (U1.InActiveDateTime IS NULL OR @IsSupport = 1)
					AND (((ISNULL(C.TrailDays, 0) -(DATEDIFF(day,C.CreatedDateTime,GETDATE()))) > 0) OR (ISNULL(C.NoOfPurchasedLicences, 0) > 0))
				AND C.IsVerify = 1
				 ORDER BY C.CompanyName ASC
  END
END
GO