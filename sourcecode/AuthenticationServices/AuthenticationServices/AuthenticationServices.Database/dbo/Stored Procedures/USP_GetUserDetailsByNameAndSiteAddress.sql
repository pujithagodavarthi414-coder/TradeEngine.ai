CREATE PROCEDURE [dbo].[USP_GetUserDetailsByNameAndSiteAddress]
(
    @UserName nvarchar(250),
	@SiteAddress nvarchar(250),
	@IsSupportLogin BIT = NULL
)
AS
BEGIN
	
	IF(@IsSupportLogin IS NULL)
			SET @IsSupportLogin = 0;

	DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM [dbo].UserRole UR
			INNER JOIN [dbo].[Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                     WHERE UserId IN (SELECT Id FROM  [User] where UserName = @UserName)),0)

	IF(@IsSupport = 1 AND @IsSupportLogin = 0)
	BEGIN
			RAISERROR ('InvalidEmail',11, 1)
			RETURN
	END
	
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT C.Id FROM Company C
	                                       LEFT JOIN [CompanyAlias] CA ON CA.CompanyId = C.Id AND CA.InActiveDateTime IS NULL
	                                       WHERE  (@SiteAddress =  C.SiteAddress OR CA.[DomainName] = @SiteAddress)
										          AND C.InActiveDateTime IS NULL
											GROUP BY C.Id
										   )
	DECLARE @IsVerify BIT = null
	DECLARE @IndustryID UNIqueidentifier = (SELECT top 1 IndustryId  From Company where ID=@CompanyID)

	SELECT top 1 @IndustryID = IndustryId,@IsVerify = IsVerify
	From Company C 
	INNER JOIN UserCompany UC ON UC.CompanyId = C.Id
	INNER JOIN [User] U ON U.Id = UC.UserId WHERE UserName = @UserName AND UC.InActiveDateTime IS NULL ORDER BY IsVerify DESC

	IF(@IsVerify IS NULL OR @IsVerify = 0)
	BEGIN
			RAISERROR ('IsVerifyFailed',11, 1)
			RETURN
	END
	IF(@CompanyID IS NULL)
	BEGIN
		RAISERROR ('InvalidEmail',11, 1)
		RETURN
	END
	ELSE
	BEGIN
		DECLARE @PurchasedCount INT = NULL

		SET @PurchasedCount = ISNULL((SELECT TOP 1 CP.Noofpurchasedlicences FROM CompanyPayment CP WHERE CP.CompanyId = @CompanyID ORDER BY CreatedDateTime DESC) ,ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id=@CompanyId), 0))

		DECLARE @IsTrailValid NVARCHAR(10)

		SET @IsTrailValid = CASE WHEN (SELECT ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,GETDATE()) ) from Company C where C.Id=@CompanyId ) >0 THEN 'YES' ELSE 'NO' END
		
		IF(@IsTrailValid='NO' AND @IndustryID != '97973F64-4F4C-46B5-B096-4CC5D4AD8B20' AND  @PurchasedCount = 0)
		BEGIN

		RAISERROR ('TrailPeriodExpired',11, 1)
		RETURN

		END

		ELSE IF(@IsTrailValid='NO' AND @IndustryID = '97973F64-4F4C-46B5-B096-4CC5D4AD8B20' AND @PurchasedCount = 0)
		BEGIN

		RAISERROR ('EMPPeriodExpired',11, 1)
		RETURN

		END

		ELSE
		BEGIN
			SELECT U.Id AS Id
			   ,U.FirstName 
			   ,U.SurName
			   ,U.UserName
			   ,UC.CompanyId
			   ,U.MobileNo
			   ,U.[Password]
			   ,U.IsActive
			   ,C.ClientId
			   ,CS.Scope
			FROM [dbo].[User] U WITH (NOLOCK)
			INNER JOIN [dbo].[UserCompany] UC ON UC.UserId = U.Id
			INNER JOIN Clients AS C ON C.UserCompanyId = UC.Id
			INNER JOIN ClientScopes AS CS ON CS.ClientId = C.Id
			WHERE U.[UserName] = @UserName AND UC.CompanyId = @CompanyId AND UC.InActiveDateTime IS NULL
		END
	END
END