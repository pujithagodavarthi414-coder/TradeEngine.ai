-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllLegalEntites] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllLegalEntites]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@LegalEntityId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@LegalEntityId = '00000000-0000-0000-0000-000000000000') SET @LegalEntityId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT LE.Id AS LegalEntityId,
		   	      LE.LegalEntityName,
		   	      LE.InActiveDateTime,
		   	      LE.CreatedDateTime,
		   	      LE.CreatedByUserId,
		   	      LE.[TimeStamp],
				  CASE WHEN LE.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM LegalEntity AS LE
           WHERE LE.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (LE.LegalEntityName LIKE @SearchText))
		   	   AND (@LegalEntityId IS NULL OR LE.Id = @LegalEntityId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND LE.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND LE.InActiveDateTime IS NULL))
           ORDER BY LE.LegalEntityName ASC

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