CREATE PROCEDURE [dbo].[USP_UpsertGrERomande]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@SiteId UNIQUEIDENTIFIER,
	@GrdId UNIQUEIDENTIFIER,
	@BankId UNIQUEIDENTIFIER,
	@Month DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@Term NVARCHAR(20),
	@Year DATETIME,
	@Production DECIMAL(20, 4),
	@Reprise DECIMAL(20, 4),
	@AutoConsumption DECIMAL(20, 4),
	@PRATotal DECIMAL(20,4) = NULL,
	@Facturation DECIMAL(20, 4),
	@GridInvoice NVARCHAR(250),
	@GridInvoiceName NVARCHAR(250) = NULL,
	@GridInvoiceDate DATETIME,
	@IsGre BIT,
	@HauteTariff DECIMAL(20, 4) = NULL,
	@BasTariff DECIMAL(20, 4) = NULL,
	@TariffTotal DECIMAL(20, 4) = NULL,
	@Distribution DECIMAL(20, 4) = NULL,
	@GreFacturation DECIMAL(20, 4) = NULL,
	@GreTotal DECIMAL(20, 4) = NULL,
	@AdministrationRomandeE DECIMAL(20, 4) = NULL,
	@ConfirmDetailsfromGrid BIT,
	@AutoCTariff DECIMAL(20, 4),
	@AutoConsumptionSum DECIMAL(20, 4),
	@FacturationSum DECIMAL(20, 4),
	@SubTotal DECIMAL(20, 4) = NULL,
	@TVA DECIMAL(20, 4) = NULL,
	@TVAForSubTotal DECIMAL(20, 4) = NULL,
	@Total DECIMAL(20, 4) = NULL,
	@GenerateInvoice BIT,
	@InvoiceUrl NVARCHAR(2000) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OutStandingAmount DECIMAL(20, 4) = NULL,
	@PRAFields NVARCHAR(MAX) = NULL,
	@DFFields NVARCHAR(MAX) = NULL,
	@IsInvoiceBit BIT = NULL,
	@MessageType NVARCHAR(MAX) = NULL
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

			IF (@Id =  '00000000-0000-0000-0000-000000000000') SET @Id = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @GridInvoiceIdCount INT = (SELECT COUNT(1) FROM [GrERomande] WHERE Id = @Id AND CompanyId = @CompanyId)

			DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
			DECLARE @GridInvoiceCount INT = (SELECT COUNT(1) FROM [GrERomande] WHERE GridInvoice = @GridInvoice AND GridInvoiceName = @GridInvoiceName AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InactiveDateTime IS NULL)

			IF(@GridInvoiceIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'GridInvoice')
			END
          
			ELSE IF(@GridInvoiceCount > 0)
			BEGIN
				RAISERROR(50001,16,1,'GridInvoice')
			END
		 ELSE  IF(EXISTS(SELECT Id FROM [PaymentReceiptEntryForms] WHERE EntryFormId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisEntryFormIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         
         IF(@IsEligibleToArchive <> '1')
         BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
         END
			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[GrERomande] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)

				SET @IsGre = (CASE WHEN (SELECT [Name] FROM GRD WHERE Id = @GrdId) = 'GroupeE' THEN 1 ELSE 0 END)

				IF(@IsLatest = 1)
				BEGIN
					IF(@Id IS NULL)
					BEGIN
						SET @Id = (SELECT NEWID())

						INSERT INTO [dbo].[GrERomande]
													(
														[Id],
														SiteId,
														GrdId,
														BankId,
														[Month],
														StartDate,
														EndDate,
														Term,
														[Year],
														Production,
														Reprise,
														AutoConsumption,
														Facturation,
														GridInvoice,
														GridInvoiceName,
														GridInvoiceDate,
														IsGre,
														HauteTariff,
														BasTariff,
														TariffTotal,
														[Distribution],
														GreFacturation,
														GreTotal,
														AdministrationRomandeE,
														ConfirmDetailsfromGrid,
														AutoConsumptionSum,
														FacturationSum,
														SubTotal,
														TVA,
														TVAForSubTotal,
														Total,
														InvoiceUrl,
														AutoCTariff,
														GenerateInvoice,
														PRATotal,
														PRAFields,
														DFFields,
														OutStandingAmount,
														MessageType,
														CompanyId,
														CreatedByUserId,
														CreatedDateTime
														)
											SELECT @Id,
												   @SiteId,
												   @GrdId,
												   @BankId,
												   @Month,
												   @StartDate,
												   @EndDate,
												   @Term,
												   @Year,
												   @Production,
												   @Reprise,
												   @AutoConsumption,
												   @Facturation,
												   @GridInvoice,
												   @GridInvoiceName,
												   @GridInvoiceDate,
												   @IsGre,
												   CASE WHEN @IsGre = 1 THEN @HauteTariff ELSE 0 END,
												   CASE WHEN @IsGre = 1 THEN @BasTariff ELSE 0 END,
												   CASE WHEN @IsGre = 1 THEN @TariffTotal ELSE 0 END,
												   @Distribution ,
												   CASE WHEN @IsGre = 1 THEN @GreFacturation ELSE 0 END,
												   CASE WHEN @IsGre = 1 THEN @GreTotal ELSE 0 END,
												   CASE WHEN @IsGre = 1 THEN 0 ELSE @AdministrationRomandeE END,
												   @ConfirmDetailsfromGrid,
												   @AutoConsumptionSum,
												   @FacturationSum,
												   @SubTotal,
												   @TVA,
												   @TVAForSubTotal,
												   @Total,
												   @InvoiceUrl,
												   @AutoCTariff,
												   @GenerateInvoice,
												   @PRATotal,
												   @PRAFields,
												   @DFFields,
												   @OutStandingAmount,
												   @MessageType,
												   @CompanyId,
												   @OperationsPerformedBy,
												   GETDATE()

											INSERT INTO GreRomandeEHistory(
													  Id,
													  GreRomandeId,
													  FieldName,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @Id,
											          'EntryFormAdded',
													  'EntryFormAdded',
													  @OperationsPerformedBy,
													  GETDATE()
					END
					ELSE
					BEGIN

					IF(@IsInvoiceBit IS NULL)
					BEGIN
					  EXEC [USP_InsertGreRomandeEAuditHistory] @GreRomandeId = @Id,@SiteId = @SiteId,@GrdId = @GrdId,@BankId = @BankId,
										@Month = @Month,@Year = @Year,@StartDate = @StartDate,
										@EndDate = @EndDate,@Term  = @Term,@Production = @Production,
										@Reprise = @Reprise,@AutoConsumption = @AutoConsumption,
										@PRATotal = @PRATotal,@Facturation = @Facturation,@GridInvoice = @GridInvoice,@GridInvoiceDate = @GridInvoiceDate,@IsGre = @IsGre,
										@HauteTariff = @HauteTariff ,@BasTariff = @BasTariff,@OperationsPerformedBy = @OperationsPerformedBy
										,@TariffTotal = @TariffTotal, @Distribution = @Distribution,@GreFacturation = @GreFacturation,@GreTotal = @GreTotal,@AdministrationRomandeE = @AdministrationRomandeE,@ConfirmDetailsfromGrid = @ConfirmDetailsfromGrid,
										@AutoCTariff = @AutoCTariff,@AutoConsumptionSum = @AutoConsumptionSum, @FacturationSum = @FacturationSum, @SubTotal = @SubTotal,@TVA = @TVA, @TVAForSubTotal = @TVAForSubTotal,@Total = @Total,
										@GenerateInvoice = @GenerateInvoice, @InvoiceUrl = @InvoiceUrl, @PRAFields = @PRAFields, @DFFields = @DFFields,@OutStandingAmount=@OutStandingAmount, @GridInvoiceName = @GridInvoiceName

					END			

						UPDATE [dbo].[GrERomande]
							SET SiteId = @SiteId,
								GrdId = @GrdId,
								BankId = @BankId,
								[Month] = @Month,
								StartDate = @StartDate,
								EndDate = @EndDate,
								Term = @Term,
								[Year] = @Year,
								Production = @Production,
								Reprise = @Reprise,
								AutoConsumption = @AutoConsumption,
								Facturation = @Facturation,
								GridInvoice = @GridInvoice,
								GridInvoiceName = @GridInvoiceName,
								GridInvoiceDate = @GridInvoiceDate,
								IsGre = @IsGre,
								HauteTariff = CASE WHEN @IsGre = 1 THEN @HauteTariff ELSE 0 END,
								BasTariff = CASE WHEN @IsGre = 1 THEN @BasTariff ELSE 0 END,
								TariffTotal = CASE WHEN @IsGre = 1 THEN @TariffTotal ELSE 0 END,
								[Distribution] = @Distribution ,
								GreFacturation = CASE WHEN @IsGre = 1 THEN @GreFacturation ELSE 0 END,
								GreTotal = CASE WHEN @IsGre = 1 THEN @GreTotal ELSE 0 END,
								AdministrationRomandeE = CASE WHEN @IsGre = 1 THEN 0 ELSE @AdministrationRomandeE END,
								ConfirmDetailsfromGrid = @ConfirmDetailsfromGrid,
								AutoConsumptionSum = @AutoConsumptionSum,
								FacturationSum = @FacturationSum,
								SubTotal = @SubTotal,
								TVA = @TVA,
								TVAForSubTotal = @TVAForSubTotal,
								Total = @Total,
								AutoCTariff = @AutoCTariff,
								InvoiceUrl = @InvoiceUrl,
								PRATotal = @PRATotal,
								PRAFields = @PRAFields,
								DFFields = @DFFields,
								GenerateInvoice = @GenerateInvoice,
								OutStandingAmount = @OutStandingAmount,
								MessageType = @MessageType,
								UpdatedByUserId = @OperationsPerformedBy,
								UpdatedDateTime = GETDATE(),
								InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
						WHERE Id = @Id
					END

					SELECT @Id
				END
			END
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH

END