CREATE PROCEDURE [dbo].[USP_UpsertBankAccount]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@BankAccountName NVARCHAR(250) = NULL,
	@Beneficiaire NVARCHAR(250) = NULL,
	@Banque NVARCHAR(250) = NULL,
	@Iban NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL
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
			DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
			DECLARE @GRDIdCount INT = (SELECT COUNT(1) FROM [BankAccount] WHERE Id = @Id AND CompanyId = @CompanyId)

			DECLARE @GRDNameCount INT = (SELECT COUNT(1) FROM [BankAccount] WHERE [BankAccountName] = @BankAccountName AND CompanyId = @CompanyId AND (@Id IS NULL OR Id <> @Id) AND InactiveDateTime IS NULL)

			IF(@GRDIdCount = 0 AND @Id IS NOT NULL)
			BEGIN
				RAISERROR(50002,16, 1,'BankAccountName')
			END
          
			ELSE IF(@GRDNameCount > 0)
			BEGIN
				RAISERROR(50001,16,1,'BankAccountName')
			END
		 ELSE  IF(EXISTS(SELECT Id FROM [PaymentReceipt] WHERE BankId = @Id AND InActiveDateTime IS NULL AND @IsArchived = 1 AND @Id IS NOT NULL))
         BEGIN
         
         SET @IsEligibleToArchive = 'ThisBankAccountIsHavingDependencieshPleaseDeleteTheDependenciesAndTryAgain'
         
         END
         
         IF(@IsEligibleToArchive <> '1')
         BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
         END

			ELSE
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [dbo].[BankAccount] WHERE Id = @Id) = @TimeStamp
			   														THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
			BEGIN
				IF(@Id IS NULL)
				BEGIN
					SET @Id = (SELECT NEWID())

					INSERT INTO [dbo].[BankAccount](
									[Id],
									BankAccountName,
									Banque,
									Iban,
									Beneficiaire,
									[CreatedByUserId],
									[CreatedDateTime],
									CompanyId
									)
							SELECT @Id,
								   @BankAccountName,
								   @Banque,
								   @Iban,
								   @Beneficiaire,
								   @OperationsPerformedBy,
								   GETDATE(),
								   @CompanyId
				END
				ELSE
				BEGIN
					UPDATE [dbo].[BankAccount]
						SET BankAccountName = @BankAccountName,
							Banque = @Banque,
							Iban = @Iban,
							Beneficiaire = @Beneficiaire,
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