--EXEC [dbo].[USP_GetUserDetailsByName] 'october1it@gmail.com', @ForRecurring = 1
CREATE PROCEDURE [dbo].[USP_GetUserDetailsByName]
(
    @UserName nvarchar(250),
	@ForRecurring BIT = null,
	@IsSupportLogin BIT = NULL
)
AS
BEGIN

	IF(@IsSupportLogin IS NULL)
			SET @IsSupportLogin = 0;

	DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR
 INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                     WHERE UserId IN (SELECT Id FROM  [User] where UserName = @UserName)),0)
IF(@IsSupport = 1 AND @IsSupportLogin = 0)
	BEGIN
			RAISERROR ('InvalidEmail',11, 1)
			RETURN
	END

    DECLARE @CompanyID UNIqueidentifier 
	-- (SELECT top 1 CompanyId  From [User] where UserName = @UserName)

	DECLARE @IndustryID UNIqueidentifier= null 
	DECLARE @IsVerify bit = null

	SELECT top 1 @IndustryID = IndustryId,@IsVerify = IsVerify,@CompanyID=C.Id 
	From Company C 
	INNER JOIN [User] U ON U.CompanyId = C.Id WHERE UserName = @UserName ORDER BY IsVerify DESC

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
	IF(@ForRecurring = 1)
	RETURN
	ELSE
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
		IF(@ForRecurring = 1)
	RETURN
	ELSE
		RAISERROR ('TrailPeriodExpired',11, 1)
		END

		ELSE IF(@IsTrailValid='NO' AND @IndustryID = '97973F64-4F4C-46B5-B096-4CC5D4AD8B20' AND @PurchasedCount = 0)
		BEGIN
		IF(@ForRecurring = 1)
	RETURN
	ELSE
		RAISERROR ('EMPPeriodExpired',11, 1)
		RETURN
		END

		ELSE
		BEGIN
			SELECT U.Id AS Id
			   ,U.FirstName 
			   ,U.SurName
			   ,U.UserName
			   ,U.CompanyId
			   ,U.MobileNo
			   ,U.[Password]
			   ,U.IsActive
		FROM [dbo].[User] U WITH (NOLOCK)
		WHERE U.[UserName] = @UserName
		END
	END
END