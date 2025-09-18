-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update CurrencyConversion
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCurrencyConversion] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FromCurrency='AC0A1802-6BB1-4FA5-B4F6-0A786BC5AE10',
--@ToCurrency='EE25AD9A-0352-4BE8-A58A-847E85F0F3E5',@EffectiveFrom='2019-05-07 19:05:05.863',@CurrencyRate='70'								  
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertCurrencyConversion]
(
   @CurrencyConversionId UNIQUEIDENTIFIER = NULL,
   @FromCurrency UNIQUEIDENTIFIER = NULL,
   @ToCurrency UNIQUEIDENTIFIER = NULL,
   @EffectiveFrom  DATETIME = NULL,
   @CurrencyRate  INT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@FromCurrency IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'FromCurrency')

		END
		ELSE IF(@ToCurrency IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'ToCurrency')

		END
		ELSE IF(@EffectiveFrom IS NULL)
		BEGIN
		   
		   RAISERROR(50011,16, 2, 'EffectiveFrom')

		END
		ELSE
		BEGIN

		DECLARE @CurrencyConversionIdCount INT = (SELECT COUNT(1) FROM CurrencyConversion  WHERE Id = @CurrencyConversionId)
        
	    IF(@CurrencyConversionIdCount = 0 AND @CurrencyConversionId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'CurrencyConversion')
        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @CurrencyConversionId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [CurrencyConversion] WHERE Id = @CurrencyConversionId ) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			         	     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
			                 IF(@CurrencyConversionId IS NULL)
			                 BEGIN
			                 
			                 SET @CurrencyConversionId = NEWID()
			                 
                             INSERT INTO [dbo].[CurrencyConversion](
                                         [Id],
			                 			 [CompanyId],
			                 			 [CurrencyFromId],						
			                 			 [CurrencyToId],
			                 			 [EffectiveDateTime],
			                 			 [CurrencyRate],						 
			                 			 [InActiveDateTime],
			                 			 [CreatedDateTime],
			                 			 [CreatedByUserId]				
			                 			 )
                                  SELECT @CurrencyConversionId,
			                 			 @CompanyId,
			                 			 @FromCurrency,
			                 			 @ToCurrency,
			                 			 @EffectiveFrom,
			                 			 @CurrencyRate,
			                 			 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
			                 			 @Currentdate,
			                 			 @OperationsPerformedBy		
		                          
			                 	  END
			                 	  ELSE
			                 	  BEGIN
			                 
			                 	  UPDATE [CurrencyConversion]
			                 	  SET    [CompanyId] = @CompanyId,
			                 			 [CurrencyFromId] = @FromCurrency,						
			                 			 [CurrencyToId] = @ToCurrency,
			                 			 [EffectiveDateTime] = @EffectiveFrom,
			                 			 [CurrencyRate]  = @CurrencyRate,	 					 
			                 			 [InActiveDateTime] = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
			                 			 [UpdatedDateTime] = @Currentdate,
			                 			 [UpdatedByUserId] = @OperationsPerformedBy
			                 	   WHERE Id = @CurrencyConversionId
			                 
			                 	  END

			             SELECT Id FROM [dbo].[CurrencyConversion] WHERE Id = @CurrencyConversionId
			                       
			           END
			           ELSE
			         
			           	RAISERROR (50008,11, 1)
			         
			         END
			         ELSE
			         BEGIN
			         
			         		RAISERROR (@HavePermission,11, 1)
			         		
			         END
           END
		END
		
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO

