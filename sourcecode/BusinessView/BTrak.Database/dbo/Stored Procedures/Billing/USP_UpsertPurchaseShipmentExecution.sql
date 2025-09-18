CREATE PROCEDURE [dbo].[USP_UpsertPurchaseShipmentExecution]
(
	@PurchaseShipmentId UNIQUEIDENTIFIER =NULL,
	@ContractId UNIQUEIDENTIFIER,
	@ShipmentNumber NVARCHAR(250),
	@VoyageNumber NVARCHAR(250)=NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@ShipmentQuantity DECIMAL(18,2),
	@BLQuantity DECIMAL(18,2) = NULL,
	@VesselId UNIQUEIDENTIFIER = NULL,
	@PortLoadId UNIQUEIDENTIFIER,
	@PortDischargeId  UNIQUEIDENTIFIER,
	@WorkEmployeeId  UNIQUEIDENTIFIER,
	@ETADate Date= null,
	@FillDueDate Date= null,
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
			
			IF (@PurchaseShipmentId =  '00000000-0000-0000-0000-000000000000') SET @PurchaseShipmentId = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @PurchaseShipmentIdCount INT = (SELECT COUNT(1) FROM [PurchaseShipmentExecutions] WHERE Id = @PurchaseShipmentId AND CompanyId = @CompanyId )
			
			DECLARE @PurchaseShipmentCount INT = (SELECT COUNT(1) FROM [PurchaseShipmentExecutions] WHERE ShipmentNumber = @ShipmentNumber AND (@PurchaseShipmentId IS NULL OR Id <> @PurchaseShipmentId) AND CompanyId = @CompanyId ) 

			DECLARE @RemaningQuantity DECIMAL(18,2) = (SELECT RemaningQuantity FROM PurchaseContracts WHERE Id=@ContractId)
			IF(@PurchaseShipmentId IS NOT NULL)
			BEGIN
			SET @RemaningQuantity=@RemaningQuantity+(SELECT ShipmentQuantity FROM PurchaseShipmentExecutions WHERE Id=@PurchaseShipmentId)
			END
			DECLARE @UsedQuantity DECIMAL(18,2) = (SELECT SUM(BLQuantity) FROM PurchaseShipmentBLs WHERE PurchaseExecutionId=@PurchaseShipmentId AND InactiveDateTime IS NULL)
			IF(@PurchaseShipmentId IS NOT NULL AND (@UsedQuantity>@ShipmentQuantity))
			BEGIN
			RAISERROR ('BLsQuantiesMoreThanShipmentQuantity',11, 1)
			END
            IF(@RemaningQuantity<@ShipmentQuantity)
			BEGIN
				RAISERROR ('ShipmentQuantitiesShouldBeLessThanContractQuantity',11, 1)
			END
			IF(@PurchaseShipmentCount > 0)
			BEGIN
				
					RAISERROR(50001,16,1,'PurchaseShipment')

				END
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @PurchaseShipmentId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [PurchaseShipmentExecutions] WHERE Id = @PurchaseShipmentId ) = @TimeStamp THEN 1 ELSE 0 END END )
					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@PurchaseShipmentId IS NULL)
					  BEGIN

					  SET @PurchaseShipmentId = NEWID()

						  INSERT INTO [PurchaseShipmentExecutions](Id
							    			 ,[CompanyId]
											 ,[ContractId]
											 ,[ShipmentNumber]
											 ,[ShipmentQuantity]
											 ,VesselId
											 ,PortLoadId
											 ,[PortDischargeId]
											 ,[WorkEmployeeId]
											 ,[ETADate]
											 ,[VoyageNumber]
											 ,[FillDueDate]
											 ,StatusId
											 ,[CreatedDateTime]
											 ,[CreatedByUserId]
											 )
							    	SELECT  @PurchaseShipmentId,
											@CompanyId,
											@ContractId,
											@ShipmentNumber,
							    			@ShipmentQuantity,
											@VesselId,
											@PortLoadId,
											@PortDischargeId,
											@WorkEmployeeId,
											@ETADate,
											@VoyageNumber,
											@FillDueDate,
											(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Purchase Execution Created' AND CompanyId = @CompanyId),
							    			@CurrentDate,
							    			@OperationsPerformedBy
										   
		              
						UPDATE PurchaseContracts SET UsedQuantity=UsedQuantity+@ShipmentQuantity,
															RemaningQuantity=RemaningQuantity-@ShipmentQuantity
															WHERE Id=@ContractId
					   END
					   ELSE
					   BEGIN
					   
						UPDATE PurchaseContracts SET UsedQuantity=UsedQuantity-(SELECT ShipmentQuantity FROM [PurchaseShipmentExecutions] WHERE Id=@PurchaseShipmentId)+@ShipmentQuantity,
															RemaningQuantity=RemaningQuantity+(SELECT ShipmentQuantity FROM [PurchaseShipmentExecutions] WHERE Id=@PurchaseShipmentId)-@ShipmentQuantity
															WHERE Id=@ContractId
					   UPDATE [PurchaseShipmentExecutions]
								  SET [ContractId]					=		@ContractId,
									  [ShipmentNumber]				=		@ShipmentNumber,
									  [ShipmentQuantity]			=		@ShipmentQuantity,
									  VesselId						=		@VesselId,
									  VoyageNumber					=		@VoyageNumber,
									  PortLoadId					=		@PortLoadId,
									  [PortDischargeId]				=		@PortDischargeId,
									  [WorkEmployeeId]				=		@WorkEmployeeId,
									  [ETADate]						=		@ETADate,
									  [FillDueDate]					=		@FillDueDate,
									  InActiveDateTime						=		   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  [UpdatedDateTime]				=		@CurrentDate,
									  [UpdatedByUserId]				=		@OperationsPerformedBy
								 WHERE Id = @PurchaseShipmentId

					   END

						SELECT Id FROM [PurchaseShipmentExecutions] WHERE Id = @PurchaseShipmentId
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