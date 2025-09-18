-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Save or Update Product
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Save or Update Product
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_UpsertProduct @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ProductName = 'Mouse1', @ProductId='60486196-51D7-423A-9B98-6D0AAC4EDB69',@TimeStamp=0x0000000000002F18
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProduct]
(
   @ProductId UNIQUEIDENTIFIER = NULL,
   @ProductName NVARCHAR(250) = NULL,
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

	    IF(@ProductName = '') SET @ProductName = NULL

	    IF(@ProductName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ProductName')

		END
		ELSE
		BEGIN

        DECLARE @ProductIdCount INT = (SELECT COUNT(1) FROM Product WHERE Id = @ProductId)
              
        IF(@ProductIdCount = 0 AND @ProductId IS NOT NULL)
        BEGIN
				
				RAISERROR(50002,16, 1,'Product')

        END
        ELSE
        BEGIN
		
		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
         DECLARE @ProductNameCount INT = (SELECT COUNT(1) FROM Product WHERE ProductName = @ProductName AND CompanyId = @CompanyId AND (@ProductId IS NULL OR Id <> @ProductId))
            
         IF(@ProductNameCount > 0)
         BEGIN

			RAISERROR(50001,16,1,'Product')
           
         END
         ELSE
         BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @ProductId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [Product] WHERE Id = @ProductId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
							 IF(@ProductId IS NULL)
							 BEGIN

								SET @ProductId = NEWID()
								
								INSERT INTO [dbo].[Product](
								            [Id],
								            [CompanyId],
								            [ProductName],
								            [CreatedDateTime],
								            [CreatedByUserId],
											[InactiveDateTime]
								           )
								     SELECT @ProductId,
								            @CompanyId,
								            @ProductName,
								            @Currentdate,
								            @OperationsPerformedBy,
											CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

			                 END
							 ELSE
							 BEGIN
									
									UPDATE [dbo].[Product]
									     SET [CompanyId] = @CompanyId
										     ,ProductName = @ProductName
											 ,[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
											 ,UpdatedByUserId = @OperationsPerformedBy
											 ,UpdatedDateTime = @Currentdate
										WHERE Id = @ProductId

							 END

			                 SELECT Id FROM [dbo].[Product] WHERE Id = @ProductId
			                       
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