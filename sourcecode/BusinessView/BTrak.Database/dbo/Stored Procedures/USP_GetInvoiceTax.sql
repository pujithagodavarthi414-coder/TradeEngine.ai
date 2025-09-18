----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-04 00:00:00.000'
-- Purpose      To Get Invoice Tax by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceTax] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceTaxId = 'A0DFE7A6-03CC-4983-B03F-B4306F92FDD5'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceTax]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @InvoiceTaxId UNIQUEIDENTIFIER = NULL,
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

           IF(@InvoiceTaxId = '00000000-0000-0000-0000-000000000000') SET @InvoiceTaxId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT IT.Id AS InvoiceTaxId,
				  IT.InvoiceId,
				  IT.Tax,
				  IT.CreatedDateTime,
                  IT.CreatedByUserId,
				  IT.UpdatedDateTime,
				  IT.UpdatedByUserId,
				  IT.InActiveDateTime,
                  IT.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM InvoiceTax AS IT
		   LEFT JOIN Invoice_New I ON I.Id = IT.InvoiceId
           WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND IT.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND IT.InactiveDateTime IS NULL))
                AND IT.CompanyId = @CompanyId AND I.CompanyId = @CompanyId
				AND (@InvoiceTaxId IS NULL OR IT.Id = @InvoiceTaxId)
				AND (@InvoiceId IS NULL OR IT.InvoiceId = @InvoiceId)
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
