----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-10 00:00:00.000'
-- Purpose      To Get Invoice Items by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceItems] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceItemId = '12B3FACD-B9AB-4727-A8F2-1B704FBD4CE5'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceItems]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @InvoiceItemId UNIQUEIDENTIFIER = NULL, 
	@InvoiceId UNIQUEIDENTIFIER = NULL,  
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@InvoiceItemId = '00000000-0000-0000-0000-000000000000') SET @InvoiceItemId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT II.Id AS InvoiceItemId,
				  II.InvoiceId,
				  II.ItemName,
				  II.ItemDescription,	
				  II.Price,
				  II.Quantity,
				  II.CreatedDateTime,
                  II.CreatedByUserId,
				  II.UpdatedDateTime,
				  II.UpdatedByUserId,
				  II.InActiveDateTime,
                  II.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM InvoiceItem_New AS II
		   LEFT JOIN Invoice_New I ON I.Id = II.InvoiceId
           WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND II.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND II.InactiveDateTime IS NULL))
                AND I.CompanyId = @CompanyId AND II.CompanyId = @CompanyId
				AND (@InvoiceItemId IS NULL OR II.Id = @InvoiceItemId)
				AND (@InvoiceId IS NULL OR II.InvoiceId = @InvoiceId)
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
