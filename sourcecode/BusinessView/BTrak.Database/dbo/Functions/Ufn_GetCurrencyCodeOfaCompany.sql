--SELECT [dbo].[Ufn_GetCurrencyCodeOfaCompany]('CB900830-54EA-4C70-80E1-7F8A453F2BF5')
CREATE FUNCTION [dbo].[Ufn_GetCurrencyCodeOfaCompany]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(50)
AS
BEGIN
			
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	
	DECLARE @CurrencyCode NVARCHAR(50) = (SELECT CurrencyCode FROM SYS_currency
			                                      WHERE Id = (SELECT CurrencyId FROM Company WHERE Id = @CompanyId))

	RETURN ISNULL(@CurrencyCode,'INR')
END
GO