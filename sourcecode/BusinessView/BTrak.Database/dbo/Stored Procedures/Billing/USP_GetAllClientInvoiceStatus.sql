-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllClientInvoiceStatus] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllClientInvoiceStatus]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@InvoiceStatusId UNIQUEIDENTIFIER = NULL,	
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

		   IF(@InvoiceStatusId = '00000000-0000-0000-0000-000000000000') SET @InvoiceStatusId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CS.Id AS InvoiceStatusId,
		   	      CS.StatusName AS StatusName,
		   	      CS.InvoiceStatusName AS InvoiceStatusName,
		   	      CS.StatusColor AS InvoiceStatusColor,
		   	      CS.InActiveDateTime,
		   	      CS.CreatedDateTime,
		   	      CS.CreatedByUserId,
		   	      CS.[TimeStamp],
				  CASE WHEN CS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [ClientInvoiceStatus] AS CS
           WHERE CS.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (CS.StatusName LIKE @SearchText))
		   	   AND (@InvoiceStatusId IS NULL OR CS.Id = @InvoiceStatusId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CS.InActiveDateTime IS NULL))
           ORDER BY CS.StatusName ASC

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
