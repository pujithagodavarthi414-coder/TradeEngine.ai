-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetTradeContractTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTradeContractTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL,	
	@ContractTypeId UNIQUEIDENTIFIER = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  ='1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT TCT.ContractTypeName,
				  TCT.FormJson,
				  TCT.Id AS ContractTypeId
           FROM TradeContractType AS TCT
           WHERE TCT.CompanyId = @CompanyId
		    AND (@ContractTypeId IS NULL OR TCT.Id = @ContractTypeId)
				 AND(@IsArchived IS NULL OR (@IsArchived = 1 AND TCT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TCT.InActiveDateTime IS NULL))
           ORDER BY TCT.ContractTypeName

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


