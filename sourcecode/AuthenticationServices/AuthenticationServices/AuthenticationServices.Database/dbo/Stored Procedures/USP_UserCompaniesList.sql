CREATE PROCEDURE [dbo].[USP_UserCompaniesList]
(
 @UserId uniqueidentifier
)
AS
BEGIN
    SET NOCOUNT ON
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN
		
		DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @UserId),0)

		SELECT C.Id AS CompanyId,
		         C.CompanyName,
				 UA.AuthToken,
				 U1.Id AS UserId,
				 C.SiteAddress,
                        STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U1.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleIds,
				 CS2.[Value] AS CompanyMiniLogo
		         FROM [User] U1
				 JOIN UserCompany AS UC ON UC.UserId = U1.Id AND UC.InActiveDateTime IS NULL AND ((U1.InActiveDateTime IS NULL AND U1.IsActive = 1) OR @IsSupport = 1) AND (UC.InActiveDateTime IS NULL)
				 JOIN [Company] C ON UC.CompanyId = C.Id AND U1.UserName = U1.UserName
				 LEFT JOIN [UserAuthToken] UA ON UA.UserId = U1.Id AND UA.CompanyId = UC.CompanyId
		         LEFT JOIN [CompanySettings] CS2 ON CS2.CompanyId = UC.CompanyId AND CS2.[Key] = 'MiniLogo'
				 WHERE U1.UserName = (SELECT UserName FROM [User] WHERE Id = @UserId) AND (U1.InActiveDateTime IS NULL OR @IsSupport = 1)
					AND (((ISNULL(C.TrailDays, 0) -(DATEDIFF(day,C.CreatedDateTime,GETDATE()))) > 0) OR (ISNULL(C.NoOfPurchasedLicences, 0) > 0))
				AND C.IsVerify = 1
				 ORDER BY C.CompanyName ASC

	END

END