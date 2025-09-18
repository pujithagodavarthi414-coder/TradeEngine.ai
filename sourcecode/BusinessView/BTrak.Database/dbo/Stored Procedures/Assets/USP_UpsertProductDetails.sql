-------------------------------------------------------------------------------
-- Purpose      To Save or Update ProductDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC USP_UpsertProductDetails @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--                               @ProductId = '642A251B-6E47-487C-8571-C77CEF02AA10',
--								 @ProductCode = 'DELL',
--								 @SupplierId = 'E79E824C-1063-4A5A-B9D6-3DACEFBD8CC6',
--								 @ManufacturerCode = '903',
--								 @ProductDetailsId='9BACCFC1-8C7B-4559-BAC8-97F2DFDED682'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProductDetails]
(
   @ProductDetailsId UNIQUEIDENTIFIER = NULL,
   @ProductId UNIQUEIDENTIFIER = NULL,
   @ProductCode NVARCHAR(250) = NULL,
   @SupplierId UNIQUEIDENTIFIER = NULL,
   @ManufacturerCode NVARCHAR(100) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	  
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@ProductId = '00000000-0000-0000-0000-000000000000') SET @ProductId = NULL

		IF(@SupplierId = '00000000-0000-0000-0000-000000000000') SET @SupplierId = NULL

	    IF(@ProductId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Product')

		END
		ELSE IF(@SupplierId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Supplier')

		END
		ELSE
		BEGIN

	         DECLARE @ProductDetailsIdCount INT = (SELECT COUNT(1) FROM ProductDetails WHERE Id = @ProductDetailsId)

			 DECLARE @ProductDetailsIdCountInAssets INT  = (SELECT COUNT(1) FROM Asset WHERE ProductDetailsId = @ProductDetailsId AND InactiveDateTime IS NULL)
              
             IF(@ProductDetailsIdCount = 0 AND @ProductDetailsId IS NOT NULL)
             BEGIN

                 RAISERROR(50002,16, 2,'ProductDetails')

             END
             ELSE IF(@IsArchived = 1 AND @ProductDetailsIdCountInAssets>0)
			 BEGIN
			 
				RAISERROR('ThisProductIsLinkedToAssetsPleaseChangeTheProductAndTryToDeleteThisProduct',11,1)
			 
			 END
			 ELSE
		     BEGIN
                   
		         DECLARE @ProductDuplicateCount INT = (SELECT COUNT(1) FROM ProductDetails WHERE ProductCode = @ProductCode AND  ManufacturerCode = @ManufacturerCode AND  SupplierId = @SupplierId AND ProductId = @ProductId  AND (@ProductDetailsId IS NULL OR Id<>@ProductDetailsId ) AND InactiveDateTime IS NULL)
         
				 IF(@ProductDuplicateCount > 0)
				 BEGIN
				 
				  RAISERROR('ProductWithSameProductCodeAndManufactureCodeAlreadyExists',11,1)
				   
				 END
				 ELSE
                 BEGIN
		        
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @ProductDetailsId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [ProductDetails] WHERE Id = @ProductDetailsId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			         	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
							 IF(@ProductDetailsId IS NULL)
							 BEGIN

								SET @ProductDetailsId = NEWID()
								
								INSERT INTO [dbo].[ProductDetails](
								            [Id],
											[ProductId],
											[ProductCode],
											[SupplierId],
											[ManufacturerCode],
											[CreatedDateTime],
											[CreatedByUserId],
											[InactiveDateTime]
											 )
								     SELECT @ProductDetailsId,
			         			          	@ProductId,
			         			          	@ProductCode,
			         			          	@SupplierId,
			         			          	@ManufacturerCode,
			         			          	@Currentdate,
			         			          	@OperationsPerformedBy,
											CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

			                 END
							 ELSE
							 BEGIN
									
									UPDATE [dbo].[ProductDetails]
									     SET [ProductId] = @ProductId
										     ,[ProductCode] = @ProductCode
											 ,[SupplierId] = @SupplierId
											 ,[ManufacturerCode] = @ManufacturerCode
											 ,[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
											 ,[UpdatedByUserId] = @OperationsPerformedBy
											 ,[UpdatedDateTime] = @Currentdate
										WHERE Id = @ProductDetailsId

							 END

			                 SELECT Id FROM [dbo].[ProductDetails] WHERE Id = @ProductDetailsId
			                       
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
        END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO