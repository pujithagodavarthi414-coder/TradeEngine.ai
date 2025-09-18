CREATE PROCEDURE [dbo].[USP_GetCompanyConfigurationUrl]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF(@CompanyId IS NOT NULL)
		BEGIN
		
			SELECT ConfigurationUrl FROM Company WHERE Id=@CompanyId
		END
		ELSE
			SELECT ''

	END TRY
	BEGIN CATCH
		
		SELECT ''

	END CATCH
END
GO


