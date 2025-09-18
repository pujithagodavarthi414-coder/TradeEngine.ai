--EXEC [dbo].[USP_GetUserDetailsByName] 'kandapu.sushmitha@gmail.com'
CREATE PROCEDURE [dbo].[USP_GetUserDetailsByNameAndCompanyId]
(
    @UserName nvarchar(250),
	@CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN

   -- DECLARE @CompanyID UNIqueidentifier = (SELECT top 1 CompanyId  From [User] where UserName = @UserName)

	DECLARE @IndustryID UNIqueidentifier = (SELECT top 1 IndustryId  From Company where ID=@CompanyID)

	IF(@CompanyID IS NULL)
	BEGIN
		--RAISERROR ('InvalidEmail',11, 1)
		RETURN
	END
	ELSE
	BEGIN
		DECLARE @PurchasedCount INT = NULL
	
		SET @PurchasedCount = ISNULL((SELECT TOP 1 CP.Noofpurchasedlicences FROM CompanyPayment CP WHERE CP.CompanyId = @CompanyID ORDER BY CreatedDateTime DESC) ,ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id=@CompanyId), 0))

		DECLARE @IsTrailValid NVARCHAR(10) 

		SET @IsTrailValid = CASE WHEN (SELECT ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,GETDATE()) ) from Company C where C.Id=@CompanyId) >0 THEN 'YES' ELSE 'NO' END

		IF(@IsTrailValid='NO' AND @IndustryID != '97973F64-4F4C-46B5-B096-4CC5D4AD8B20' AND  @PurchasedCount = 0)
		BEGIN
		--RAISERROR ('TrailPeriodExpired',11, 1)
		RETURN
		END

		ELSE IF(@IsTrailValid='NO' AND @IndustryID = '97973F64-4F4C-46B5-B096-4CC5D4AD8B20' AND @PurchasedCount = 0)
		BEGIN
		--RAISERROR ('EMPPeriodExpired',11, 1)
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
		WHERE U.[UserName] = @UserName AND CompanyId = @CompanyId
		END
	END
END