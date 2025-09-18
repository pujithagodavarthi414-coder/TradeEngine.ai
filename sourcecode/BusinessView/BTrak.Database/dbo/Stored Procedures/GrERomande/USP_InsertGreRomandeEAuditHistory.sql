CREATE PROCEDURE [dbo].[USP_InsertGreRomandeEAuditHistory]
	@GreRomandeId UNIQUEIDENTIFIER = NULL,
	@SiteId UNIQUEIDENTIFIER = NULL,
	@GrdId UNIQUEIDENTIFIER = NULL,
	@BankId UNIQUEIDENTIFIER = NULL,
	@Month DATETIME = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@Term NVARCHAR(20) = NULL,
	@Year DATETIME = NULL,
	@Production DECIMAL(20, 4)= NULL,
	@Reprise DECIMAL(20, 4)= NULL,
	@AutoConsumption DECIMAL(20, 4)= NULL,
	@PRATotal DECIMAL(20,4) = NULL,
	@Facturation DECIMAL(20, 4) = NULL,
	@GridInvoice NVARCHAR(250) = NULL,
	@GridInvoiceDate DATETIME = NULL,
	@IsGre BIT = NULL,
	@HauteTariff DECIMAL(20, 4) = NULL,
	@BasTariff DECIMAL(20, 4) = NULL,
	@TariffTotal DECIMAL(20, 4) = NULL,
	@Distribution DECIMAL(20, 4) = NULL,
	@GreFacturation DECIMAL(20, 4) = NULL,
	@GreTotal DECIMAL(20, 4) = NULL,
	@AdministrationRomandeE DECIMAL(20, 4) = NULL,
	@ConfirmDetailsfromGrid BIT = NULL,
	@AutoCTariff DECIMAL(20, 4) = NULL,
	@AutoConsumptionSum DECIMAL(20, 4) = NULL,
	@FacturationSum DECIMAL(20, 4) = NULL,
	@SubTotal DECIMAL(20, 4) = NULL,
	@TVA DECIMAL(20, 4) = NULL,
	@TVAForSubTotal DECIMAL(20, 4) = NULL,
	@Total DECIMAL(20, 4) = NULL,
	@GenerateInvoice BIT = NULL,
	@InvoiceUrl NVARCHAR(2000) = NULL,
	@PRAFields NVARCHAR(MAX) = NULL,
	@DFFields NVARCHAR(MAX) = NULL,
	@OutStandingAmount DECIMAL(20,4) = NULL,
	@GridInvoiceName NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
       
	   DECLARE @OldSiteId UNIQUEIDENTIFIER = NULL
	   DECLARE @OldGrdId UNIQUEIDENTIFIER = NULL
	   DECLARE @OldBankId UNIQUEIDENTIFIER = NULL
	   DECLARE @OldMonth DATETIME = NULL
	   DECLARE @OldStartDate DATETIME = NULL
	   DECLARE @OldEndDate DATETIME = NULL
	   DECLARE @OldTerm NVARCHAR(20) = NULL
	   DECLARE @OldYear DATETIME = NULL
	   DECLARE @OldProduction DECIMAL(20, 4)= NULL
	   DECLARE @OldReprise DECIMAL(20, 4)= NULL
	   DECLARE @OldAutoConsumption DECIMAL(20, 4)= NULL
	   DECLARE @OldPRATotal DECIMAL(20,4) = NULL
	   DECLARE @OldFacturation DECIMAL(20, 4) = NULL
	   DECLARE @OldGridInvoice NVARCHAR(250) = NULL
	   DECLARE @OldGridInvoiceDate DATETIME = NULL
	   DECLARE @OldIsGre BIT = NULL
	   DECLARE @OldHauteTariff DECIMAL(20, 4) = NULL
	   DECLARE @OldBasTariff DECIMAL(20, 4) = NULL
	   DECLARE @OldTariffTotal DECIMAL(20, 4) = NULL
	   DECLARE @OldDistribution DECIMAL(20, 4) = NULL
	   DECLARE @OldGreFacturation DECIMAL(20, 4) = NULL
	   DECLARE @OldGreTotal DECIMAL(20, 4) = NULL
	   DECLARE @OldAdministrationRomandeE DECIMAL(20, 4) = NULL
	   DECLARE @OldConfirmDetailsfromGrid BIT = NULL
	   DECLARE @OldAutoCTariff DECIMAL(20, 4) = NULL
	   DECLARE @OldAutoConsumptionSum DECIMAL(20, 4) = NULL
	   DECLARE @OldFacturationSum DECIMAL(20, 4) = NULL
	   DECLARE @OldSubTotal DECIMAL(20, 4) = NULL
	   DECLARE @OldTVA DECIMAL(20, 4) = NULL
	   DECLARE @OldTVAForSubTotal DECIMAL(20, 4) = NULL
	   DECLARE @OldTotal DECIMAL(20, 4) = NULL
	   DECLARE @OldGenerateInvoice BIT = NULL
	   DECLARE @OldInvoiceUrl NVARCHAR(2000) = NULL
	   DECLARE @OldPRAFields NVARCHAR(MAX) = NULL
	   DECLARE @OldDFFields NVARCHAR(MAX) = NULL 
	   DECLARE @OldOutStandingAmount DECIMAL(20,4) = NULL
	   DECLARE @OldGridInvoiceName NVARCHAR(250) = NULL

	   SELECT @OldSiteId = SiteId, @OldGrdId = GrdId, @OldBankId = BankId, @OldMonth = [Month], @OldYear = [Year],
	   @OldStartDate = StartDate, @OldEndDate = EndDate, @Term = Term,@OldProduction = Production, @OldReprise = Reprise,
	   @OldAutoConsumption = AutoConsumption,@OldPRATotal = PRATotal, @OldGridInvoice = GridInvoice,@OldGridInvoiceDate = GridInvoiceDate,
	   @OldIsGre = IsGre, @OldHauteTariff = HauteTariff, @OldBasTariff = BasTariff, @OldTariffTotal = TariffTotal, @OldDistribution = [Distribution],
	   @OldGreTotal = GreTotal, @OldConfirmDetailsfromGrid = ConfirmDetailsfromGrid, @OldAutoCTariff = AutoCTariff, @OldAutoConsumptionSum = AutoConsumptionSum,
	   @OldFacturationSum = FacturationSum, @OldSubTotal = SubTotal, @OldTVA = TVA, @OldTVAForSubTotal = TVAForSubTotal, @OldTotal = Total,@OldGenerateInvoice = GenerateInvoice,
	   @OldInvoiceUrl = InvoiceUrl, @OldPRAFields = PRAFields, @OldDFFields = DFFields, @OldOutStandingAmount = OutStandingAmount, @OldGridInvoiceName = GridInvoiceName
	    FROM [dbo].[GrERomande] WHERE Id = @GreRomandeId

		DECLARE @OldJson NVARCHAR(MAX)

		DECLARE @Currentdate DATETIME = GETDATE()

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	  
         DECLARE @OldValue NVARCHAR(MAX)

      DECLARE @NewValue NVARCHAR(MAX)

      DECLARE @FieldName NVARCHAR(200)

      DECLARE @HistoryDescription NVARCHAR(800)

	  SET @OldJson = (SELECT * FROM [dbo].[GrERomande] WHERE Id = @GreRomandeId FOR JSON AUTO)

	  IF(@OldSiteId <> @SiteId OR @OldGrdId <> @GrdId OR @OldBankId <> @BankId OR @OldMonth <> @Month OR @OldYear <> @Year OR @OldStartDate <> @StartDate OR @OldEndDate <> @EndDate
	  OR @OldTerm <> @Term OR @OldProduction <> @Production OR @OldReprise <> @Reprise OR @OldAutoConsumption <> @AutoConsumption OR @OldPRATotal <> @PRATotal OR @OldGridInvoice <> @GridInvoice
	  OR @OldGridInvoiceDate <> @GridInvoiceDate OR @IsGre <> @IsGre OR (@OldHauteTariff <> @HauteTariff OR (@OldHauteTariff IS NULL AND @HauteTariff IS NOT NULL)
            OR (@OldHauteTariff IS NOT NULL AND @HauteTariff IS NULL)) OR (@OldBasTariff <> @BasTariff OR (@OldBasTariff IS NULL AND @BasTariff IS NOT NULL)
            OR (@OldBasTariff IS NOT NULL AND @BasTariff IS NULL)) OR (@OldTariffTotal <> @TariffTotal OR (@OldTariffTotal IS NULL AND @TariffTotal IS NOT NULL)
            OR (@OldTariffTotal IS NOT NULL AND @TariffTotal IS NULL)) OR @OldDistribution <> @Distribution OR @OldGreTotal <> @GreTotal OR @OldConfirmDetailsfromGrid <> @ConfirmDetailsfromGrid
	  OR @OldAutoCTariff <> @AutoCTariff OR @OldAutoConsumptionSum <> @AutoConsumptionSum OR @OldFacturationSum <> @FacturationSum OR @OldSubTotal <> @SubTotal
	  OR @OldTVA <> @TVA OR @OldTVAForSubTotal <> @TVAForSubTotal OR @OldTotal <> @Total OR @OldGenerateInvoice <> @GenerateInvoice OR (@OldOutStandingAmount <> @OutStandingAmount) OR @OldGridInvoiceName <> @GridInvoiceName)
	  BEGIN
	   EXEC [dbo].[USP_InsertGrERomandeEHistory] @GreRomandeId = @GreRomandeId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@OldJson = @OldJson
	  END
	


 END TRY
 BEGIN CATCH

      THROW

 END CATCH

END
GO
