-------------------------------------------------------------------------------
-- Modified By   Mahesh Musuku
-- Created      '2019-05-02 00:00:00.000'
-- Purpose      To Save or Update Suppliers
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_UpsertSuppliers @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--                         @SupplierName = 'E Technologies',
--                         @SupplierCompanyName  = 'HP',
--                         @ContactPerson  = 'David',
--                         @ContactPosition  = 'Sales Manager',
--                         @CompanyPhoneNumber  = '1230456789',
--                         @ContactPhoneNumber  = '1230456789',
--                         @VendorIntroducedBy  = 'Smith',
--                         @StartedWorkingFrom  = '2018-03-07 00:00:00.000',
--                         @IsArchived  = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertSuppliers]
(
   @SupplierId UNIQUEIDENTIFIER = NULL,
   @SupplierName NVARCHAR(250) = NULL,
   @SupplierCompanyName NVARCHAR(250) = NULL,
   @ContactPerson NVARCHAR(250) = NULL,
   @ContactPosition NVARCHAR(250) = NULL,
   @CompanyPhoneNumber NVARCHAR(250) = NULL,
   @ContactPhoneNumber NVARCHAR(250) = NULL,
   @VendorIntroducedBy NVARCHAR(250) = NULL,
   @StartedWorkingFrom DATETIME = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		    
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@SupplierName = '') SET @SupplierName = NULL

	    IF(@SupplierName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'VendorName')

		END
		ELSE IF(@StartedWorkingFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'StartedWorkingFrom')

		END
		ELSE
		BEGIN
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @SupplierIdCount INT = (SELECT COUNT(1) FROM Supplier WHERE Id = @SupplierId AND CompanyId = @CompanyId)

		DECLARE @SupplierNameCount INT = (SELECT COUNT(1) FROM Supplier WHERE SupplierName = @SupplierName AND (@SupplierId IS NULL OR Id <> @SupplierId) AND CompanyId = @CompanyId)

		DECLARE @SupplierIdCountInProductDetails INT  = (SELECT COUNT(1) FROM ProductDetails WHERE SupplierId = @SupplierId AND InactiveDateTime IS NULL)
              
        IF(@SupplierIdCount = 0 AND @SupplierId IS NOT NULL)
        BEGIN
            
			RAISERROR(50002,16, 1,'Vendor')

        END
        ELSE  IF(@IsArchived = 1 AND @SupplierIdCountInProductDetails>0)
        BEGIN
            
			RAISERROR('ThisVendorIsLinkedToProductDetailsPleaseChangeTheVendor',11,1)

        END
        ELSE IF(@SupplierNameCount > 0)
        BEGIN

		  RAISERROR(50001,16,1,'Vendor')
           
        END
        ELSE
		BEGIN
		
		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @SupplierId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [Supplier] WHERE Id = @SupplierId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

			        DECLARE @Currentdate DATETIME = GETDATE()
			        
					IF(@SupplierId IS NULL)
					BEGIN

						SET @SupplierId = NEWID()

						INSERT INTO [dbo].[Supplier](
						            [Id],
							        [CompanyId],
							        [SupplierName],
							        [CompanyName],
							        [ContactPerson],
							        [ContactPosition],
							        [CompanyPhoneNumber],
							        [ContactPhoneNumber],
							        [VendorIntroducedBy],
							        [StartedWorkingFrom],
							        [CreatedDateTime],
							        [CreatedByUserId],
							        [InactiveDateTime])
						     SELECT @SupplierId,
							        @CompanyId,
							        @SupplierName,
							        @SupplierCompanyName,
							        @ContactPerson,
							        @ContactPosition,
							        @CompanyPhoneNumber,
							        @ContactPhoneNumber,
							        @VendorIntroducedBy,
							        @StartedWorkingFrom,
							        @Currentdate,
							        @OperationsPerformedBy,
							        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

			        END
					ELSE
					BEGIN
						
						UPDATE [dbo].[Supplier]
						      SET [CompanyId] = @CompanyId
							      ,[SupplierName] = @SupplierName
								  ,[CompanyName] = @SupplierCompanyName
								  ,[ContactPerson] = @ContactPerson
								  ,[ContactPosition] = @ContactPosition
								  ,[CompanyPhoneNumber] = @CompanyPhoneNumber
								  ,[ContactPhoneNumber] = @ContactPhoneNumber
								  ,[VendorIntroducedBy] = @VendorIntroducedBy
								  ,[StartedWorkingFrom] = @StartedWorkingFrom
								  ,UpdatedByUserId = @OperationsPerformedBy
								  ,[UpdatedDateTime] = @Currentdate
								  ,[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @SupplierId

					END

			        SELECT Id FROM [dbo].[Supplier] WHERE Id = @SupplierId
			              
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