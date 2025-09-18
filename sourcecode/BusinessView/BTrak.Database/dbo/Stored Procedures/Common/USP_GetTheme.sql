CREATE PROCEDURE [dbo].[USP_GetTheme]
(
	@SiteAddress NVARCHAR(MAX),
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER
		
		IF(@OperationsPerformedBy IS NULL)
		BEGIN
				SET @CompanyId =(SELECT Id FROM Company WHERE @SiteAddress =  SiteAddress)
		END
		
		ELSE
			BEGIN
				 SET @CompanyId =(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			END
																											    
		

		DECLARE @Theme NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'Theme')
		
		DECLARE @ThemeId UNIQUEIDENTIFIER = (SELECT [Id] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'Theme')

		DECLARE @MiniLogo NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MainLogo')

		DECLARE @MainLogo NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MiniLogo')

		DECLARE @PaySlipLogo NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'PayslipLogo')

		DECLARE @DefaultLoginWithGoogle BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableLoginWithGoogle%')

		DECLARE @RegisterSiteUrl NVARCHAR(MAX) = (SELECT [RegistrerSiteAddress] FROM Company where Id = @CompanyId)

		DECLARE @SiteTitle NVARCHAR(MAX) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MailFooterAddress')
		DECLARE @CompanyName NVARCHAR(250) = (SELECT CompanyName FROM Company WHERE Id = @CompanyId)

		--DECLARE @DefaultLanguage NVARCHAR(800) = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'DefaultLanguage')

		DECLARE @DefaultLanguage NVARCHAR(800) = (SELECT [Language] FROM [User] WHERE Id = @OperationsPerformedBy )

		IF(@DefaultLanguage IS NULL)
		BEGIN
			SET @DefaultLanguage = (SELECT [Language] FROM Company WHERE Id = @CompanyId )
		END

		SELECT @Theme  AS CompanyThemeString
			  ,@ThemeId AS CompanyThemeId
		      ,@MiniLogo AS CompanyMainLogo
			  ,@MainLogo AS CompanyMiniLogo
			  ,@PaySlipLogo AS PayslipLogo
			  ,@DefaultLanguage AS DefaultLanguage
			  ,@DefaultLoginWithGoogle AS DefaultLoginWithGoogle
			  ,@RegisterSiteUrl As  RegistrerSiteAddress
			  ,@SiteTitle AS SiteTitle
			  ,@CompanyName AS CompanyName

	END TRY
    BEGIN CATCH

		THROW

	END CATCH
END