-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllClientTemplateConfiguration] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllClientTemplateConfiguration]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TemplateConfigurationId UNIQUEIDENTIFIER = NULL,	
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

		   IF(@TemplateConfigurationId = '00000000-0000-0000-0000-000000000000') SET @TemplateConfigurationId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CTC.Id AS TemplateConfigurationId,
		   	      CTC.TemplateConfigurationName,
		   	      CTC.TemplateConfiguration,
		   	      CTC.ContractTypeIds,
		   	      CTC.InActiveDateTime,
		   	      CTC.CreatedDateTime,
		   	      CTC.CreatedByUserId,
		   	      CTC.[TimeStamp],
				  CASE WHEN CTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM ClientTemplateConfiguration AS CTC
           WHERE CTC.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (CTC.TemplateConfigurationName LIKE @SearchText))
		   	   AND (@TemplateConfigurationId IS NULL OR CTC.Id = @TemplateConfigurationId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CTC.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CTC.InActiveDateTime IS NULL))
           ORDER BY CTC.TemplateConfigurationName ASC

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

