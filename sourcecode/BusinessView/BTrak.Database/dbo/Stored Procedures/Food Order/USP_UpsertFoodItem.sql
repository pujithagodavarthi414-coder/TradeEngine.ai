-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Save Or Update the FoodItem based on CanteenFoodItemId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertFoodItem] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FoodItemName='Test1',
 --@Price=2000.00,@CurrencyId='DF549957-74CC-4622-A094-05F64973F092',@ActiveFrom = '2018-03-01 00:00:00.000',@FoodItemId = '2D125F48-327B-44D5-92A1-A383FDDF2638',@TimeStamp = 0x000000000000165B
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFoodItem]
(
    @FoodItemId            UNIQUEIDENTIFIER = NULL,
	@FoodItemName          NVARCHAR(250) = NULL,
	@Price                 MONEY = NULL,
	@CurrencyId            UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@TimeStamp             TIMESTAMP = NULL,
	@ActiveFrom            DateTime = NULL,
	@ActiveTo              DateTime = NULL
)
AS
BEGIN
   	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@FoodItemName = '') SET @FoodItemName = NULL

		IF(@Price = '') SET @Price = NULL

	    IF(@FoodItemName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ItemName')

		END
		ELSE IF(@Price IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Price')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ActiveFrom')

		END
		ELSE 
		BEGIN
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

		DECLARE @FoodItemNameCount INT = (SELECT COUNT(1) FROM CanteenFoodItem WHERE FoodItemName = @FoodItemName AND CompanyId = @CompanyId 
		                                   AND (@FoodItemId IS NULL OR Id <> @FoodItemId))

		DECLARE @FoodItemIdCount INT = (SELECT COUNT(1) FROM CanteenFoodItem WHERE Id = @FoodItemId  AND CompanyId = @CompanyId )

		IF(@FoodItemIdCount = 0 AND @FoodItemId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'CanteenFoodItem')

		END
		ELSE IF(@FoodItemNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'CanteenFoodItem')

		END
		ELSE
		BEGIN
		 
		   DECLARE @IsLatest BIT = (CASE WHEN @FoodItemId IS NULL 
						  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
						                         FROM [CanteenFoodItem] WHERE Id = @FoodItemId ) = @TimeStamp 
										   THEN 1 ELSE 0 END END)

		   IF(@IsLatest = 1)
		   BEGIN

		        DECLARE @Currentdate DATETIME = GETDATE()

				IF(@FoodItemId IS NULL)
				BEGIN

				SET @FoodItemId = NEWID()

			    INSERT INTO [dbo].[CanteenFoodItem](
				            [Id],
							[CompanyId],
							[FoodItemName],
							[Price],
							[CurrencyId],
							[ActiveFrom],
							[ActiveTo],
							[CreatedDateTime],
							[CreatedByUserId]
							)
			         SELECT @FoodItemId,
					        @CompanyId,
							@FoodItemName,
							@Price,
							@CurrencyId,
							@ActiveFrom,
							@ActiveTo,
							@Currentdate,
							@OperationsPerformedBy
							
					END
					ELSE
					BEGIN

					UPDATE [dbo].[CanteenFoodItem]
				           SET [CompanyId] = @CompanyId,
							   [FoodItemName] = @FoodItemName,
							   [Price] = @Price,
							   [CurrencyId] = @CurrencyId,
							   [ActiveFrom] = @ActiveFrom,
							   [ActiveTo] = @ActiveTo,
							   [UpdatedDateTime] = @Currentdate,
							   [UpdatedByUserId] = @OperationsPerformedBy
							WHERE Id = @FoodItemId

					END

			    SELECT  Id FROM [dbo].[CanteenFoodItem] where Id = @FoodItemId

			END
		   ELSE
		   BEGIN
			
			    RAISERROR (50008,11, 1)
			
		   END
	    END
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