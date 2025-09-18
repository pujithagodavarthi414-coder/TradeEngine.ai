----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-04 00:00:00.000'
-- Purpose      To Get Invoice Projects by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceProjects] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceProjectId = 'F36FA51F-BF67-477D-A82C-485130BBE05E'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceProjects]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @InvoiceProjectId UNIQUEIDENTIFIER = NULL,
	@InvoiceId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@SearchText = '') SET @SearchText = NULL

		   SET @SearchText = '%'+ @SearchText +'%';              

           IF(@InvoiceProjectId = '00000000-0000-0000-0000-000000000000') SET @InvoiceProjectId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT IP.Id AS InvoiceProjectId,
				  IP.InvoiceId,
				  IP.ProjectId,	
				  P.ProjectName,
				  IP.CreatedDateTime,
                  IP.CreatedByUserId,
				  IP.UpdatedDateTime,
				  IP.UpdatedByUserId,
				  IP.InActiveDateTime,
                  IP.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM InvoiceProjects AS IP
		   INNER JOIN Invoice_New I ON I.Id = IP.InvoiceId
		   INNER JOIN Project P ON P.Id = IP.ProjectId
           WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND IP.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND IP.InactiveDateTime IS NULL))
                AND IP.CompanyId = @CompanyId AND I.CompanyId = @CompanyId AND P.CompanyId = @Companyid
				AND (@InvoiceProjectId IS NULL OR IP.Id = @InvoiceProjectId)
				AND (@InvoiceId IS NULL OR IP.InvoiceId = @InvoiceId)
				AND (@SearchText IS NULL OR (P.ProjectName LIKE @SearchText ))
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
