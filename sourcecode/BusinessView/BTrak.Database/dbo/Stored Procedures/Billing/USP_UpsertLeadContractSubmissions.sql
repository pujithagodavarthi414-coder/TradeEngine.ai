CREATE PROCEDURE [dbo].[USP_UpsertLeadContractSubmissions]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @SalesPersonId UNIQUEIDENTIFIER,
   @LeadDate DATETIME,
   @ContractId UNIQUEIDENTIFIER = NULL,
   @ClientId UNIQUEIDENTIFIER,
   @ProductId UNIQUEIDENTIFIER,
   @GradeId UNIQUEIDENTIFIER,
   @QuantityInMT DECIMAL(18,3),
   @RateGST DECIMAL(18,3),
   @PaymentTypeId UNIQUEIDENTIFIER,
   @VehicleNumberOfTransporter NVARCHAR(250)  = NULL,
   @MobileNumberOfTruckDriver NVARCHAR(250)  = NULL,
   @PortId UNIQUEIDENTIFIER,
   @Drums Int,
   @BLNumber NVARCHAR(250),
   @ExceptionApprovalRequired BIT = NULL,
   @StatusId UNIQUEIDENTIFIER = NULL,  
   @ShipmentMonth DATETIME,
   @CountryOriginId UNIQUEIDENTIFIER, 
   @TermsOfDelivery NVARCHAR(MAX) = NULL,
   @CustomPoint NVARCHAR(MAX)  = NULL,
   @IsArchived BIT = NULL,
   @IsClosed BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @InvoiceNumber NVARCHAR(50) = NULL,
   @DeliveryNote NVARCHAR(50) = NULL,
   @SuppliersRef NVARCHAR(50) = NULL,
   @ContractTypeId NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
			DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF (@HavePermission = '1')
			BEGIN
	
				DECLARE @RemainingMasterQuantity Int = (SELECT RemaningQuantity FROM MasterContract WHERE Id=@ContractId)
				IF(@Id IS NOT NULL)
				BEGIN
				SET @RemainingMasterQuantity=@RemainingMasterQuantity+(SELECT QuantityInMT FROM LeadContactSubmissions WHERE Id=@Id)
				END
				DECLARE @Rate Decimal(18,2) = @QuantityInMT*@RateGst
				DECLARE @Limit Decimal(18,2) = (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId)
				IF((@QuantityInMT>@RemainingMasterQuantity)OR(@Rate>@Limit) AND @IsArchived <> 1)
				BEGIN
					RAISERROR ('ClientCreditLimitExceeded',11, 1)
				END
				ELSE
				BEGIN
				DECLARE @Currentdate DATETIME = GETDATE()
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [LeadContactSubmissions] WHERE Id = @Id ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@Id IS NULL)
				  BEGIN
				  DECLARE @UniqueLeadId UNIQUEIDENTIFIER = NULL
				  DECLARE @UniqueNumber INT =(SELECT MAX(CAST(SUBSTRING([UniqueLeadId],CHARINDEX('-',[UniqueLeadId]) + 1 ,LEN([UniqueLeadId])) AS INT)) FROM [LeadContactSubmissions])
				  SET @StatusId = (SELECT Id FROM LeadStages WHERE [Name]='Lead Created' AND CompanyId=@CompanyId)
				  SET @Id = NEWID()
			        INSERT INTO [dbo].[LeadContactSubmissions](
			                    [Id],
								[SalesPersonId],
								[LeadDate],
								[ContractId],
								[ClientId],
								[UniqueLeadId],
								[ProductId],
								[GradeId],
								[QuantityInMT],
								[RateGst],
								[PaymentTypeId],
								[VehicleNumberOfTransporter],
								[MobileNumberOfTruckDriver],
								[PortId],
								[Drums],
								[BLNumber],
								[ExceptionApprovalRequired],
								[StatusId],
								[ShipmentMonth],
								[CountryOriginId],
								[TermsOfDelivery],
								[CustomPoint],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId,
								DeliveryNote,
								InvoiceNumber,
								SuppliersRef)
			             SELECT @Id,
								@SalesPersonId,
								@LeadDate,
								@ContractId,
								@ClientId,
								'LI-' + CAST(CASE WHEN @UniqueNumber IS NULL THEN 1 ELSE @UniqueNumber + 1 END AS NVARCHAR(100)),
								@ProductId,
								@GradeId,
								@QuantityInMT,
								@RateGst,
								@PaymentTypeId,
								@VehicleNumberOfTransporter,
								@MobileNumberOfTruckDriver,
								@PortId,
								@Drums,
								@BLNumber,
								@ExceptionApprovalRequired,
								@StatusId,
								@ShipmentMonth,
								@CountryOriginId,
								@TermsOfDelivery,
								@CustomPoint,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId,
								@DeliveryNote,
								@InvoiceNumber,
								@SuppliersRef

								UPDATE MasterContract SET UsedQuantity=UsedQuantity+@QuantityInMT,
															RemaningQuantity=RemaningQuantity-@QuantityInMT
															WHERE Id=@ContractId
			       
				   END
				   ELSE
				   BEGIN
				   IF(@ContractTypeId='nonContract' AND @ContractId IS NOT NULL)
				   BEGIN
											  UPDATE MasterContract SET UsedQuantity=UsedQuantity-(SELECT QuantityInMT FROM LeadContactSubmissions WHERE Id=@Id),
															RemaningQuantity=RemaningQuantity+(SELECT QuantityInMT FROM LeadContactSubmissions WHERE Id=@Id)
															WHERE Id=@ContractId
											SET @ContractId = NULL
				   END
				   IF(@ContractId IS NOT NULL)
				   BEGIN
					UPDATE MasterContract SET UsedQuantity=UsedQuantity-(SELECT QuantityInMT FROM LeadContactSubmissions WHERE Id=@Id)+@QuantityInMT,
															RemaningQuantity=RemaningQuantity+(SELECT QuantityInMT FROM LeadContactSubmissions WHERE Id=@Id)-@QuantityInMT
															WHERE Id=@ContractId
					END
					IF(EXISTS(SELECT Id FROM SCOGenerations WHERE LeadSubmissionId=@Id AND InActiveDateTime IS NULL))
					BEGIN
					UPDATE Client SET AvailableCreditLimit=(AvailableCreditLimit+(SELECT QuantityInMT*RateGST FROM LeadContactSubmissions WHERE Id=@Id))-(@QuantityInMT*@RateGST)
                                              WHERE Id=@ClientId
					END
				    UPDATE [LeadContactSubmissions]
					  SET  [SalesPersonId] 						=		   @SalesPersonId,
						   [LeadDate]							=		   @LeadDate,
						   [ContractId] 						=		   @ContractId,
						   [ClientId] 							=		   @ClientId,
						   [ProductId]							=		   @ProductId,
						   [GradeId]							=		   @GradeId,
						   [QuantityInMT]						=		   @QuantityInMT,
						   [RateGst]							=		   @RateGST,
						   [PaymentTypeId]						=		   @PaymentTypeId,
						   [VehicleNumberOfTransporter]			=		   @VehicleNumberOfTransporter,
						   [MobileNumberOfTruckDriver]			=		   @MobileNumberOfTruckDriver,
						   [PortId]								=		   @PortId,
						   [Drums]								=		   @Drums,
						   [BLNumber]							=		   @BLNumber,
						   [ExceptionApprovalRequired]			=		   @ExceptionApprovalRequired,
						   [ShipmentMonth]						=		   @ShipmentMonth,
						   [CountryOriginId]					=		   @CountryOriginId,
						   [TermsOfDelivery]					=		   @TermsOfDelivery,
						   [CustomPoint]						=		   @CustomPoint,
						   [IsClosed]							=		   @IsClosed,
					       InActiveDateTime						=		   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime						=		   @Currentdate,
						   UpdatedByUserId						=		   @OperationsPerformedBy,
						   DeliveryNote                         =          @DeliveryNote,
						   SuppliersRef                         =          @SuppliersRef,
						   InvoiceNumber                        =          @InvoiceNumber
						  WHERE Id = @Id

						                  
					END

			        SELECT Id FROM [dbo].[LeadContactSubmissions] WHERE Id = @Id

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
				END
				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO