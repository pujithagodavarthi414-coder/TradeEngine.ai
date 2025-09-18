CREATE PROCEDURE [dbo].[USP_GetUserByUserAuthenticationIdAndCompanyId]
(
  @Id UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		--DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT Id FROM [User] WHERE CompanyId = @CompanyId AND UserAuthenticationId = @Id
	END TRY
	BEGIN CATCH 
        
        THROW
    END CATCH
END
