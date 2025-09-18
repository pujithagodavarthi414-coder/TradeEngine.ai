-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-13 00:00:00.000'
-- Purpose      To Get Pay Frequencies
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetPayFrequencies] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayFrequencies]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@PayFrequencyId UNIQUEIDENTIFIER = NULL,	
	@PayFrequencyName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@PayFrequencyId = '00000000-0000-0000-0000-000000000000') SET @PayFrequencyId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT PF.Id AS PayFrequencyId,
		   	      PF.CompanyId,
		   	      PF.PayFrequencyName,
		   	      PF.InActiveDateTime,
		   	      PF.CreatedDateTime,
		   	      PF.CreatedByUserId,
		   	      PF.[TimeStamp],	
				  PF.CronExpression,
				  CASE WHEN PF.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM PayFrequency AS PF		        
           WHERE  PF.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (PF.PayFrequencyName LIKE '%' + @SearchText + '%'))
		   	   AND (@PayFrequencyId IS NULL OR PF.Id = @PayFrequencyId)
			   AND (@PayFrequencyName IS NULL OR PF.PayFrequencyName = @PayFrequencyName)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PF.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PF.InActiveDateTime IS NULL))
           ORDER BY PF.PayFrequencyName ASC

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