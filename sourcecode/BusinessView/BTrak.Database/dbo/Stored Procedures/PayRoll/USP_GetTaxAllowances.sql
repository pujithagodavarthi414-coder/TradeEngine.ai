-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update TaxAllowance
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetTaxAllowances] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTaxAllowances]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@TaxAllowanceId UNIQUEIDENTIFIER = NULL,
	@IsMainPage BIT= NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@TaxAllowanceName NVARCHAR(500) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@TaxAllowanceId = '00000000-0000-0000-0000-000000000000') SET @TaxAllowanceId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   DECLARE @BranchId UNIQUEIDENTIFIER = NULL
		   DECLARE @CountryId UNIQUEIDENTIFIER = NULL
		   IF(@IsMainPage = 0)
		   BEGIN
		   SET @BranchId = (SELECT BranchId FROM EmployeeBranch EB WHERE ([ActiveFrom] <= GETDATE() AND ([ActiveTo] IS NULL OR [ActiveTo] >= GETDATE())) AND EmployeeId = @EmployeeId)
		   SET @CountryId = (SELECT CountryId FROM Branch WHERE Id = @BranchId)
		   END

		   IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL	
       	   
           SELECT TA.Id AS TaxAllowanceId,
				  TA.[Name],
		   	      TA.[TaxAllowanceTypeId],
				  TA.[IsPercentage],			
		   	      TA.[MaxAmount],
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,TA.MaxAmount,1) ModifiedMaxAmount,
				  TA.[PercentageValue], 
				  TA.[ParentId],
				  TA.[PayRollComponentId],
				  TA.[ComponentId],
				  TA.[FromDate],
				  TA.[ToDate],
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,TA.OnlyEmployeeMaxAmount,1) ModifiedOnlyEmployeeMaxAmount,
				  TA.[OnlyEmployeeMaxAmount],
				  TA.[MetroMaxPercentage],
				  TA.[LowestAmountOfParentSet],
		   	      TA.CreatedDateTime ,
		   	      TA.CreatedByUserId,
		   	      TA.[TimeStamp],
				  TAT.TaxAllowanceTypeName,
				  C.ComponentName,
				  PRC.ComponentName PayRollComponentName,
				  PTA.Name ParentName,
				  TA.[CountryId],
				  CUN.[CountryName],	
				  (CASE WHEN TA.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
				  (CASE WHEN TA.ComponentId IS NOT NULL THEN 0 WHEN TA.PayRollComponentId IS NOT NULL THEN 1 ELSE NULL END) As [Type],	
		   	      TotalCount = COUNT(1) OVER()
           FROM TaxAllowances AS TA		
		   INNER JOIN TaxAllowanceType TAT ON TAT.Id = TA.TaxAllowanceTypeId
		   INNER JOIN Country CUN ON CUN.Id = TA.CountryId
		   LEFT JOIN Component C ON C.Id = TA.ComponentId
		   LEFT JOIN PayrollComponent PRC ON PRC.Id = TA.PayRollComponentId
		   LEFT JOIN TaxAllowances PTA ON PTA.Id = TA.ParentId
		   INNER JOIN Company COM on COM.Id = TAT.CompanyId
		   LEFT JOIN SYS_Currency CU on CU.Id = COM.CurrencyId
           WHERE CUN.CompanyId = @CompanyId  
		         AND(@CountryId IS NULL OR CUN.Id = @CountryId)
				 AND(@TaxAllowanceName IS NULL OR TA.[Name] = @TaxAllowanceName)
		         AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND TA.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND TA.InActiveDateTime IS NULL))	 
					 AND (@IsMainPage != 0 OR (@IsMainPage = 0 AND TAT.TaxAllowanceTypeName != 'Automatic'))
           ORDER BY TA.[Name] ASC

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