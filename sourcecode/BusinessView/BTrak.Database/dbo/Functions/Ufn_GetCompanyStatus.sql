CREATE FUNCTION [dbo].[Ufn_GetCompanyStatus]
(
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS @CompanyActiveStatus TABLE
(
	TrailVersion BIT,
	PaidVersion BIT,
	Expired BIT
)
BEGIN

	DECLARE @TrailVersion BIT = 0
	DECLARE @PaidVersion BIT = 0
	DECLARE @Expired BIT = 0

	IF EXISTS(SELECT * FROM(
		SELECT *, ROW_NUMBER() OVER (ORDER BY CreatedDateTime DESC) [RowNo] FROM CompanyPayment WHERE companyId =@CompanyID)T WHERE RowNo = 1
		AND IsCancelled = 1 AND CurrentPeriodEnd <= GETDATE()
		OR IsRenewal =0)
	BEGIN
			SET @Expired = 1
	END
	ELSE
	BEGIN
			SET @Expired = 0
	END

	SET @TrailVersion = CASE WHEN 
		(
			SELECT ISNULL(C.TrailDays, 90) - (DATEDIFF(DAY, C.CreatedDateTime,GETDATE())) 
			FROM Company C WHERE C.Id = @CompanyId
		) > 0 THEN 1 ELSE 0 END

	DECLARE @PurchasedCount INT = NULL
	
	SET @PurchasedCount = ISNULL((SELECT TOP 1 CP.Noofpurchasedlicences FROM CompanyPayment CP WHERE CP.CompanyId = @CompanyID ORDER BY CreatedDateTime DESC) ,ISNULL((SELECT C.NoOfPurchasedLicences FROM Company C WHERE C.Id = @CompanyId), 0))

	IF(@PurchasedCount > 0)
	BEGIN
		SET @PaidVersion = 1
	END

	INSERT INTO @CompanyActiveStatus (TrailVersion, PaidVersion, Expired)
	VALUES (@TrailVersion, @PaidVersion, @Expired)

	RETURN
END
GO
