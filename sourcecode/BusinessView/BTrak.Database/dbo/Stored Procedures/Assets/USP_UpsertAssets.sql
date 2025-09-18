-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Save or Update Assets
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Save or Update Assets
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------
--EXEC USP_UpsertAssets @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--					    @AssetNumber = A255,
--                      @PurchasedDate  = '2019-03-07 00:00:00.000',
--                      @ProductDetailsId  = '3E225E79-67EC-4B3D-AE19-2A9EA1DEC83F',
--                      @AssetName = 'KeyBoard',
--                      @Cost = 500,
--                      @CurrencyId  = 'DF549957-74CC-4622-A094-05F64973F092',
--                      @IsWriteOff  = 0,
--                      @DamagedDate  = NULL,
--                      @DamagedReason = NULL,
--                      @IsEmpty  = 1,
--                      @IsVendor  = 0,
--                      @AssignedToEmployeeId  = '127133F1-4427-4149-9DD6-B02E0E036971',
--                      @AssignedDateFrom  = '2019-03-08 10:01:21.717',
--                      @AssignedDateTo  = NULL,
--                      @ApprovedByUserId  = '127133F1-4427-4149-9DD6-B02E0E036971' 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertAssets]
(
   @AssetId UNIQUEIDENTIFIER = NULL,
   @AssetNumber NVARCHAR(50) = NULL,
   @PurchasedDate DATETIME = NULL,
   @ProductDetailsId UNIQUEIDENTIFIER = NULL,
   @AssetName NVARCHAR(50) = NULL,
   @AssetUniqueNumber NVARCHAR(12) = NULL,
   @AssetUniqueNumberId UNIQUEIDENTIFIER = NULL ,
   @Cost DECIMAL(18,0) = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @IsWriteOff BIT = NULL,
   @DamagedDate DATETIME = NULL,
   @DamagedReason NVARCHAR(800) = NULL,
   @IsEmpty BIT = NULL,
   @IsVendor BIT = NULL,
   @AssignedToEmployeeId UNIQUEIDENTIFIER = NULL,
   @AssignedDateFrom DATETIME = NULL,
   @AssignedDateTo DATETIME = NULL,
   @ApprovedByUserId UNIQUEIDENTIFIER = NULL,
   @DamagedByUserId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SeatingId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL

		IF(@AssetUniqueNumberId IS NULL) SET @AssetUniqueNumberId = '00000000-0000-0000-0000-000000000000'

	    IF(@AssetNumber = '') SET @AssetNumber = NULL

		IF(@AssetName = '') SET @AssetName = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	    IF(@AssetNumber IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'AssetNumber')

		END
		ELSE IF(@PurchasedDate IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PurchasedDate')

		END
		ELSE IF(@AssetName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'AssetName')

		END
	    ELSE IF(@CurrencyId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Currency')

		END
		ELSE IF(@IsEmpty IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'IsEmpty')

		END
		ELSE IF(@IsVendor IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'IsVendor')

		END
		ELSE IF(@BranchId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'IsBranch')

		END
		ELSE 
		BEGIN
		DECLARE @AssetIdCount INT = (SELECT COUNT(1) FROM Asset WHERE Id = @AssetId)
         
		DECLARE @AssetNumberCount INT = (SELECT COUNT(1) FROM Asset A
		                                                 JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL
														 JOIN Product P ON P.Id = PD.ProductId AND P.InactiveDateTime IS NULL AND P.CompanyId = @CompanyId
														 WHERE AssetNumber = @AssetNumber AND (@AssetId IS NULL OR A.Id <> @AssetId))    
		
		DECLARE @MACAddressCount INT = (SELECT COUNT(1) FROM UserMAC WHERE MACAddress = @AssetUniqueNumber AND InActiveDateTime IS NULL AND @AssetUniqueNumber IS NOT NULL AND @AssetUniqueNumber !='')

		DECLARE @MACId UNIQUEIDENTIFIER = (SELECT Id FROM UserMAC WHERE MACAddress = @AssetUniqueNumber AND InActiveDateTime IS NULL AND @AssetUniqueNumber IS NOT NULL AND @AssetUniqueNumber !='')

        IF(@AssetIdCount = 0 AND @AssetId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 1,'Asset')
        END
        ELSE IF(@AssetNumberCount > 0)
		BEGIN
          
		RAISERROR(50001,16,1,'Asset')
           
        END
		ELSE IF(@MACAddressCount > 0 AND @MACId != @AssetUniqueNumberId)
		BEGIN

			RAISERROR(50001,16, 2, 'MACAddress')

		END
         ELSE
         BEGIN
        	   
		       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			   IF (@HavePermission = '1')
			   BEGIN
			   	
			   	DECLARE @IsLatest BIT = (CASE WHEN @AssetId IS NULL 
			   	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                         FROM [Asset] WHERE Id = @AssetId) = @TimeStamp
			   													THEN 1 ELSE 0 END END)
			         
			     IF(@IsLatest = 1)
			     BEGIN
			         
					DECLARE @Currentdate DATETIME = GETDATE()

					IF(@AssetId IS NULL)
					BEGIN
						
						SET @AssetId = NEWID()

						DECLARE @MACAddressId UNIQUEIDENTIFIER = NEWID()

						INSERT INTO [dbo].[Asset](
						            [Id],
									[AssetNumber],
									[PurchasedDate],
									[ProductDetailsId],
									[AssetName],
									[Cost],
									[CurrencyId],
									[IsWriteOff],
									[DamagedDate],
									[DamagedReason],
									[IsEmpty],
									[IsVendor],
									[DamagedByUserId],
									[SeatingId],
									[BranchId],
									[CreatedDateTime],
									[CreatedByUserId],
									[InactiveDateTime]
									 )
						     SELECT @AssetId,
									@AssetNumber, 
									@PurchasedDate,
									@ProductDetailsId,
									@AssetName,
									@Cost,
									@CurrencyId,
									@IsWriteOff,
									@DamagedDate,
									@DamagedReason,
									@IsEmpty,
									@IsVendor,
									@DamagedByUserId,
									@SeatingId,
									@BranchId,
									@Currentdate,
									@OperationsPerformedBy,
									CASE WHEN @IsWriteOff = 1 THEN @Currentdate ELSE NULL END

						INSERT INTO [dbo].[AssetAssignedToEmployee](
									[Id],
									[AssetId],
									[AssignedToEmployeeId],
									[AssignedDateFrom],
									[AssignedDateTo],
									[ApprovedByUserId],
									[CreatedDateTime],
									[CreatedByUserId]
									)
							SELECT NEWID(),
								   @AssetId,
								   @AssignedToEmployeeId,
								   @AssignedDateFrom,
								   @AssignedDateTo,
								   @ApprovedByUserId,
								   @Currentdate,
								   @OperationsPerformedBy

						    INSERT INTO [dbo].[VendorDetails](
						    					[Id],
						    					[AssetId],
						    					[ProductId],
						    					[Cost],
												[CreatedByUserId],
												[CreatedDateTime]
						    					)
						    	  SELECT NEWID(), 
						    	  		@AssetId,
						    	  		(SELECT ProductId FROM ProductDetails WHERE Id = @ProductDetailsId),
						    	  		@Cost,
								  		@OperationsPerformedBy,
								  		@Currentdate

							IF (@AssetUniqueNumber <> '' AND ( LOWER(@AssetName) LIKE 'cpu' OR LOWER(@AssetName) LIKE 'laptop' ))
							BEGIN
							 
								 INSERT INTO [dbo].[UserMAC](
													[Id],
													[MACAddress],
													[UserId],
													[AssetId],
													[CompanyId],
													[DateFrom],
													[CreatedByUserId],
													[CreatedDateTime]
													)
							 			 SELECT @MACAddressId,
												@AssetUniqueNumber,
												@AssignedToEmployeeId,
												@AssetId,
												@CompanyId,
												@AssignedDateFrom,
												@OperationsPerformedBy,
												@Currentdate
							END
					END
					ELSE
					BEGIN

						UPDATE [dbo].[Asset]
						    SET [AssetNumber] = @AssetNumber
								,[PurchasedDate] = @PurchasedDate
								,[ProductDetailsId] = @ProductDetailsId
								,[AssetName] = @AssetName
								,[Cost] = @Cost
								,[CurrencyId] = @CurrencyId
								,[IsWriteOff] = @IsWriteOff
								,[DamagedDate] = @DamagedDate
								,[DamagedReason] = @DamagedReason
								,[IsEmpty] = @IsEmpty
								,[IsVendor] = @IsVendor
								,[DamagedByUserId] = @DamagedByUserId
								,[SeatingId] = @SeatingId
								,[BranchId] = @BranchId
								,[UpdatedDateTime] = @Currentdate
								,[UpdatedByUserId] = @OperationsPerformedBy
								,[InactiveDateTime] = CASE WHEN @IsWriteOff = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @AssetId

						UPDATE [dbo].[AssetAssignedToEmployee]
						    SET [AssignedToEmployeeId] = @AssignedToEmployeeId
								,[AssignedDateFrom] = @AssignedDateFrom
								,[AssignedDateTo] = @AssignedDateTo
								,[ApprovedByUserId] = @ApprovedByUserId
								,[UpdatedDateTime] = @Currentdate
								,[UpdatedByUserId] = @OperationsPerformedBy
							WHERE AssetId = @AssetId

					    UPDATE [dbo].[VendorDetails]
						       SET [ProductId] = (SELECT ProductId FROM ProductDetails WHERE Id = @ProductDetailsId)
							       ,[Cost] = @Cost
								   ,UpdatedByUserId = @OperationsPerformedBy
								   ,UpdatedDateTime = @Currentdate
							WHERE AssetId = @AssetId
						
						IF (@AssetUniqueNumberId IS NOT NULL AND ( LOWER(@AssetName) NOT LIKE 'cpu' AND LOWER(@AssetName) NOT LIKE 'laptop' ))
						BEGIN
						
							UPDATE [dbo].[UserMAC] 
									SET InActiveDateTime = @CurrentDate 
										,[MACAddress] = ''
									    ,[UpdatedDateTime] = @Currentdate
										,[CompanyId] = @CompanyId
										,[UpdatedByUserId] = @OperationsPerformedBy
								    WHERE AssetId = @AssetId 
						
						END

						ELSE
						BEGIN

							IF((@AssetUniqueNumberId IS NULL OR @AssetUniqueNumberId = '00000000-0000-0000-0000-000000000000') AND @AssetUniqueNumber IS NOT NULL)
							BEGIN
								INSERT INTO [dbo].[UserMAC](
													[Id],
													[MACAddress],
													[UserId],
													[AssetId],
													[CompanyId],
													[DateFrom],
													[CreatedByUserId],
													[CreatedDateTime]
													)
							 			 SELECT NEWID(),
												@AssetUniqueNumber,
												@AssignedToEmployeeId,
												@AssetId,
												@CompanyId,
												@AssignedDateFrom,
												@OperationsPerformedBy,
												@Currentdate

							END
							ELSE
							BEGIN

								UPDATE [dbo].[UserMAC]
									 SET [MACAddress] = @AssetUniqueNumber
										 ,[UserId] = @AssignedToEmployeeId
										 ,[AssetId] = @AssetId
										 ,[CompanyId] = @CompanyId
										 ,[UpdatedDateTime] = @Currentdate
										 ,[UpdatedByUserId] = @OperationsPerformedBy
										 ,InActiveDateTime = NULL
										 WHERE AssetId = @AssetId AND Id = @AssetUniqueNumberId
							END
						END
					END
						  SELECT Id FROM [dbo].[Asset] where Id = @AssetId
		               
				 END
				 ELSE	
				 BEGIN
					RAISERROR (50008,11, 1)
			     END
				 
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
