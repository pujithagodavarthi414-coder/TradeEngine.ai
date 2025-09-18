CREATE PROCEDURE [dbo].[USP_ValidateApiKey]
	@ApiKey NVARCHAR(50)
AS
	SELECT IsExpired = CASE WHEN AK.ExpiryDate >= GETDATE() THEN 1 ELSE 0 END FROM [dbo].[ApiKey] AK WHERE AK.[Key] = @ApiKey
RETURN 0