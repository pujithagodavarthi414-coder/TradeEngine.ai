-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update PayRollComponent
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollComponents] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollComponents]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ComponentName NVARCHAR(500) = NULL,
	@IsDeduction BIT = NULL,
	@IsVariablePay BIT = NULL,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@IsVisible BIT = NULL,
	@PayRollComponentId UNIQUEIDENTIFIER = NULL
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

		   IF(@PayRollComponentId = '00000000-0000-0000-0000-000000000000') SET @PayRollComponentId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT PRC.Id AS PayRollComponentId,
		   	      PRC.CompanyId,
				  PRC.[ComponentName],
		   	      PRC.[IsDeduction],
				  PRC.[IsVariablePay],			
		   	      PRC.InActiveDateTime,
		   	      PRC.CreatedDateTime ,
		   	      PRC.CreatedByUserId,
				  PRC.EmployeeContributionPercentage,
				  PRC.EmployerContributionPercentage,
				  PRC.RelatedToContributionPercentage,
		   	      PRC.[TimeStamp],
				  PRC.[IsVisible],
				  (CASE WHEN PRC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM PayRollComponent AS PRC		        
           WHERE PRC.CompanyId = @CompanyId
				AND (@ComponentName IS NULL OR PRC.[ComponentName] = @ComponentName)
		        AND (@SearchText IS NULL OR (PRC.[ComponentName] LIKE  @SearchText))
		   	    AND (@PayRollComponentId IS NULL OR PRC.Id = @PayRollComponentId)
			    AND (@IsDeduction IS NULL OR PRC.IsDeduction = @IsDeduction)
				AND (@IsVariablePay IS NULL OR PRC.IsVariablePay = @IsVariablePay)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND PRC.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND PRC.InActiveDateTime IS NULL))	
			   AND (@IsVisible IS NULL
				     OR (@IsVisible = 1 AND PRC.IsVisible = 1)
					 OR (@IsVisible = 0 AND PRC.IsVisible = 0))
           ORDER BY PRC.CreatedDateTime DESC

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