CREATE PROCEDURE [dbo].[USP_UpdateCompanySettings]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER,
	@SiteDomain NVARCHAR(500)= NULL,
	@SiteAddress NVARCHAR(500)= NULL,
	@Email NVARCHAR(500)= NULL,
	@CompanyLogo NVARCHAR(max) = NULL,
    @CompanyMiniLogo NVARCHAR(max) = NULL,
	@CompanyRegisatrationLogo NVARCHAR(max) = NULL,
	@CompanySigninLogo NVARCHAR(max) = NULL,
	@MailFooterAddress NVARCHAR(200) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		
		IF(@CompanyId IS NOT NULL)
		BEGIN
			UPDATE CompanySettings SET [Value] = @CompanyLogo WHERE CompanyId = @CompanyId AND [Key] = 'MainLogo'

			UPDATE CompanySettings SET [Value] = @CompanyMiniLogo WHERE CompanyId = @CompanyId AND [Key] = 'MiniLogo'

			DECLARE @isCompanySigninLogo BIT = NULL
			SET @isCompanySigninLogo =(SELECT 1 FROM CompanySettings  WHERE CompanyId = @CompanyId AND [Key] = 'CompanyRegisatrationLogo')

			IF(@isCompanySigninLogo IS NULL)
				BEGIN
					INSERT INTO CompanySettings(Id,[Key],[Value],[Description],[CompanyId],[CreatedByUserId],[CreatedDateTime])VALUES
					(NEWID(),'CompanyRegisatrationLogo',@CompanyRegisatrationLogo,'Logo for company registartion',@CompanyId,@OperationsPerformedBy,GETDATE());

					INSERT INTO CompanySettings(Id,[Key],[Value],[Description],[CompanyId],[CreatedByUserId],[CreatedDateTime])VALUES
					(NEWID(),'CompanySigninLogo',@CompanySigninLogo,'Logo for company registartion',@CompanyId,@OperationsPerformedBy,GETDATE());

					INSERT INTO CompanySettings(Id,[Key],[Value],[Description],[CompanyId],[CreatedByUserId],[CreatedDateTime])VALUES
					(NEWID(),'MailFooterAddress',@MailFooterAddress,'Footer address for company mail',@CompanyId,@OperationsPerformedBy,GETDATE());
					SELECT 1
				END
			ELSE
			
				UPDATE CompanySettings SET [Value] = @CompanyRegisatrationLogo WHERE CompanyId = @CompanyId AND [Key] = 'CompanyRegisatrationLogo'
				UPDATE CompanySettings SET [Value] = @CompanySigninLogo WHERE CompanyId = @CompanyId AND [Key] = 'CompanySigninLogo'
				UPDATE CompanySettings SET [Value] = @MailFooterAddress WHERE CompanyId = @CompanyId AND [Key] = 'MailFooterAddress'
			SELECT 1
		END
		ELSE
			SELECT 0
	END TRY
	BEGIN CATCH
		
		SELECT 0

	END CATCH
END