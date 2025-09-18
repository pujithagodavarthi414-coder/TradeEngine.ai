-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-23 00:00:00.000'
-- Purpose      To Save or Update PayRollTemplateConfiguration
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollTemplateConfigurations] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollTemplateConfigurations]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT = NULL,
	@PayRollTemplateId UNIQUEIDENTIFIER = NULL
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

		   IF(@PayRollTemplateId = '00000000-0000-0000-0000-000000000000') SET @PayRollTemplateId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT PRTC.Id AS PayRollTemplateConfigurationId,
				  PRTC.[PayrollComponentId],
				  PRTC.[PayrollTemplateId],
				  PRTC.[Ispercentage] IsPercentage,
				  (CASE WHEN PRTC.[Amount] IS NOT NULL THEN 0 WHEN PRTC.[Percentagevalue] IS NOT NULL THEN 1 ELSE NULL END) As [Type],
				  (CASE WHEN PRTC.[Amount] IS NOT NULL THEN PRTC.[Amount] WHEN PRTC.[Percentagevalue] IS NOT NULL THEN PRTC.[Percentagevalue] ELSE NULL END) As Value,
				  (CASE WHEN PRTC.[IsCtcDependent] = 1 THEN 1 WHEN PRTC.[IsRelatedToPT] = 1 THEN 2  WHEN PRTC.[ComponentId] IS NOT NULL THEN 0 
				   WHEN PRTC.[DependentPayrollComponentId] IS NOT NULL THEN 3 ELSE NULL END) As DependentType,
				  PRTC.[Amount],
				  dbo.Ufn_GetCurrency(CU.CurrencyCode,PRTC.Amount,1) ModifiedAmount,
				  PRTC.[Percentagevalue],
				  PRTC.[IsCtcDependent],
				  PRTC.[IsRelatedToPT],
				  PRTC.[ComponentId],
				  C.[ComponentName],
				  (CASE WHEN PRTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				  PRTC.[CreatedDateTime],
				  PRTC.[CreatedByUserId],
				  PRTC.[TimeStamp],
				  PRTC.[Order],
				  PRC.ComponentName PayRollComponentName,
				  PRC.IsDeduction,
				  PRC.RelatedToContributionPercentage,
				  PRT.PayrollName PayRollTemplateName,
				  PRTC.DependentPayrollComponentId,
				  DPRC.ComponentName DependentPayRollComponentName,
		   	      TotalCount = COUNT(1) OVER()
           FROM PayRollTemplateConfiguration AS PRTC		
		        INNER JOIN PayrollComponent PRC ON PRC.Id = PRTC.PayrollComponentId
				INNER JOIN PayrollTemplate PRT ON PRT.Id = PRTC.PayrollTemplateId
				INNER JOIN Sys_Currency CU ON CU.Id = PRT.CurrencyId
				LEFT JOIN Component C ON C.Id = PRTC.ComponentId
				LEFT JOIN PayrollComponent DPRC ON DPRC.Id = PRTC.DependentPayrollComponentId
           WHERE PRC.CompanyId = @CompanyId
		        AND (@SearchText IS NULL 
				     OR (PRC.ComponentName LIKE @SearchText)
				     OR (PRT.PayrollName LIKE @SearchText))
		   	    AND (@PayRollTemplateId IS NULL OR PRT.Id = @PayRollTemplateId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND PRTC.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND PRTC.InActiveDateTime IS NULL))	   	    
           ORDER BY PRTC.[Order] ASC

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
