CREATE PROCEDURE [dbo].[USP_GetAllRateSheetForNames]
(
   @OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS

BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	      IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  SELECT  Id RateSheetForId,
				  RateSheetForName,
				  CreatedByUserId,
				  CreatedDateTime,
				  CompanyId,
				  [TimeStamp],
				  [IsShift],
				  IsAllowance,
				  CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()

		  FROM [dbo].[RateSheetFor] WITH (NOLOCK)
		  WHERE CompanyId = @CompanyId

	 END TRY  
	 BEGIN CATCH 
		
	    	EXEC USP_GetErrorInformation

	END CATCH
END