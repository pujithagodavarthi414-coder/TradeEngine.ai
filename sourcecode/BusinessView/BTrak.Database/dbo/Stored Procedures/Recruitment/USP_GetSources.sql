CREATE PROCEDURE [dbo].[USP_GetSources]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @Name NVARCHAR(50) = NULL,
	@IsReferenceNumberNeeded INT = NULL,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@SourceId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@SourceId = '00000000-0000-0000-0000-000000000000') SET @SourceId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT JS.Id AS SourceId,
		   	      JS.CompanyId,
				  JS.[Name],
		   	      JS.[IsReferenceNumberNeeded],
		   	      JS.InActiveDateTime,
		   	      JS.CreatedDateTime ,
		   	      JS.CreatedByUserId,
		   	      JS.[TimeStamp],
				  (CASE WHEN JS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM Source AS JS		        
           WHERE JS.CompanyId = @CompanyId
				AND (@Name IS NULL OR JS.[Name] = @Name)
		        AND (@SearchText IS NULL OR (JS.[Name] LIKE  @SearchText))
		   	    AND (@SourceId IS NULL OR JS.Id = @SourceId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND JS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND JS.InActiveDateTime IS NULL))	
           ORDER BY JS.CreatedDateTime DESC

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