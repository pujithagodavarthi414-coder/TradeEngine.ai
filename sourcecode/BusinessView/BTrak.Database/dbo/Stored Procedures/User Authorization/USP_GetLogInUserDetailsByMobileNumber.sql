CREATE PROCEDURE [dbo].[USP_GetLogInUserDetailsByMobileNumber]
(
    @MobileNumber nvarchar(250)
)
AS
BEGIN

    DECLARE @CompanyID UNIqueidentifier = (SELECT top 1 CompanyId  From [User] where MobileNo = @MobileNumber)

	DECLARE @IsPurchased INT = NULL
	
	SET @IsPurchased = ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id=@CompanyId), 0)

	DECLARE @IsRemoteSite NVARCHAR(10) --= CASE WHEN  (SELECT C.IsRemoteAccess FROM Company C WHERE C.Id=@CompanyId AND C.NoOfPurchasedLicences IS NULL) = 1 THEN 'YES' ELSE NULL END

	--IF @IsRemoteSite = 'YES'  
	--SET @IsRemoteSite = CASE WHEN (SELECT C.IsRemoteAccess from Company C where C.Id=@CompanyId AND ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,GETDATE()) ) >0) =1 THEN 'YES' ELSE 'NO' END
	SET @IsRemoteSite = CASE WHEN (SELECT ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,GETDATE()) ) from Company C where C.Id=@CompanyId) >0 THEN 'YES' ELSE 'NO' END
	set  @IsPurchased =		1

	IF(@IsRemoteSite='NO' AND @IsPurchased = 0)
	BEGIN
	RAISERROR ('TrailPeriodExpired',11, 1)
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
	 
    WHERE U.MobileNo = @MobileNumber AND U.CompanyId = @CompanyID AND U.IsActiveOnMobile = 1
	END
END