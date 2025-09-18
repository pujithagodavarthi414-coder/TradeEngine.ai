CREATE PROCEDURE [dbo].[USP_UpsertCompanyConfigurationUrl]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ConfigurationUrl NVARCHAR(500)
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF(@CompanyId IS NOT NULL)
		BEGIN
		
			UPDATE Company SET ConfigurationUrl = @ConfigurationUrl WHERE Id = @CompanyId
			SELECT 1
		END
		ELSE
			SELECT 0

	END TRY
	BEGIN CATCH
		
		SELECT 0

	END CATCH
END
GO


