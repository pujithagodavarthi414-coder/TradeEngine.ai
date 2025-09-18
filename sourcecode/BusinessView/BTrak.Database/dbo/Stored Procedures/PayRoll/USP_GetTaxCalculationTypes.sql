-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTaxCalculationTypes] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTaxCalculationTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmployeeBranchId UNIQUEIDENTIFIER

		DECLARE @CountryId UNIQUEIDENTIFIER
		
		IF(@EmployeeId IS NOT NULL)
		BEGIN
		SET @EmployeeBranchId = (SELECT BranchId FROM EmployeeBranch EB WHERE EB.EmployeeId = @EmployeeId
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()))
		SET @CountryId = (SELECT CountryId FROM Branch WHERE Id = @EmployeeBranchId)

		END

		IF (@HavePermission = '1')
	    BEGIN
		
           SELECT TCT.Id AS TaxCalculationTypeId,
				  TCT.[TaxCalculationTypeName],
				  TCT.[CountryId]
           FROM TaxCalculationType AS TCT		
		   JOIN Country C ON C.Id = TCT.[CountryId]
		   WHERE C.CompanyId = @CompanyId
		   AND (@CountryId IS NULL OR C.Id = @CountryId OR (@EmployeeId IS NOT NULL AND C.CountryName = 'India'))
           ORDER BY TCT.[TaxCalculationTypeName] ASC

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