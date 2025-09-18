----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-04 00:00:00.000'
-- Purpose      To Get Invoice Tasks by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceTasks] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceTaskId = '846AE3E0-9DAE-4717-99AE-1A043BC23E41'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceTasks]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @InvoiceTaskId UNIQUEIDENTIFIER = NULL,  
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

           IF(@InvoiceTaskId = '00000000-0000-0000-0000-000000000000') SET @InvoiceTaskId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT IT.Id AS InvoiceTaskId,
				  IT.InvoiceId,
				  IT.TaskName,
				  IT.TaskDescription,	
				  IT.Rate,
				  IT.Hours,
				  IT.CreatedDateTime,
                  IT.CreatedByUserId,
				  IT.UpdatedDateTime,
				  IT.UpdatedByUserId,
				  IT.InActiveDateTime,
                  IT.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM InvoiceTask_New AS IT
		   LEFT JOIN Invoice_New I ON I.Id = IT.InvoiceId
           WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND IT.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND IT.InactiveDateTime IS NULL))
                AND IT.CompanyId = @CompanyId AND I.CompanyId = @CompanyId
				AND (@InvoiceTaskId IS NULL OR IT.Id = @InvoiceTaskId)
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
