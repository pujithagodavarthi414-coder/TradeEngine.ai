CREATE PROCEDURE [dbo].[USP_GetHtmlTemplate]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@HtmlTemplateId UNIQUEIDENTIFIER = NULL,	
	@SearchText  NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL,
	@CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText = '') SET @SearchText = NULL

		   SET @SearchText = '%'+ @SearchText +'%'
		   
		   IF(@HtmlTemplateId = '00000000-0000-0000-0000-000000000000') SET @HtmlTemplateId = NULL		  
		   
           SELECT HT.Id AS HtmlTemplateId,
		   	      HT.TemplateName AS HtmlTemplateName,
		   	      HT.HtmlTemplate,
		   	      HT.InActiveDateTime,
		   	      HT.CreatedDateTime ,
		   	      HT.CreatedByUserId,
				  TC.Mails,
				  CASE WHEN HT.CompanyId IS NULL THEN 0 ELSE 1 END AS IsEditable,
				  TC.Roles AS Roles,
				  STUFF((SELECT ',' + RoleName FROM [Role] 
				         WHERE Id IN (SELECT CONVERT(UNIQUEIDENTIFIER,Id) FROM dbo.UfnSplit(TC.Roles)) FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS selectedRoleNames,
		   	      HT.[TimeStamp],
				  HT.IsConfigurable,
				  CASE WHEN HT.CompanyId IS NULL THEN 1 ELSE 0 END AS IsMaster,
				  CASE WHEN TC.Roles IS NOT NULL THEN 1 ELSE 0 END AS IsRoleBased,
				  CASE WHEN TC.Mails IS NOT NULL THEN 1 ELSE 0 END AS IsMailBased,
				  (CASE WHEN HT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM [HtmlTemplates] AS HT	 
				LEFT JOIN [TemplateConfiguration] TC ON TC.HtmlTemplateId = HT.Id AND TC.CompanyId = @CompanyId
           WHERE (@SearchText IS NULL OR (HT.TemplateName LIKE  '%'+ @SearchText +'%') OR (HT.HtmlTemplate LIKE  '%'+ @SearchText +'%'))
		   	    AND (@HtmlTemplateId IS NULL OR HT.Id = @HtmlTemplateId)
				AND (HT.CompanyId = @CompanyId OR HT.CompanyId IS NULL)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND HT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND HT.InActiveDateTime IS NULL))
		   	    
           ORDER BY HT.TemplateName ASC

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