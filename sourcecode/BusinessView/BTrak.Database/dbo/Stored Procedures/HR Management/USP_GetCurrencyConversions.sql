---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Currencyconversions by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetCurrencyConversions] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCurrencyConversions]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@FromCurrency UNIQUEIDENTIFIER = NULL,
	@ToCurrency UNIQUEIDENTIFIER = NULL,
	@EffectiveFrom DATETIME = NULL,
	@CurrencyRate  INT = NULL,
	@CurrencyConversionId UNIQUEIDENTIFIER = NULL,		
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   IF(@CurrencyConversionId = '00000000-0000-0000-0000-000000000000') SET @CurrencyConversionId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CC.Id AS CurrencyConversionId,
		   	      CC.CompanyId,
				  CC.CurrencyFromId,
		   	      CC.CurrencyToId,
				  CC.CurrencyRate,
				  CC.EffectiveDateTime,			
		   	      CC.InActiveDateTime,
		   	      CC.CreatedDateTime ,
		   	      CC.CreatedByUserId,
		   	      CC.[TimeStamp],	
		   	      TotalCount = COUNT(*) OVER()
           FROM CurrencyConversion AS CC		        
           WHERE CC.CompanyId = @CompanyId
				AND (@CurrencyConversionId IS NULL OR CC.Id = @CurrencyConversionId)
		        AND (@ToCurrency IS NULL OR CC.CurrencyToId = @ToCurrency)
				AND (@FromCurrency IS NULL OR CC.CurrencyFromId = @FromCurrency)
		   	    AND (@EffectiveFrom IS NULL OR CC.EffectiveDateTime = @EffectiveFrom)
				AND (@CurrencyRate IS NULL OR CC.CurrencyRate = @CurrencyRate)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CC.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CC.InActiveDateTime IS NULL))
		   	    
           ORDER BY CC.EffectiveDateTime ASC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END