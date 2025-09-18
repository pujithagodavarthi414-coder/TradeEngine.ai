CREATE PROCEDURE [dbo].[USP_GetAllSubscritionIds]
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

		IF(@OperationsPerformedBy IS NOT NULL)
			BEGIN
				SET @CompanyId =(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		END
			             
		SELECT DISTINCT SubscriptionId FROM [dbo].[CompanyPayment] WHERE CompanyId = @CompanyId 
			                       
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
