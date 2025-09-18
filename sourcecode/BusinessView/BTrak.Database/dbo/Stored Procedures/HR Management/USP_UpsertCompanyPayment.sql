CREATE PROCEDURE [dbo].[USP_UpsertCompanyPayment]
(
	@PaymentId UNIQUEIDENTIFIER = NULL,
	@NoOfPurchases INT NULL,
	@TotalAmount DECIMAL(15,2),
	@SubscriptionType NVARCHAR(250),
	@PurchaseType NVARCHAR(250),
	@StripeTokenId NVARCHAR(MAX),
	@StripeCustomerId NVARCHAR(MAX),
	@StripePaymentId NVARCHAR(MAX),
	@PricingId NVARCHAR(MAX),
	@SubscriptionId NVARCHAR(MAX),
	@Status VARCHAR(500),
	@IsSubscriptionDone BIT,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@siteAddress VARCHAR(250),
	@IsUpdated BIT = NULL,
	@CancelAt DATETIME,
	@CurrentPeriodEnd DATETIME,
	@CurrentPeriodStart DATETIME,
	@IsCancelled BIT,
	@CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		DECLARE @NewCompanyId UNIQUEIDENTIFIER;
		IF(@SiteAddress IS NOT NULL)
		BEGIN
				SET @NewCompanyId =(SELECT Id FROM Company WHERE @SiteAddress =  SiteAddress)
		END
		IF(@OperationsPerformedBy IS NOT NULL)
			BEGIN
				 SET @NewCompanyId =(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			END
       IF(@IsCancelled =1)
			SET @NewCompanyId = @CompanyId

			DECLARE @IsLatest BIT = (CASE WHEN @PaymentId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [CompanyPayment] WHERE Id = @PaymentId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			              DECLARE @Currentdate DATETIME = GETDATE()
			                 
                    IF (@PaymentId IS NULL)
					BEGIN
					
					SET @PaymentId = NEWID()
					INSERT INTO [dbo].[CompanyPayment]
										(
											[Id],
											[CompanyId],
											[Noofpurchasedlicences],
											[TotalAmountPaid],
											[PurchasedDatetime],
											[SubscriptionType],
											[StripeTokenId],
											[StripeCustomerId],
											[StripePaymentId],
											[PricingId],
											[SubscriptionId],
											[PurchaseType],
											[IsSubscriptionDone],
											[Status],
											[CreatedDateTime],
											[IsUpdate],
											[IsCancelled],
											[CancelAt],
											[CurrentPeriodStart],
											[CurrentPeriodEnd]
										)
						 SELECT				@PaymentId,
											@NewCompanyId,
											@NoOfPurchases,
											@TotalAmount,
											@Currentdate,
											@SubscriptionType,
											@StripeTokenId,
											@StripeCustomerId,
											@StripePaymentId,
											@PricingId,
											@SubscriptionId,
											@PurchaseType,
											@IsSubscriptionDone,
											@Status,
											@Currentdate,
											@IsUpdated,
											@IsCancelled,
											@CancelAt,
											@CurrentPeriodStart,
											@CurrentPeriodEnd
			                
					END
						ELSE
							BEGIN

									UPDATE [dbo].[CompanyPayment]
														SET [CompanyId]				= 	   @NewCompanyId,
															[Noofpurchasedlicences]	= 	   @NoOfPurchases,
															[TotalAmountPaid]		=@TotalAmount
															WHERE Id = @PaymentId

									END
			             
						SELECT Id FROM [dbo].[CompanyPayment] WHERE Id = @PaymentId
			                       
						END
			           ELSE
			           	RAISERROR (50008,11, 1)
			         
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
