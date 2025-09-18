CREATE PROCEDURE [dbo].[USP_UpsertCreditNote]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@SiteId UNIQUEIDENTIFIER,
	@GrdId UNIQUEIDENTIFIER,
	@Month DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@EntryDate DATETIME,
	@Term NVARCHAR(20),
	@Name NVARCHAR(250),
	@Year DATETIME,
	@IsTVAApplied BIT,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@InvoiceUrl NVARCHAR(MAX) = NULL,
	@IsArchived BIT = NULL,
	@IsGenerateInvoice BIT = 0
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
			DECLARE @CreditNotesIdCount INT = (SELECT COUNT(1) FROM [CreditNotes] WHERE Id = @Id AND CompanyId = @CompanyId)
			DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
			DECLARE @CreditNotesCount INT = (SELECT COUNT(1) FROM [CreditNotes] WHERE [Name] = @Name AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InactiveDateTime IS NULL)

			IF(@CreditNotesIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'CreditNotes')
			END
          
			ELSE IF(@CreditNotesCount > 0 AND @IsArchived=0)
			BEGIN
				RAISERROR(50001,16,1,'CreditNotes')
			END
		 ELSE  IF(EXISTS(SELECT Id FROM [PaymentReceiptCreditNotes] WHERE CreditNoteId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisCreditNoteIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         
         IF(@IsEligibleToArchive <> '1')
         BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
         END
			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[CreditNotes] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)


				IF(@IsLatest = 1)
				BEGIN
					IF(@Id IS NULL)
					BEGIN
						SET @Id = (SELECT NEWID())

						INSERT INTO [dbo].[CreditNotes]
													(
														[Id],
														[Name],
														SiteId,
														GrdId,
														EntryDate,
														[Month],
														StartDate,
														EndDate,
														Term,
														[Year],
														[IsTVAApplied],
														[IsGenerateInvoice],
														[TVA],
														[InvoiceUrl],
														CompanyId,
														CreatedByUserId,
														CreatedDateTime
														)
											SELECT @Id,
													@Name,
												   @SiteId,
												   @GrdId,
												   @EntryDate,
												   @Month,
												   @StartDate,
												   @EndDate,
												   @Term,
												   @Year,
												   @IsTVAApplied,
												   @IsGenerateInvoice,
												   (SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL),
												   @InvoiceUrl,
												   @CompanyId,
												   @OperationsPerformedBy,
												   GETDATE()

					END
					ELSE
					BEGIN

						UPDATE [dbo].[CreditNotes]
							SET SiteId = @SiteId,
								GrdId = @GrdId,
								[Name] = @Name,
								EntryDate = @EntryDate,
								[Month] = @Month,
								StartDate = @StartDate,
								EndDate = @EndDate,
								Term = @Term,
								[Year] = @Year,
								[IsTVAApplied]=@IsTVAApplied,
								[InvoiceUrl]=@InvoiceUrl,
								[IsGenerateInvoice]=@IsGenerateInvoice,
								[TVA]			=	(SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL),
								UpdatedByUserId = @OperationsPerformedBy,
								UpdatedDateTime = GETDATE(),
								InActiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
						WHERE Id = @Id
					END

					SELECT @Id
				END
			ELSE
			BEGIN
				RAISERROR (50008,11, 1)
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