CREATE PROCEDURE [dbo].[USP_UserDetails]
(
 @UserId uniqueidentifier,
 @CompanyId uniqueidentifier,
 @TimeZone NVARCHAR(50) = NULL
)
AS
BEGIN

	IF(@UserId = '00000000-0000-0000-0000-000000000000')
	BEGIN
	SET @UserId = NULL
	END

	DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN
		
		DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @UserId),0)

		IF(@TimeZone = '') SET @TimeZone = NULL

		SELECT U.Id Id,
		 UC.CompanyId,
		 U.SurName,
		 U.FirstName,
		 U.UserName,
		 U.FirstName + ' ' + ISNULL(U.SurName,'') AS FullName,
		 U.[Password],
		 U.IsPasswordForceReset,
		 U.IsActive,
		 U.TimeZoneId,
		 U.MobileNo,
		 U.IsAdmin,
		 U.IsActiveOnMobile,
		 U.ProfileImage,
		 U.RegisteredDateTime,
		 U.LastConnection,
		 U.CreatedDateTime,
		 U.CreatedByUserId,
		 U.UpdatedDateTime,
		 U.UpdatedByUserId,
		 U.InActiveDateTime,
		 U.[TimeStamp],
		 U.[Language] AS UserLanguage,
		 UA.[AuthToken] AS AuthToken,
		 C.[Language] AS CompanyLanguage,
		 C.IsDemoDataCleared,
		 C.CompanyName,
		 CS.[Value] as CompanyMainLogo,
		 CS1.[Value] as CompanyMiniLogo,
		 TZ.TimeZoneName + ' (' + TZ.TimeZone + ')' AS TimeZoneTitle,
         TZ.TimeZoneName,
		 TZ.TimeZoneOffset,
		 TZ.TimeZone,
		 TZ.TimeZoneAbbreviation,
		 TZ.CountryCode,
		 TZ.CountryName,
         TZ.OffsetMinutes,
		 CASE WHEN C.IsDemoDataCleared = 1 THEN 0 ELSE 1 END AS IsToShowDeleteIcon,
		 (SELECT C.Id AS CompanyId,
		         C.CompanyName,
				 UA.AuthToken,
				 U1.Id AS UserId,
				 C.SiteAddress,
				 CS2.[Value] AS CompanyMiniLogo
		         FROM [User] U1
				 JOIN UserCompany AS UC1 ON UC1.UserId = U1.Id AND UC1.InActiveDateTime IS NULL
				 JOIN [Company] C ON UC1.CompanyId = C.Id AND U1.UserName = U.UserName AND U1.InActiveDateTime IS NULL AND U1.IsActive = 1
				 LEFT JOIN [UserAuthToken] UA ON UA.UserId = U1.Id AND UA.CompanyId = UC1.CompanyId
		         LEFT JOIN [CompanySettings] CS2 ON CS2.CompanyId = UC1.CompanyId AND CS2.[Key] = 'MiniLogo'
				 FOR XML PATH('CompaniesList'), ROOT ('CompaniesList'), TYPE) AS CompaniesListXml
		FROM [User] U
		LEFT JOIN UserCompany AS UC ON UC.UserId = U.Id AND UC.InActiveDateTime IS NULL
		LEFT JOIN [UserAuthToken] UA ON UA.UserId = U.Id AND UA.CompanyId = UC.CompanyId
		LEFT JOIN [Company] C ON C.Id = UC.CompanyId AND C.InActiveDateTime IS NULL
		LEFT JOIN [CompanySettings] CS ON CS.CompanyId = UC.CompanyId AND CS.[Key] = 'MainLogo'
		LEFT JOIN [CompanySettings] CS1 ON CS1.CompanyId = UC.CompanyId AND CS1.[Key] = 'MiniLogo'
		LEFT JOIN [dbo].[TimeZone] TZ ON TZ.Id = U.TimeZoneId
		WHERE U.Id = @UserId AND (U.InActiveDateTime IS NULL OR @IsSupport = 1)

	END
END
