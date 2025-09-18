CREATE PROCEDURE [dbo].[USP_GetMailsCount]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	
		--TODO
		IF(@CompanyId IS NULL) SET @CompanyId = '4AFEB444-E826-4F95-AC41-2175E36A0C16' --Snovasys company id
		
		SELECT ISNULL((SELECT COUNT(1) FROM SentMail 
					   WHERE CompanyId = @CompanyId 
					         AND CONVERT(DATE,CreatedDateTime) = CONVERT(DATE,GETDATE())),0) AS MailCount

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO