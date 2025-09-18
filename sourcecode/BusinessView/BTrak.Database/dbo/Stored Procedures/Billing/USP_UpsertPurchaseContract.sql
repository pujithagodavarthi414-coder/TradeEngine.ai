CREATE PROCEDURE [dbo].[USP_UpsertPurchaseContract]
(
	@ContractId UNIQUEIDENTIFIER =NULL,
	@ClientId UNIQUEIDENTIFIER,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@Price  DECIMAL(18,2),
	@GradeId UNIQUEIDENTIFIER,
	@ProductId UNIQUEIDENTIFIER,
	@TotalQuantity int,
	@RemaningQuantity  int = null,
	@UsedQuantity  int = null,
	@ContractDocument NVARCHAR(150)= null,
	@StartDate Date,
	@EndDate Date,
	@ContractNumber NVARCHAR(200),
	@Description NVARCHAR(250) = null,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@ContractId =  '00000000-0000-0000-0000-000000000000') SET @ContractId = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ContractIdCount INT = (SELECT COUNT(1) FROM [PurchaseContracts] WHERE Id = @ContractId AND CompanyId = @CompanyId )
			
			DECLARE @ContractNumberCount INT = (SELECT COUNT(1) FROM [PurchaseContracts] WHERE ContractNumber = @ContractNumber AND (@ContractId IS NULL OR Id <> @ContractId) AND CompanyId = @CompanyId ) 

		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	     IF(EXISTS(SELECT Id FROM [PurchaseShipmentExecutions] WHERE ContractId = @ContractId) AND @IsArchived=1)
	     BEGIN
	     
	     SET @IsEligibleToArchive = 'ThisContractUsedInPurchaseExecutionPleaseDeleteTheDependenciesAndTryAgain'
	     RAISERROR (@isEligibleToArchive,11, 1)
	     END
			IF(@ContractNumberCount > 0 AND @IsArchived=1)
			BEGIN
				
					RAISERROR(50001,16,1,'Contract')

				END
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @ContractId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [PurchaseContracts] WHERE Id = @ContractId ) = @TimeStamp THEN 1 ELSE 0 END END )
					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@ContractId IS NULL)
					  BEGIN

					  SET @ContractId = NEWID()

						  INSERT INTO [PurchaseContracts](Id
							    			 ,[CompanyId]
											 ,[ClientId]
											 ,[UniqueName]
											 ,[ProductId]
											 ,[GradeId]
											 ,[Price]
											 ,[TotalQuantity]
											 ,[UsedQuantity]
											 ,[RemaningQuantity]
											 ,[CreatedDateTime]
											 ,[CreatedByUserId]
											 ,[ContractDocument]
											 ,[StartDate]
											 ,[EndDate]
											 ,[ContractNumber]
											 ,[Description]
											 )
							    	SELECT  @ContractId,
											@CompanyId,
											@ClientId,
											@TotalQuantity,
							    			@ProductId,
											@GradeId,
											@Price,
											@TotalQuantity,
											0,
											@TotalQuantity,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
											@ContractDocument,
											@StartDate,
											@EndDate,
											@ContractNumber,
											@Description
										   
		              
					   END
					   ELSE
					   BEGIN
					   DECLARE @UsedQuantityExist Decimal(18,2) = (SELECT SUM(ShipmentQuantity) FROM PurchaseShipmentExecutions WHERE ContractId=@ContractId)
					   IF(@UsedQuantityExist>@TotalQuantity)
					   BEGIN
							RAISERROR ('ShipmentQuantiesMoreThanContractQuantity',11, 1)
					   END
					   ELSE
					   BEGIN
					   UPDATE [PurchaseContracts]
								  SET [ClientId]			 = @ClientId,
								  [TotalQuantity]	 = @TotalQuantity,
								  [ProductId]			 = @ProductId,
								  [GradeId]				 = @GradeId,
								  [Price]			 = @Price,
								  [RemaningQuantity]	 = @TotalQuantity-(CASE WHEN @UsedQuantityExist IS NULL THEN 0 ELSE @UsedQuantityExist END),
								  [ContractDocument]	 = @ContractDocument,
								  [StartDate]	 = @StartDate,
								  [EndDate]		 = @EndDate,
								  [ContractNumber] = @ContractNumber,
									InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									UpdatedDateTime = @CurrentDate,
							       UpdatedByUserId = @OperationsPerformedBy,
								   [Description]=@Description
								 WHERE Id = @ContractId
						END
					   END

						SELECT Id FROM [PurchaseContracts] WHERE Id = @ContractId
					END
					ELSE
					  
						RAISERROR(50008,11,1)

				END
		
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO