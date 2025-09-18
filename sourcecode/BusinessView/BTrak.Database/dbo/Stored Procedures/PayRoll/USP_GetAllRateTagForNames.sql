CREATE PROCEDURE [dbo].[USP_GetAllRateTagForNames]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsAllowance BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	      IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  SELECT Id RateTagForId,
				 RateTagForName
		  FROM [dbo].[RateTagFor] WITH (NOLOCK)
		  WHERE CompanyId = @CompanyId
		  AND (@IsAllowance IS NULL OR IsAllowance = @IsAllowance)
		  ORDER BY RateTagForName

	 END TRY  
	 BEGIN CATCH 
		
	    	EXEC USP_GetErrorInformation

	 END CATCH
END
