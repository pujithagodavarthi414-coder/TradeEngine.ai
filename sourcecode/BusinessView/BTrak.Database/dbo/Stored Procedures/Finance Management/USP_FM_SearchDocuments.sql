-------------------------------------------------------------------------------------------------------------------
----EXEC USP_FM_SearchDocuments @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'FC361D23-F317-4704-B86F-0D6E7287EEE9'
-------------------------------------------------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[USP_FM_SearchDocuments]
--(
--  @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
--  @ReferenceId UNIQUEIDENTIFIER = NULL,
--  @SearchText NVARCHAR(500) = NULL,
--  @SortBy NVARCHAR(100) = NULL,
--  @SortDirection NVARCHAR(50)=NULL,
--  @PageSize INT = NULL,
--  @PageNumber INT = NULL,
--  @OperationsPerformedBy UNIQUEIDENTIFIER,		
--  @FeatureId UNIQUEIDENTIFIER,
--  @IsArchived BIT = NULL
--)
--AS
--BEGIN
--     SET NOCOUNT ON
--     BEGIN TRY
	       
--		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		   
--           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

--		   IF (@HavePermission = '1')
--		   BEGIN

--		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

--		       IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

--			   IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL
		       
--	           IF(@SearchText = '') SET  @SearchText = NULL
		     
--			   SET @SearchText = '%'+ @SearchText +'%'

--		       IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		     
--		       IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		     
--		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [DocumentSet])

--			   IF(@PageSize = 0) SET @PageSize = 10
		     
--		       IF(@PageNumber IS NULL) SET @PageNumber = 1
	            
--			   SELECT DS.[OriginalId] AS DocumentSetId,
--			          DS.[FileId],
--			   	      UF.[FileName],
--			   	      UF.[FilePath],
--			   	      UF.[FileExtension],
--			   	      UF.[FileSize],
--		              TotalCount = COUNT(1) OVER()
--		       FROM  [dbo].[DocumentSet] DS WITH (NOLOCK)
--			         JOIN UploadFile UF WITH (NOLOCK) ON UF.OriginalId = DS.FileId AND UF.InActiveDateTime IS NULL AND UF.AsAtInactiveDateTime IS NULL
--					 JOIN ReferenceType RT WITH (NOLOCK) ON RT.OriginalId = DS.ReferenceTypeId AND RT.InActiveDateTime IS NULL AND RT.AsAtInactiveDateTime IS NULL
--		       WHERE RT.CompanyId = @CompanyId
--					 AND (@IsArchived IS NULL 
--					      OR (@IsArchived = 1 AND DS.InActiveDateTime IS NOT NULL)
--						  OR (@IsArchived = 0 AND DS.InActiveDateTime IS NULL))
--					 AND (DS.AsAtInactiveDateTime IS NULL) 
--				     AND (@ReferenceTypeId IS NULL OR DS.ReferenceTypeId = @ReferenceTypeId)
--					 AND (@ReferenceId IS NULL OR DS.ReferenceId = @ReferenceId) 
--		             AND (@SearchText IS NULL 
--					      OR (UF.[FileName] LIKE @SearchText))
--		      ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
--		  	  			CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,DS.CreatedDateTime,121) AS sql_variant)
--		  	  			     WHEN @SortBy = 'FileName' THEN  UF.[FileName]
--		  	  			END
--		  	  	  END ASC,
--		  	  	  CASE WHEN @SortDirection = 'DESC' THEN
--		  	  			CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,DS.CreatedDateTime,121) AS sql_variant)
--		  	  			     WHEN @SortBy = 'FileName' THEN  UF.[FileName]
--		  	  			END
--		  	  	  END DESC
--		     OFFSET ((@PageNumber - 1) * @PageSize) ROWS
--		     FETCH NEXT @PageSize Rows ONLY 	

--		  END
--		  ELSE
--			RAISERROR (@HavePermission,11, 1)
		   
--	 END TRY  
--	 BEGIN CATCH 
		
--		  EXEC [dbo].[USP_GetErrorInformation]

--	END CATCH

--END
--GO