CREATE PROCEDURE [dbo].[USP_GetDocumentTypes]
(
	@DocumentTypeId UNIQUEIDENTIFIER = NULL,
	@DocumentTypeName NVARCHAR(500) = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@IsArchived BIT= NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
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

		   IF(@DocumentTypeId = '00000000-0000-0000-0000-000000000000') SET  @DocumentTypeId = NULL

	       IF(@DocumentTypeName = '') SET  @DocumentTypeName = NULL
		   
		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [DocumentType])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [DocumentType]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT DT.Id AS DocumentTypeId,
				  DT.DocumentTypeName,
				  DT.CreatedByUserId,
				  DT.CreatedDateTime,
				  DT.[TimeStamp]
		   FROM [dbo].[DocumentType] DT WITH (NOLOCK)
		   WHERE (@DocumentTypeId IS NULL OR DT.Id = @DocumentTypeId)
		   	     AND (@DocumentTypeName IS NULL OR DT.DocumentTypeName = @DocumentTypeName)
		   	     AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND DT.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND DT.InActiveDateTime IS NULL))	
				 AND (@SearchText IS NULL OR (DT.DocumentTypeName LIKE @SearchText)
										)
				AND DT.CompanyId = @CompanyId
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'DocumentTypeName' THEN DT.DocumentTypeName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,DT.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'DocumentTypeName' THEN DT.DocumentTypeName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,DT.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC
		   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize Rows ONLY

	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO
