---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the contracttypes by applying diffrent filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetContractTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetContractTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@ContractTypeId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL	
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

		   IF(@ContractTypeId = '00000000-0000-0000-0000-000000000000') SET @ContractTypeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CT.Id AS ContractTypeId,
		   	      CT.CompanyId,
		   	      CT.ContractTypeName,
		   	      CT.InActiveDateTime,
				  IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				  CT.TerminationDate,
				  CT.TerminationReason,
		   	      CT.CreatedDateTime ,
		   	      CT.CreatedByUserId,
		   	      CT.[TimeStamp],	
		   	      TotalCount = COUNT(*) OVER()
           FROM ContractType AS CT		        
           WHERE CT.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (CT.ContractTypeName LIKE  '%'+ @SearchText +'%'))
		   	   AND (@ContractTypeId IS NULL OR CT.Id = @ContractTypeId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CT.InActiveDateTime IS NULL))
		   	    
           ORDER BY CT.ContractTypeName ASC

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

