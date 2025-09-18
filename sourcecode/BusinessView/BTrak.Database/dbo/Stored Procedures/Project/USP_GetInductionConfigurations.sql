-------------------------------------------------------------------------------
-- Author       Anupam sai kumar vuyyuru
-- Created      '2019-05-24 00:00:00.000'
-- Purpose      To Get The induction titles
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetInductionConfigurations] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInductionConfigurations]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
		BEGIN TRY
	    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

      IF (@HavePermission = '1')
      BEGIN
      
	      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	       
	            SELECT IC.Id AS InductionId,
	  	    		   IC.CompanyId,
	  	    		   IC.InductionName,
					   IC.IsShow,
					   CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					   IC.InActiveDateTime,
	  	    		   IC.CreatedDateTime, 
	  	    		   IC.CreatedByUserId,
	  	    		   IC.UpdatedDateTime,
	  	    		   IC.UpdatedByUserId,
					   IC.[TimeStamp],
	  	    		   TotalCount = COUNT(1) OVER()
	  	        FROM InductionConfiguration IC WITH (NOLOCK)
	  	        WHERE IC.CompanyId = @CompanyId 
					 AND (InActiveDateTime IS NULL)
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
