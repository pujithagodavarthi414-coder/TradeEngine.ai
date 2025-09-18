-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllEmailTemplates] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllEmailTemplates]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@ClientId UNIQUEIDENTIFIER = NULL,
	@EmailTemplateId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@EmailTemplateName NVARCHAR(250) = NULL,
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

		   IF(@EmailTemplateId = '00000000-0000-0000-0000-000000000000') SET @EmailTemplateId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT EM.Id AS EmailTemplateId,
		   	      EM.EmailTemplateName,
		   	      EM.EmailTemplate,
		   	      EM.EmailSubject,
		   	      EM.ClientId,
		   	      EM.InActiveDateTime,
		   	      EM.CreatedDateTime,
		   	      EM.CreatedByUserId,
				  EM.EmailTemplateReferenceId,
		   	      EM.[TimeStamp],
				  CASE WHEN EM.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [EmailTemplates] AS EM
           WHERE EM.CompanyId = @CompanyId AND( EM.ClientId = @ClientId OR @ClientId IS NULL)
		       AND (@EmailTemplateName IS NULL OR (EM.EmailTemplateName = @EmailTemplateName))
		   	   AND (@EmailTemplateId IS NULL OR EM.Id = @EmailTemplateId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EM.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EM.InActiveDateTime IS NULL))
           ORDER BY EM.EmailTemplateName ASC

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

