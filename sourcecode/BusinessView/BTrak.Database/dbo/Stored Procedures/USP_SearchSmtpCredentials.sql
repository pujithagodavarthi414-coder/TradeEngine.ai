CREATE PROCEDURE [dbo].[USP_SearchSmtpCredentials]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@SiteAddress NVARCHAR(MAX) = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
 DECLARE @HavePermission NVARCHAR(500)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
	--DECLARE @CompanyId UNIQUEIDENTIFIER
	DECLARE @SmtpServer NVARCHAR(MAX)
	DECLARE @SmtpServerPort NVARCHAR(MAX)
	DECLARE @SmtpMail NVARCHAR(MAX)
	DECLARE @CompanyName NVARCHAR(MAX)
	DECLARE @SmtpPassword NVARCHAR(MAX)
	DECLARE @FromAddress NVARCHAR(MAX)
	DECLARE @FromName NVARCHAR(MAX)

	IF(@OperationsPerformedBy IS NOT NULL OR @CompanyId IS NOT NULL)
	BEGIN
		
		IF(@CompanyId IS NULL)
		BEGIN
			
			SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		END

		SET @CompanyName = (SELECT [CompanyName] FROM Company WHERE Id = @CompanyId)
		SET @SmtpServer = (SELECT [value] FROM CompanySettings WHERE [key]='SmtpServer' AND CompanyId = @CompanyId)
		SET @SmtpServerPort = (SELECT [value] FROM CompanySettings WHERE [key]='SmtpServerPort' AND CompanyId = @CompanyId)
		SET @smtpMail = (SELECT [value] FROM CompanySettings WHERE [key]='SMTP mail' AND CompanyId = @CompanyId)
		SET @SmtpPassword = (SELECT [value] FROM CompanySettings WHERE [key]='SMTP password' AND CompanyId = @CompanyId)
	    SET @FromAddress = (SELECT [value] FROM CompanySettings WHERE [key]='FromMailAddress' AND CompanyId = @CompanyId)
		SET @FromName = (SELECT [value] FROM CompanySettings WHERE [key]='FromName' AND CompanyId = @CompanyId)
	END
	ELSE IF(@SiteAddress IS NOT NULL)
	BEGIN
		SET @CompanyId = (SELECT TOP(1) Id FROM Company WHERE @SiteAddress LIKE '%' + SiteAddress + '.%')
		SET @CompanyName = (SELECT [CompanyName] FROM Company WHERE Id = @CompanyId)
		SET @SmtpServer = (SELECT [value] FROM CompanySettings WHERE [key] = 'SmtpServer' AND CompanyId = @CompanyId)
		SET @SmtpServerPort = (SELECT [value] FROM CompanySettings WHERE [key] = 'SmtpServerPort' AND CompanyId = @CompanyId)
		SET @SmtpMail = (SELECT [value] FROM CompanySettings WHERE [key] = 'SMTP mail' AND CompanyId = @CompanyId)
		SET @SmtpPassword = (SELECT [value] FROM CompanySettings WHERE [key] = 'SMTP password' AND CompanyId = @CompanyId)
		SET @FromAddress = (SELECT [value] FROM CompanySettings WHERE [key]='FromMailAddress' AND CompanyId = @CompanyId)
		SET @FromName = (SELECT [value] FROM CompanySettings WHERE [key]='FromName' AND CompanyId = @CompanyId)
	END
	SELECT @SmtpServer AS SmtpServer, @SmtpServerPort AS SmtpServerPort, @smtpMail AS SmtpMail ,@smtpPassword AS SmtpPassword, @CompanyName AS CompanyName, @FromAddress AS FromAddress
	,@FromName AS FromName
END
END
