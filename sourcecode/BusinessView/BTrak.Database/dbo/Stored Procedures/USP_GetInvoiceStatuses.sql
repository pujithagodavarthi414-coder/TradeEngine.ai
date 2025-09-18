----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-02-28 00:00:00.000'
-- Purpose      To Get Invoice Statuses by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceStatuses] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceStatuses]
(
	@InvoiceStatusId UNIQUEIDENTIFIER = NULL,
	@InvoiceStatusName NVARCHAR(250) = NULL,
	@InvoiceStatusColor NVARCHAR(250) = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

            IF(@SearchText = '') SET @SearchText = NULL

            SET @SearchText = '%'+ @SearchText +'%';       
		          
            IF(@InvoiceStatusId = '00000000-0000-0000-0000-000000000000') SET @InvoiceStatusId = NULL
           
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

			SELECT Id AS InvoiceStatusId,
				   InvoiceStatusName,
				   InvoiceStatusColor,
				   CreatedDateTime,
				   [TimeStamp],
				   TotalCount = COUNT(1) OVER()
			FROM [InvoiceStatus] I
			WHERE (@SearchText IS NULL OR InvoiceStatusName LIKE @SearchText)
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND I.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND I.InactiveDateTime IS NULL))
				  AND I.CompanyId = @CompanyId
			ORDER BY I.InvoiceStatusName

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
