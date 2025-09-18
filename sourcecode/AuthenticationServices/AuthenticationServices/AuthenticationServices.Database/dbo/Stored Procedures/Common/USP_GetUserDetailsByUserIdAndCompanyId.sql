CREATE PROCEDURE [dbo].[USP_GetUserDetailsByUserIdAndCompanyId]
(
@UserId UNIQUEIDENTIFIER,
@CompanyId UNIQUEIDENTIFIER,
@IsSupportLogin BIT = NULL
)
AS
BEGIN
	
	IF(@IsSupportLogin IS NULL)
			SET @IsSupportLogin = 0;

	DECLARE @IndustryID UNIqueidentifier= null 
	DECLARE @IsVerify bit = null

	SELECT top 1 @IndustryID = IndustryId,@IsVerify = IsVerify
	From Company C 
	INNER JOIN UserCompany AS UC ON UC.CompanyId = C.Id
	INNER JOIN [User] U ON U.Id = UC.UserId 
	WHERE U.Id = @UserId AND C.Id = @CompanyId ORDER BY IsVerify DESC

	IF(@IsVerify IS NULL OR @IsVerify = 0)
	BEGIN
			RAISERROR ('IsVerifyFailed',11, 1)
			RETURN
	END

	DECLARE @IsLoginAllow bit
		IF EXISTS(SELECT * FROM(
		 SELECT *, ROW_NUMBER() OVER (ORDER BY CreatedDateTime DESC) [RowNo] FROM CompanyPayment WHERE companyId =@CompanyID)T WHERE RowNo = 1
			AND IsCancelled = 1 AND CurrentPeriodEnd <= GETDATE()
			OR IsRenewal =0)
			BEGIN
					SET @IsLoginAllow = 0
			END
			ELSE
			BEGIN
					SET @IsLoginAllow = 1
			END

	IF(@CompanyID IS NULL)
	BEGIN
		RAISERROR ('InvalidEmail',11, 1)
		RETURN
	END
	ELSE
	BEGIN
		
		DECLARE @PurchasedCount INT = NULL
		
			IF @IsLoginAllow = 1 SET @PurchasedCount = ISNULL((SELECT TOP 1 CP.Noofpurchasedlicences FROM CompanyPayment CP WHERE CP.CompanyId = @CompanyID ORDER BY CreatedDateTime DESC) ,ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id=@CompanyId) ,0))
			IF @IsLoginAllow = 0 SET @PurchasedCount=  ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id=@CompanyId) ,0)

			DECLARE @IsTrailValid NVARCHAR(10) 

			SET @IsTrailValid = CASE WHEN (SELECT ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,GETDATE()) ) from Company C where C.Id=@CompanyId) >0 THEN 'YES' ELSE 'NO' END

			IF(@IsTrailValid='NO' AND @IsLoginAllow =0 AND  @PurchasedCount = 0)
			BEGIN 
				RAISERROR ('TrailPeriodExpired',11, 1)
				RETURN
			END
			ELSE
			IF(@IsTrailValid='NO' AND @IndustryID != '97973F64-4F4C-46B5-B096-4CC5D4AD8B20' AND  @PurchasedCount = 0)
			BEGIN
				RAISERROR ('TrailPeriodExpired',11, 1)
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
				   --,U.MobileNo
				   ,U.[Password]
				   ,U.IsActive
				   ,C.ClientId
				   ,CS.Scope
			FROM [dbo].[User] U WITH (NOLOCK)
			INNER JOIN UserCompany AS UC ON UC.UserId = U.Id
			INNER JOIN Clients AS C ON C.UserCompanyId = UC.Id
			INNER JOIN ClientScopes AS CS ON CS.ClientId = C.Id
			WHERE U.Id = @UserId AND UC.CompanyId = @CompanyId
			END
	END
END