-------------------------------------------------------------------------------
-- Author       Padmini
-- Created      '2019-03-16 00:00:00.000'
-- Purpose      To Purchase Canteen Item
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- declare @CanteenFoodItemsXml xml = N'<GenericListOfPurchaseCanteenItemInputModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
-- <ListItems>
-- <PurchaseCanteenItemInputModel>
-- <CanteenItemId>49e4de34-d46c-460f-8100-2957fbd69bb6</CanteenItemId>
-- <Quantity>1</Quantity></PurchaseCanteenItemInputModel>
-- </ListItems>
-- </GenericListOfPurchaseCanteenItemInputModel>'
   
-- EXEC USP_PurchaseCanteenItem @CanteenFoodItemsXml,
-- 								  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036972'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_PurchaseCanteenItem]
(
  @CanteenFoodItemsXml  XML,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL
)
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
			
			DECLARE @CanteenFoodiems TABLE
			(
				CanteenItemId UNIQUEIDENTIFIER,
				Quantity INT,
				Price FLOAT
			)

			INSERT INTO @CanteenFoodiems(CanteenItemId,Quantity)
			SELECT x.y.value('CanteenItemId[1]', 'UNIQUEIDENTIFIER')
			       ,x.y.value('Quantity[1]', 'INT')
			  FROM @CanteenFoodItemsXml.nodes('/GenericListOfPurchaseCanteenItemInputModel/*/PurchaseCanteenItemInputModel') AS x(y)

			UPDATE @CanteenFoodiems SET Price = CFI.Price
			FROM @CanteenFoodiems CI 
			     INNER JOIN CanteenFoodItem CFI ON CFI.Id = CI.CanteenItemId 
				           AND CFI.[ActiveFrom] <= GETDATE() AND (CFI.[ActiveTo] IS NULL OR CFI.[ActiveTo] >= GETDATE())

			DECLARE @Balance FLOAT, @PurchaseAmount  FLOAT
			
			SET @PurchaseAmount = ISNULL((SELECT SUM(Quantity * Price) FROM @CanteenFoodiems),0)

			SET @Balance = ISNULL((SELECT SUM(Amount)
			            FROM [UserCanteenCredit] 
			            WHERE CreditedToUserId = @OperationsPerformedBy 
						GROUP BY CreditedToUserId),0) - ISNULL((SELECT SUM(UPC.Quantity * UPC.FoodItemPrice) 
						FROM CanteenFoodItem CFI INNER JOIN [UserPurchasedCanteenFoodItem] UPC ON CFI.Id = UPC.FoodItemId
						AND (CFI.ActiveTo IS NULL OR CFI.ActiveTo <= GETDATE()) 
						WHERE UPC.UserId = @OperationsPerformedBy),0)
						
			IF(NOT EXISTS(SELECT 1 FROM @CanteenFoodiems))
		    BEGIN
		       
		        RAISERROR(50011,16, 2, 'Canteen item')
		    
		    END
		    ELSE IF(EXISTS(SELECT 1 FROM @CanteenFoodiems WHERE Quantity = 0))
		    BEGIN
		       
		        RAISERROR(50011,16, 2, 'Quantity')
		    
		    END
			ELSE IF(@Balance < @PurchaseAmount)
			BEGIN
				
		        RAISERROR(50023,16, 2)

			END
		    ELSE 
		    BEGIN

		    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN

			     DECLARE @Currentdate DATETIME = GETDATE()
			     
                 INSERT INTO [dbo].[UserPurchasedCanteenFoodItem](
                             [Id],
                             [UserId],
                             [FoodItemId],
                             Quantity,
							 FoodItemPrice,
                             [PurchasedDateTime],
							 [InActiveDateTime])
                      SELECT NEWID(),
                             @OperationsPerformedBy,
                             CFI.CanteenItemId,
					         CFI.Quantity,
							 CFI.Price,
                             @Currentdate,
							 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		                FROM @CanteenFoodiems CFI
			     
		           SELECT CASE WHEN (SELECT Count(Id) FROM [UserPurchasedCanteenFoodItem] 
				   WHERE [FoodItemId] IN (SELECT CanteenItemId FROM @CanteenFoodiems)) > 0 THEN 1 ELSE 0 END

			END
			ELSE
			BEGIN

			     RAISERROR (@HavePermission,10, 1)

			END
			END
 END TRY
 BEGIN CATCH

         THROW

 END CATCH
END