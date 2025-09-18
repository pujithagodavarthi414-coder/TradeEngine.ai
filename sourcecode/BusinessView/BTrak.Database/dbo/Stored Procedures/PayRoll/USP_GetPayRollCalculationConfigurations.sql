-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2025-01-20 00:00:00.000'
-- Purpose      To Save or Update PayRollCalculationConfigurations
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollCalculationConfigurations] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollCalculationConfigurations]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT= NULL,
	@PayRollCalculationConfigurationsId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		 
		   IF(@PayRollCalculationConfigurationsId = '00000000-0000-0000-0000-000000000000') SET @PayRollCalculationConfigurationsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT TCC.Id AS PayRollCalculationConfigurationsId,
				  TCC.[BranchId],
		   	      TCC.[PeriodTypeId],
				  B.[BranchName],	
				  TCT.PeriodTypeName,	
				  TCC.PayRollCalculationTypeId,
				  PCT.PayRollCalculationTypeName,
		   	      TCC.InActiveDateTime,
		   	      TCC.CreatedDateTime ,
		   	      TCC.CreatedByUserId,
				  TCC.ActiveFrom,
				  TCC.ActiveTo,
		   	      TCC.[TimeStamp],
				  (CASE WHEN TCC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM PayRollCalculationConfigurations AS TCC	
		   INNER JOIN Branch B ON B.Id = TCC.BranchId	  
		   INNER JOIN PeriodType TCT ON TCT.Id = TCC.PeriodTypeId
		   INNER JOIN PayRollCalculationType PCT ON PCT.Id = TCC.PayRollCalculationTypeId
           WHERE B.CompanyId = @CompanyId
		   	    AND (@PayRollCalculationConfigurationsId IS NULL OR TCC.Id = @PayRollCalculationConfigurationsId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND TCC.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND TCC.InActiveDateTime IS NULL))	   	    
           ORDER BY TCC.CreatedDateTime DESC

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