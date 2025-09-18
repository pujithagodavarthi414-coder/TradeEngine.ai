-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllKycStatus] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllKycStatus]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@KycStatusId UNIQUEIDENTIFIER = NULL,	
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

		   IF(@KycStatusId = '00000000-0000-0000-0000-000000000000') SET @KycStatusId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CK.Id AS KycStatusId,
		   	      CK.StatusName AS StatusName,
		   	      CK.KycStatusName AS KycStatusName,
		   	      CK.StatusColor AS KycStatusColor,
		   	      CK.InActiveDateTime,
		   	      CK.CreatedDateTime,
		   	      CK.CreatedByUserId,
		   	      CK.[TimeStamp],
				  CASE WHEN CK.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM ClientKycFormStatus AS CK
           WHERE CK.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (CK.StatusName LIKE @SearchText))
		   	   AND (@KycStatusId IS NULL OR CK.Id = @KycStatusId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CK.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CK.InActiveDateTime IS NULL))
           ORDER BY CK.StatusName ASC

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
