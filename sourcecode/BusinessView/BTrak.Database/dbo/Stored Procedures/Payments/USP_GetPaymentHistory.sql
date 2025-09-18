CREATE PROCEDURE [dbo].[USP_GetPaymentHistory]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	    DECLARE @CompanyId UNIQUEIDENTIFIER 

		SET @CompanyId =(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		SELECT *,
		(SELECT TOP 1 Noofpurchasedlicences FROM CompanyPayment WHERE CompanyId = @CompanyId ORDER BY CreatedDatetime ASC) AS OriginalPurchases
		FROM [dbo].[CompanyPayment] WHERE CompanyId = @CompanyId ORDER BY CreatedDateTime DESC
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
