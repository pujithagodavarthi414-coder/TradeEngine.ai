CREATE PROCEDURE [dbo].[USP_UpsertShipmentExecutionBL]
(
	@PurchaseExecutionId UNIQUEIDENTIFIER,
	@BLNumber NVARCHAR(250) = NULL,
	@BLDate Date = NULL,
	@BLQuantity DECIMAL(18,2) = NULL,
	@ChaId UNIQUEIDENTIFIER = NULL,
	@ConsignerId UNIQUEIDENTIFIER = NULL,
	@ConsigneeId UNIQUEIDENTIFIER = NULL,
	@NotifyParty NVARCHAR(250) = NULL,
	@PackingDetails NVARCHAR(250) = NULL,
	@IsDocumentsSent BIT = NULL,
	@SentDate DATE = NULL,
	@DraftEntryDate DATE = NULL,
	@DraftBLNumber NVARCHAR(250) = NULL,
	@DraftBLDescription NVARCHAR(250) = NULL,
	@DraftBasicCustomsDuty NVARCHAR(250) = NULL,
	@DraftSWC DECIMAL(18,2) = NULL,
	@DraftIGST DECIMAL(18,2) = NULL,
	@DraftEduCess DECIMAL(18,2) = NULL,
	@DraftOthers DECIMAL(18,2) = NULL,
	@ConfoEntryDate DATE = NULL,
	@ConfoBLNumber NVARCHAR(250) = NULL,
	@ConfoBLDescription NVARCHAR(250) = NULL,
	@ConfoBasicCustomsDuty NVARCHAR(250) = NULL,
	@ConfoSWC DECIMAL(18,2) = NULL,
	@ConfoIGST DECIMAL(18,2) = NULL,
	@ConfoEduCess DECIMAL(18,2) = NULL,
	@ConfoOthers DECIMAL(18,2) = NULL,
	@IsConfirmedBill BIT = NULL,
	@ConfirmationDate DATE = NULL,
	@ConfoIsPaymentDone BIT = NULL,
	@ConfoPaymentDate DATE = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ShipmentBLId UNIQUEIDENTIFIER=NULL
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
			
			IF (@ShipmentBLId =  '00000000-0000-0000-0000-000000000000') SET @ShipmentBLId = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @PurchaseShipmentBLIdCount INT = (SELECT COUNT(1) FROM [PurchaseShipmentBLs] WHERE Id = @ShipmentBLId AND CompanyId = @CompanyId )
			
			DECLARE @PurchaseShipmentBLCount INT = (SELECT COUNT(1) FROM [PurchaseShipmentBLs] WHERE BLNumber = @BLNumber AND @PurchaseExecutionId=PurchaseExecutionId AND (@ShipmentBLId IS NULL OR Id <> @ShipmentBLId) AND CompanyId = @CompanyId ) 

			DECLARE @ExistingQuantity DECIMAL(18,2) = (SELECT SUM(BLQuantity) FROM PurchaseShipmentBLs WHERE PurchaseExecutionId=@PurchaseExecutionId AND InactiveDateTime IS NULL)+@BLQuantity
			IF(@ExistingQuantity IS NULL)
			BEGIN
					SET @ExistingQuantity=@BLQuantity
			END
			IF(@ShipmentBLId IS NOT NULL)
			BEGIN
			DECLARE @CurrentgQuantity DECIMAL(18,2) = (SELECT BLQuantity FROM [PurchaseShipmentBLs] WHERE Id=@ShipmentBLId)
			SET @ExistingQuantity = @ExistingQuantity-(CASE WHEN (@IsArchived!=1 AND (SELECT InactiveDateTime FROM PurchaseShipmentBLs WHERE Id=@ShipmentBLId) IS NOT NULL) THEN 0 ELSE @CurrentgQuantity END)
			END
			DECLARE @TotalQuantity DECIMAL(18,2) = (SELECT ShipmentQuantity FROM PurchaseShipmentExecutions WHERE Id=@PurchaseExecutionId)
			IF(@ExistingQuantity>@TotalQuantity)
			BEGIN
				RAISERROR ('BLsLimitReached',11, 1)
			END
			ELSE IF(@PurchaseShipmentBLCount > 0)
			BEGIN
				
					RAISERROR(50001,16,1,'PurchaseShipmentBL')

			END
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @ShipmentBLId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [PurchaseShipmentBLs] WHERE Id = @ShipmentBLId ) = @TimeStamp THEN 1 ELSE 0 END END )
					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@ShipmentBLId IS NULL)
					  BEGIN

					  SET @ShipmentBLId = NEWID()

						  INSERT INTO [PurchaseShipmentBLs](Id
											 ,PurchaseExecutionId
							    			 ,[CompanyId]
											 ,BLNumber
											 ,BLDate
											 ,BLQuantity
											 ,ConsignerId
											 ,ConsigneeId
											 ,NotifyParty
											 ,PackingDetails
											 ,[CreatedDateTime]
											 ,[CreatedByUserId]
											 )
							    	SELECT  @ShipmentBLId
											,@PurchaseExecutionId
											,@CompanyId
											 ,@BLNumber
											 ,@BLDate
											 ,@BLQuantity
											 ,@ConsignerId
											 ,@ConsigneeId
											 ,@NotifyParty
											 ,@PackingDetails
											 ,@CurrentDate
											 ,@OperationsPerformedBy
										   
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE [PurchaseShipmentBLs]
								  SET BLNumber						=		@BLNumber
									  ,BLDate						=		@BLDate
									  ,[BLQuantity]					=		@BLQuantity
									  ,ChaId						=		@ChaId
									  ,ConsignerId					=		@ConsignerId
									  ,ConsigneeId					=		@ConsigneeId
									  ,NotifyParty					=		@NotifyParty
									  ,PackingDetails				=		@PackingDetails
									  ,IsDocumentsSent				=		@IsDocumentsSent
									  ,SentDate						=		@SentDate
									  ,DraftEntryDate				=		@DraftEntryDate
									  ,DraftBLNumber				=		@DraftBLNumber
									  ,DraftBLDescription			=		@DraftBLDescription
									  ,DraftBasicCustomsDuty		=		@DraftBasicCustomsDuty
									  ,DraftSWC						=		@DraftSWC
									  ,DraftIGST					=		@DraftIGST
									  ,DraftEduCess					=		@DraftEduCess
									  ,DraftOthers					=		@DraftOthers
									  ,ConfoEntryDate				=		@ConfoEntryDate
									  ,ConfoBLNumber				=		@ConfoBLNumber
									  ,ConfoBLDescription			=		@ConfoBLDescription
									  ,ConfoBasicCustomsDuty		=		@ConfoBasicCustomsDuty
									  ,ConfoSWC						=		@ConfoSWC
									  ,ConfoIGST					=		@ConfoIGST
									  ,ConfoEduCess					=		@ConfoEduCess
									  ,ConfoOthers					=		@ConfoOthers
									  ,IsConfirmedBill				=		@IsConfirmedBill
									  ,ConfirmationDate				=		@ConfirmationDate
									  ,ConfoIsPaymentDone			=		@ConfoIsPaymentDone
									  ,ConfoPaymentDate				=		@ConfoPaymentDate
									  ,InActiveDateTime				=		   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
									  ,[UpdatedDateTime]			=		@CurrentDate
									  ,[UpdatedByUserId]			=		@OperationsPerformedBy
								 WHERE Id = @ShipmentBLId AND PurchaseExecutionId=@PurchaseExecutionId

											DECLARE @StatusId UNIQUEIDENTIFIER = NULL
											DECLARE @TotalCount INT = NULL
											DECLARE @TotalBLsCount INT = NULL
											DECLARE @InitialCount INT = NULL
											DECLARE @FinalCount INT = NULL
											DECLARE @DocumentsSentCount INT = NULL
											DECLARE @DraftsCount INT = NULL
											DECLARE @ConfoCount INT = NULL
											DECLARE @PaymentsCount INT = NULL

											SELECT @TotalCount=COUNT(PSB.Id),
													@InitialCount=COUNT(IIF(DD.ReferenceTypeId='1912F3AC-5BAA-4EDC-894D-10103F96AF58',1,NULL)),
													@FinalCount=COUNT(IIF(DD.ReferenceTypeId='8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02',1,NULL))
											FROM PurchaseShipmentBLs PSB
											LEFT JOIN DocumentsDescription DD ON DD.ReferenceId = PSB.Id 
											WHERE PSB.PurchaseExecutionId=@PurchaseExecutionId AND DD.InactiveDateTime IS NULL
											GROUP BY PSB.Id

											SELECT @TotalBLsCount=COUNT(PSB.Id),
													@PaymentsCount=COUNT(IIF(PSB.ConfoIsPaymentDone=1,1,NULL)),
													@DocumentsSentCount=COUNT(IIF(PSB.IsDocumentsSent=1,1,NULL)),
													@DraftsCount=COUNT(IIF(PSB.DraftBLNumber IS NOT NULL AND PSB.DraftBLNumber != '',1,NULL)),
													@ConfoCount=COUNT(IIF(PSB.ConfoBLNumber IS NOT NULL AND PSB.ConfoBLNumber != '',1,NULL))
											FROM PurchaseShipmentBLs PSB
											WHERE PSB.PurchaseExecutionId=@PurchaseExecutionId
											GROUP BY PSB.Id
											IF(@TotalBLsCount=@PaymentsCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Payment Done' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalBLsCount=@ConfoCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Final BOE' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalBLsCount=@DraftsCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Initial BOE' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalBLsCount=@DocumentsSentCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Details sent to CHA' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalCount=@FinalCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Final Doc' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalCount=@InitialCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Initial Doc' AND CompanyId = @CompanyId)
											END
											IF(@StatusId IS NOT NULL)
											BEGIN
												UPDATE [PurchaseShipmentExecutions] SET StatusId = @StatusId WHERE Id=@PurchaseExecutionId
											END

					   END

						SELECT Id FROM [PurchaseShipmentBLs] WHERE Id = @ShipmentBLId
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