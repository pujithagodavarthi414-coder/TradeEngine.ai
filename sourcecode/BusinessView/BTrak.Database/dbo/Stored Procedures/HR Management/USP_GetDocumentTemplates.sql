CREATE PROCEDURE [dbo].[USP_GetDocumentTemplates]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @DocumentTemplateId UNIQUEIDENTIFIER = NULL,    
    @DocumentTemplateName NVARCHAR(800) = NULL,    
    @IsArchived BIT= NULL    
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@DocumentTemplateId = '00000000-0000-0000-0000-000000000000') SET @DocumentTemplateId = NULL   
		   
           IF(@DocumentTemplateName = '') SET @DocumentTemplateName = NULL    
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
           SELECT DT.Id AS HtmlTemplateId,
                     DT.TemplateName,
                     DT.TemplatePath,
                     DT.InActiveDateTime,
                     DT.CreatedDateTime ,
                     DT.CreatedByUserId,
                     DT.[TimeStamp],
                  (CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,    
                     TotalCount = COUNT(*) OVER()
           FROM [DocumentTemplates] AS DT            
           WHERE (@DocumentTemplateId IS NULL OR DT.Id = @documentTemplateId)
                AND (@DocumentTemplateName IS NULL OR DT.TemplateName = @DocumentTemplateName)
                AND DT.CompanyId = @CompanyId
                AND (@IsArchived IS NULL OR (@IsArchived = 1 AND DT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND DT.InActiveDateTime IS NULL))
           ORDER BY DT.TemplateName ASC

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
