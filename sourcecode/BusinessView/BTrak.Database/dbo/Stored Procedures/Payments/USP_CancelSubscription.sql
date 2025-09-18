CREATE PROCEDURE [dbo].[USP_CancelSubscription]
(
	@SubscriptionId VARCHAR(250),
	@CancelAt DATETIME,
	@CurrentPeriodEnd DATETIME,
	@CurrentPeriodStart DATETIME,
	@IsCancelled BIT
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		UPDATE [dbo].[CompanyPayment] 
			SET  IsCancelled = @IsCancelled
				,[Status]='canceled'
				,[CancelAt] = @CancelAt
				,[CurrentPeriodStart] = @CurrentPeriodStart
				,[CurrentPeriodEnd] = @CurrentPeriodEnd
				 WHERE SubscriptionId = @SubscriptionId
			             
		SELECT Id FROM [dbo].[CompanyPayment] WHERE SubscriptionId = @SubscriptionId
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
