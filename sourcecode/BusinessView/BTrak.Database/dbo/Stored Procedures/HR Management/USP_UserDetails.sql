CREATE PROCEDURE [dbo].[USP_UserDetails]
(
 @UserId uniqueidentifier,
 @TimeZone NVARCHAR(50) = NULL
)
AS
BEGIN

IF(@UserId = '00000000-0000-0000-0000-000000000000')
BEGIN
SET @UserId = NULL
END

DECLARE @HavePermission NVARCHAR(250)  = '1'

 IF (@HavePermission = '1')
  BEGIN

DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
DECLARE @IsClient BIT = NULL
DECLARE @ClientId UNIQUEIDENTIFIER = NULL

   DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @UserId),0)

	IF(@TimeZone = '') SET @TimeZone = NULL

	IF(EXISTS(SELECT UserId FROM Client WHERE UserId=@UserId))
	BEGIN
		SET @IsClient = 1
		SET @ClientId = (SELECT ID FROM Client WHERE UserId=@UserId)
	END

 SELECT  U.Id Id,
		 U.CompanyId,
		 U.SurName,
		 U.FirstName,
		 U.UserName,
		 U.FirstName + ' ' + ISNULL(U.SurName,'') AS FullName,
		 U.[Password],
		 U.IsPasswordForceReset,
		 U.IsActive,
		 U.TimeZoneId,
		 TZ.TimeZoneOffset,
		 UT.TimeZoneName AS CurrentTimeZoneName,
		 UT.TimeZoneAbbreviation AS CurrentTimeZoneAbbr,
		 UT.TimeZoneOffset AS CurrentTimeZoneOffset,
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
		 UR.ReferenceId AS UserReferenceId,
		 U.[TimeStamp],
		 U.[Language] AS UserLanguage,
		 C.[Language] AS CompanyLanguage,
		 --U.AsAtInactiveDateTime,
		 B.BranchName,
		 B.Id BranchId,
		 (SELECT C.Id AS CompanyId,
		         C.CompanyName,
				 UA.AuthToken,
				 U1.Id AS UserId,
				 C.SiteAddress,
				 CS2.[Value] AS CompanyMiniLogo
		         FROM [User] U1
				 JOIN [Company] C ON U1.CompanyId = C.Id AND U1.UserName = U.UserName AND U1.InActiveDateTime IS NULL AND U1.IsActive = 1
				 LEFT JOIN [UserAuthToken] UA ON UA.UserId = U1.Id
		         LEFT JOIN [CompanySettings] CS2 ON CS2.CompanyId = U1.CompanyId AND CS2.[Key] = 'MiniLogo'
				 FOR XML PATH('CompaniesList'), ROOT ('CompaniesList'), TYPE) AS CompaniesListXml,
		 STUFF((SELECT ',' + RoleName
					      FROM UserRole UR
						       INNER JOIN [Role] R ON R.Id = UR.RoleId 
							              AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						  WHERE UR.UserId = U.Id
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
		 STUFF((SELECT ',' + CAST(R.Id AS NVARCHAR(50))
					      FROM UserRole UR
						       INNER JOIN [Role] R ON R.Id = UR.RoleId 
							              AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						  WHERE UR.UserId = U.Id
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleIds,
		 UE.FirstName Reporting,
		 UAD.ActiveFrom JoiningDate,
		 ER.ReportToEmployeeId,
		 C.IsDemoDataCleared,
		 C.CompanyName,
		 CS.[Value] as CompanyMainLogo,
		 CS1.[Value] as CompanyMiniLogo,
		 CASE WHEN @CompanyId = (SELECT [dbo].Ufn_GetCompanyIdBasedOnUserId(U.CreatedByUserId)) OR C.IsDemoDataCleared = 1 THEN 0 ELSE 1 END AS IsToShowDeleteIcon,
		 E.Id as EmployeeId,
		 @IsClient AS IsClient,
		 @ClientId AS ClientId
 From [User] U
 LEFT JOIN TimeZone UT ON UT.TimeZone = @TimeZone
 LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id AND UAD.InActiveDateTime IS NULL
 LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
 LEFT JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
 LEFT JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId = E.Id AND ER.InActiveDateTime IS NULL 
 LEFT JOIN Employee ERT ON ERT.Id = ER.ReportToEmployeeId AND U.InActiveDateTime IS NULL  
 LEFT JOIN [User] UE ON UE.Id = ERT.UserId AND UE.InActiveDateTime IS NULL 
 LEFT JOIN [Branch] B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL 
 LEFT JOIN [Company] C ON C.Id = U.CompanyId AND C.InActiveDateTime IS NULL
 LEFT JOIN [CompanySettings] CS ON CS.CompanyId = U.CompanyId AND CS.[Key] = 'MainLogo'
 LEFT JOIN [CompanySettings] CS1 ON CS1.CompanyId = U.CompanyId AND CS1.[Key] = 'MiniLogo'
 LEFT JOIN UserReference UR ON UR.UserId = U.Id
 WHERE U.Id = @UserId AND (U.InActiveDateTime IS NULL OR @IsSupport = 1)

 END

END
GO