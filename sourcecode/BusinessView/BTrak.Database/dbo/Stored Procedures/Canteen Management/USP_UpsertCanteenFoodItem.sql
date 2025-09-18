-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-15 00:00:00.000'
-- Purpose      To Save Or Update the CateenFoodItem based on CanteenFoodItemId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCanteenFoodItem] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Price=2000.00
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertCanteenFoodItem]
(
    @CanteenFoodItemId     UNIQUEIDENTIFIER = NULL,
	@CanteenFoodItemName   NVARCHAR(250) = NULL,
	@BranchId			   UNIQUEIDENTIFIER = NULL,
	@CurrencyId            UNIQUEIDENTIFIER = NULL,
	@Price                 MONEY = NULL,
	@ActiveFrom            DateTime = NULL,
	@ActiveTo              DateTime = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@TimeStamp             TimeStamp = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   	SET NOCOUNT ON
	BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN

				IF (@BranchId IS NULL)
				BEGIN

					RAISERROR(50011,16,2,'Branch')

				END
				ELSE
				BEGIN
			    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
			    
			    DECLARE @CanteenFoodItemIdCount INT = (SELECT COUNT(1) FROM CanteenFoodItem WHERE Id = @CanteenFoodItemId AND CompanyId = @CompanyId)

				DECLARE @CanteenFoodItemNameCount INT = (SELECT COUNT(1) FROM CanteenFoodItem WHERE FoodItemName = @CanteenFoodItemName AND CompanyId = @CompanyId AND BranchId = @BranchId AND (@CanteenFoodItemId IS NULL OR Id <> @CanteenFoodItemId))

		        IF(@CanteenFoodItemIdCount = 0 AND @CanteenFoodItemId IS NOT NULL)
		        BEGIN
			    
		        	RAISERROR(50002,16, 1,'CanteenFoodItem')
			    
		        END

				ELSE IF(@CanteenFoodItemNameCount > 0)
			    BEGIN

			      RAISERROR(50001,16,1,'CanteenFoodItem')

			    END
			        
			    ELSE
			    BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @CanteenFoodItemId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
				                         FROM [CanteenFoodItem] WHERE Id = @CanteenFoodItemId) = @TimeStamp 
								   THEN 1 ELSE 0 END END)

					IF(@IsLatest = 1)
					BEGIN

		                DECLARE @Currentdate DATETIME = GETDATE()
		                
						IF(@CanteenFoodItemId IS NULL)
						BEGIN

							SET @CanteenFoodItemId = NEWID()

							INSERT INTO [dbo].[CanteenFoodItem](
			      				        [Id],
								        [CompanyId],
			      					    [FoodItemName],
								        [Price],
									    [ActiveFrom],
									    [ActiveTo],
								        [CreatedByUserId],
								        [CreatedDateTime],
										[BranchId],
										[CurrencyId]
										)
							     SELECT @CanteenFoodItemId,
								        @CompanyId,
									    @CanteenFoodItemName,
									    @Price,
									    @ActiveFrom,
									    @ActiveTo,
								        @OperationsPerformedBy,
								        @Currentdate,
										@BranchId,
										@CurrencyId
							
						END
						ELSE
						BEGIN

						UPDATE [dbo].[CanteenFoodItem]
			      			   SET [CompanyId] = @CompanyId,
			      				    [FoodItemName] = @CanteenFoodItemName,
							        [Price] = @Price,
								    [ActiveFrom] = @ActiveFrom,
								    [ActiveTo] = @ActiveTo,
							        [UpdatedDateTime] = @Currentdate,
							        [UpdatedByUserId] = @OperationsPerformedBy,
									[BranchId] = @BranchId,
									[CurrencyId] = @CurrencyId
								WHERE Id = @CanteenFoodItemId

						END
					SELECT  Id FROM [dbo].[CanteenFoodItem] where Id = @CanteenFoodItemId
				 END
			     ELSE
			     BEGIN
			     
			         RAISERROR (50008,11, 1)
			     
			     END
		   END
	  END
	  END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,10, 1)
	  
	  END
      END TRY  
	  BEGIN CATCH 
	  	
	  		THROW
	  
	  END CATCH
END