CREATE PROCEDURE [dbo].[USP_GetPurchasedLicencesCount]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@siteAddress VARCHAR(250)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	    DECLARE @CompanyId UNIQUEIDENTIFIER 

		IF(@OperationsPerformedBy IS NULL)
			BEGIN
				SET @CompanyId =(SELECT Id FROM Company WHERE @SiteAddress =  SiteAddress)
		END
		ELSE
			BEGIN
				 SET @CompanyId =(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			END
       
			             
		SELECT TOP 1 Id AS PaymentId, Noofpurchasedlicences AS PurchasedLicensesCount
		,IsCancelled
		,CurrentPeriodEnd AS EndTime
		,PurchaseType,SubscriptionType
		,CASE WHEN (IsCancelled = 1 AND CurrentPeriodEnd <= GETDATE() OR IsRenewal = 0) THEN 0 ELSE 1 END AS IsShowCurrentPlan
		FROM [dbo].[CompanyPayment] WHERE CompanyId = @CompanyId ORDER BY CreatedDateTime DESC
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
