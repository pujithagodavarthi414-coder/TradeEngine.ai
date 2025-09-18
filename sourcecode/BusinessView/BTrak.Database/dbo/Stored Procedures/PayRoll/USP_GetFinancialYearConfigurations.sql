-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update FinancialYearConfigurations
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetFinancialYearConfigurations] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetFinancialYearConfigurations]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT= NULL,
	@FinancialYearConfigurationsId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   
		   IF(@FinancialYearConfigurationsId = '00000000-0000-0000-0000-000000000000') SET @FinancialYearConfigurationsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT ERS.Id AS FinancialYearConfigurationsId,
		          ERS.[CountryId],
				  C.[CountryName],	
		   	      ERS.[FromMonth],
				  ERS.[ToMonth],
		   	      ERS.InActiveDateTime,
		   	      ERS.CreatedDateTime ,
				  ERS.[ActiveFrom],
				  ERS.[ActiveTo],
		   	      ERS.CreatedByUserId,
				  ERS.FinancialYearTypeId,
				  FYT.FinancialYearTypeName,
		   	      ERS.[TimeStamp],
				  (CASE WHEN ERS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM FinancialYearConfigurations AS ERS
		   INNER JOIN Country C ON c.Id = ERS.CountryId	
		   INNER JOIN FinancialYearType FYT ON FYT.Id = ERS.FinancialYearTypeId	
           WHERE C.[CompanyId] = @CompanyId
		   	    AND (@FinancialYearConfigurationsId IS NULL OR ERS.Id = @FinancialYearConfigurationsId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND ERS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND ERS.InActiveDateTime IS NULL))	   	    

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

