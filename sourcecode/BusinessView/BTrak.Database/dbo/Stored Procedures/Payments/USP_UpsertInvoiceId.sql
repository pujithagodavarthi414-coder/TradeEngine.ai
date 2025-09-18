CREATE PROCEDURE [dbo].[USP_UpsertInvoiceId]
(
	@SubscriptionId VARCHAR(250),
	@InvoiceId VARCHAR(250)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		 UPDATE [dbo].[CompanyPayment] SET InvoiceId = @InvoiceId WHERE SubscriptionId = @SubscriptionId
		 SELECT top 1 Id FROM [dbo].[CompanyPayment] WHERE SubscriptionId = @SubscriptionId                     
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END


