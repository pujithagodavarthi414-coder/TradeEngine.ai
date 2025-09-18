CREATE PROCEDURE [dbo].[USP_GetExternalServiceProperties]
(
	@ExternalServiceName NVARCHAR(250),
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))    
	
	DECLARE @ExternalServiceId  UNIQUEIDENTIFIER 
	SELECT @ExternalServiceId = Id FROM CrmExternalServices where Name =  @ExternalServiceName
	
	SELECT [Name] [PropertyName], [Value] [PropertyValue] FROM CrmExternalServicesProperties ESP WHERE ESP.ExternalId = @ExternalServiceId AND CompanyId = @CompanyId
END
