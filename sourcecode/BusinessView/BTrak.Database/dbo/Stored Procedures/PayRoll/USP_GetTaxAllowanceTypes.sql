-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTaxAllowanceTypes] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTaxAllowanceTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TaxAllowanceTypeName NVARCHAR(500) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF (@HavePermission = '1')
	    BEGIN
		
           SELECT TA.Id AS TaxAllowanceTypeId,
				  TA.[TaxAllowanceTypeName]
           FROM TaxAllowanceType AS TA		
		   WHERE TA.CompanyId = @CompanyId
		   AND (@TaxAllowanceTypeName IS NULL OR TA.[TaxAllowanceTypeName] = @TaxAllowanceTypeName)
           ORDER BY TA.[TaxAllowanceTypeName] ASC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO