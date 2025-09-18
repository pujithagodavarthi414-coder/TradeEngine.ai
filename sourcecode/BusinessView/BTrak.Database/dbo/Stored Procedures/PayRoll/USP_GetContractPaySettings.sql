-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update ContractPaySettings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetContractPaySettings]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@ContractPaySettingsId UNIQUEIDENTIFIER = NULL
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

		   IF(@ContractPaySettingsId = '00000000-0000-0000-0000-000000000000') SET @ContractPaySettingsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CPS.Id AS ContractPaySettingsId,
		   	      CPS.BranchId,
				  CPS.ContractPayTypeId,
				  (CASE WHEN CPS.IsToBePaid  = 1 THEN 1 ELSE 0 END) IsToBePaid,
				  (CASE WHEN CPS.IsToBePaid  = 0 THEN 1 ELSE 0 END) IsToBeDeducted,
				  CPS.ActiveFrom,
				  CPS.ActiveTo,
		   	      CPS.InActiveDateTime,
		   	      CPS.CreatedDateTime ,
		   	      CPS.CreatedByUserId,
		   	      CPS.[TimeStamp],
				  B.BranchName,
				  CPT.ContractPayTypeName,
				  (CASE WHEN CPS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM ContractPaySettings AS CPS	
		        INNER JOIN Branch B ON B.Id = CPS.BranchId	
				INNER JOIN ContractPayType CPT ON CPT.Id = CPS.ContractPayTypeId	        
           WHERE B.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR B.[BranchName] LIKE  @SearchText)
		   	    AND (@ContractPaySettingsId IS NULL OR CPS.Id = @ContractPaySettingsId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND CPS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND CPS.InActiveDateTime IS NULL))	
           ORDER BY CPS.CreatedDateTime DESC

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