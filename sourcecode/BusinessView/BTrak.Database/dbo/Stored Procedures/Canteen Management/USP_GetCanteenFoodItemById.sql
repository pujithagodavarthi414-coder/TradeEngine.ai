-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-15 00:00:00.000'
-- Purpose      To Get the Canteen FoodItem By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
--   EXEC [dbo].[USP_GetCanteenFoodItemById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--   @CanteenFoodItemId='2AD7E1C8-C59A-415B-AB91-202ED4B96614'
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetCanteenFoodItemById]
(
   @CanteenFoodItemId  UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	      SELECT CFI.Id AS FoodItemId,
		         CFI.FoodItemName AS FoodItemName,
                 CFI.Price,
                 CFI.ActiveFrom,
                 CFI.ActiveTo,
                 CFI.CurrencyId,
				 CurrencyName  = (SELECT [CurrencyName] FROM Currency WHERE Id = CFI.CurrencyId),
				 CFI.CreatedDateTime AS ItemAddedDate,
				 CFI.CreatedByUserId,
				 CreatedByUserName=(SELECT U.FirstName+' '+ISNULL(U.SurName,'') FROM [User]U WHERE U.Id = CFI.CreatedByUserId)
		  FROM  [dbo].[CanteenFoodItem] CFI WITH (NOLOCK)
		  WHERE Id = @CanteenFoodItemId AND CompanyId = @CompanyId
	 END TRY  
	 BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH
END