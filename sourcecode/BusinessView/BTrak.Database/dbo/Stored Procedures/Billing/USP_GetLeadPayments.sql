CREATE PROCEDURE [dbo].[USP_GetLeadPayments]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @LeadId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  LP.Id AS PaymentId,
              LI.InvoiceNumber,
              LP.PaidAmount,
              LP.PendingAmount,
              LI.TotalAmount,
              TotalCount = COUNT(1) OVER()
            FROM LeadPayments LP
            INNER JOIN LeadInvoices LI ON LI.Id = LP.InvoiceId
			WHERE (@LeadId IS NULL OR (@LeadId = LI.LeadId))
            ORDER BY LP.CreatedDatetime DESC
 
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
