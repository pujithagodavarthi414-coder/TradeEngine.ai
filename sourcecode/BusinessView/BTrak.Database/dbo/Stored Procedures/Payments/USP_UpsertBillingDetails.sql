CREATE PROCEDURE [dbo].[USP_UpsertBillingDetails]
(
	@SubscriptionId VARCHAR(250),
	@StripeCustomerId VARCHAR(250),
	@Status VARCHAR(250),
	@IsSubscriptionDone BIT,
	@InvoiceId  VARCHAR(250),
	@PricingId VARCHAR(250),
	@IsRenewal BIT = NULL,
	@TotalAmount DECIMAL(10,2)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		 DECLARE @Currentdate DATETIME = GETDATE()
	   
	   INSERT INTO [dbo].[CompanyPayment]
										(
											[Id],
											[CompanyId],
											[Noofpurchasedlicences],
											[TotalAmountPaid],
											[PurchasedDatetime],
											[SubscriptionType],
											[StripeCustomerId],
											[PricingId],
											[SubscriptionId],
											[PurchaseType],
											[IsSubscriptionDone],
											[Status],
											[CreatedDateTime]
										)
						 SELECT	TOP 1		NEWID(),
											CompanyId,
											Noofpurchasedlicences,
											@TotalAmount,
											@Currentdate,
											SubscriptionType,
											@StripeCustomerId,
											@PricingId,
											@SubscriptionId,
											PurchaseType,
											@IsSubscriptionDone,
											@Status,
											@Currentdate
								FROM [dbo].[CompanyPayment]  WHERE (SubscriptionId = @SubscriptionId OR InvoiceId = @InvoiceId) AND (IsCancelled IS NULL OR IsCancelled = 0) ORDER BY CreatedDateTime DESC
			             
		SELECT Id FROM [dbo].[CompanyPayment] WHERE SubscriptionId = @SubscriptionId ORDER BY CreatedDateTime DESC
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END


