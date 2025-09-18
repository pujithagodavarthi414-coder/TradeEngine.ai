CREATE PROCEDURE [dbo].[USP_GetAllInvoicePaymentStatus]
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
       	   
           SELECT ITS.Id AS InvoiceStatusId,
		   	      ITS.StatusName AS StatusName,
		   	      ITS.InvoiceStatusName AS InvoiceStatusName,
		   	      ITS.StatusColor AS InvoiceStatusColor,
		   	      ITS.InActiveDateTime,
		   	      ITS.CreatedDateTime,
		   	      ITS.CreatedByUserId,
		   	      ITS.[TimeStamp],
				  CASE WHEN ITS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [InvoiceQueueTradingStatus] AS ITS
           WHERE ITS.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (ITS.StatusName LIKE @SearchText))
		   	   AND (@InvoiceStatusId IS NULL OR ITS.Id = @InvoiceStatusId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ITS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ITS.InActiveDateTime IS NULL))
           ORDER BY ITS.StatusName ASC

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
