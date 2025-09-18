CREATE PROCEDURE [dbo].[USP_GetPaymentDetailsWithSubscriptionId]
(
	@SubscriptionId VARCHAR(250)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		SELECT * FROM [dbo].[CompanyPayment] WHERE SubscriptionId=@SubscriptionId ORDER BY CreatedDateTime DESC
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
