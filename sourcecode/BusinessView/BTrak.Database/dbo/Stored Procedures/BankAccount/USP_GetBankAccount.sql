CREATE PROCEDURE [dbo].[USP_GetBankAccount]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN				
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @TVAValue DECIMAL(18, 2) = (SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
			IF(@SearchText = '') SET @SearchText = NULL
		   
			SET @SearchText = '%'+ @SearchText +'%'

			SELECT Id,
				   BankAccountName,
				   Beneficiaire,
				   Banque,
				   Iban,
				   [TimeStamp]
				FROM [dbo].[BankAccount]
				WHERE CompanyId = @CompanyId
				AND InActiveDateTime IS NULL
				AND (@Id IS NULL OR Id = @Id)
				AND	(@SearchText IS NULL
					OR BankAccountName LIKE @SearchText
					OR Beneficiaire LIKE @SearchText
					OR Iban LIKE @SearchText
					OR Banque LIKE @SearchText)

				ORDER BY BankAccountName ASC
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END