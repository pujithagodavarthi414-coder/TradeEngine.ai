CREATE PROCEDURE [dbo].[USP_GetSubscriptionId]
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
       
			             
		SELECT TOP 1 SubscriptionId FROM [dbo].[CompanyPayment] WHERE CompanyId = @CompanyId AND (IsCancelled IS NULL or IsCancelled = 0) ORDER BY CreatedDateTime DESC
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
