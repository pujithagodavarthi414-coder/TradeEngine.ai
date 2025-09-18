CREATE PROCEDURE [dbo].[USP_GetCandidateDocuments]
(
	@CandidateDocumentId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER = null,
	@DocumentTypeId UNIQUEIDENTIFIER = NULL,
	@Document NVARCHAR(500) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @IsArchived BIT = NULL,
	@IsResume BIT = NULL,
	@PageSize INT = NULL,
    @PageNumber INT = NULL,
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

		IF(@PageNumber IS NULL)
			SET @PageNumber=1
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@CandidateDocumentId = '00000000-0000-0000-0000-000000000000') SET  @CandidateDocumentId = NULL

	       IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@DocumentTypeId = '00000000-0000-0000-0000-000000000000') SET  @DocumentTypeId = NULL

	       IF(@Document = '') SET  @Document = NULL

		   IF(@Description = '') SET  @Description = NULL

		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateDocuments])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateDocuments]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CD.Id AS CandidateDocumentId,
				  CD.CandidateId,
				  C.FirstName + ISNULL(C.LastName,'') CandidateName,
				  CD.DocumentTypeId,
				  DT.DocumentTypeName,
				  CD.Document,
				  CD.[Description],
				  CD.CreatedByUserId,
				  CD.CreatedDateTime,
				  CD.IsResume,
				  CD.[TimeStamp]
		   FROM [dbo].[CandidateDocuments] CD WITH (NOLOCK)
		        INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CD.CandidateId
				LEFT JOIN DocumentType DT WITH (NOLOCK) ON DT.Id = CD.DocumentTypeId
		   WHERE (@CandidateDocumentId IS NULL OR CD.Id = @CandidateDocumentId)
		   	     AND (@CandidateId IS NULL OR CD.CandidateId = @CandidateId)
				 AND (@DocumentTypeId IS NULL OR CD.DocumentTypeId = @DocumentTypeId)
				 AND (@Document IS NULL OR CD.Document = @Document)
				 AND (@IsResume IS NULL OR CD.IsResume = @IsResume)
				 AND (@Description IS NULL OR CD.[Description] = @Description)
		   	     AND (@SearchText IS NULL OR (C.FirstName + ISNULL(C.LastName,'') LIKE @SearchText)
				                          OR (DT.DocumentTypeName LIKE @SearchText)
										  OR (CD.Document LIKE @SearchText)
										  OR (CD.[Description] LIKE @SearchText)
										)
										AND ((@IsArchived IS NULL AND CD.InActiveDateTime IS NULL) OR (@IsArchived = 1 
										AND CD.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CD.InActiveDateTime IS NULL))
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		   	    WHEN @SortBy = 'DocumentTypeName' THEN DT.DocumentTypeName
				WHEN @SortBy = 'Document' THEN CD.Document
				WHEN @SortBy = 'Description' THEN CAST(CD.[Description] AS NVARCHAR(1000))
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CD.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		   	    WHEN @SortBy = 'DocumentTypeName' THEN DT.DocumentTypeName
				WHEN @SortBy = 'Document' THEN CD.Document
				WHEN @SortBy = 'Description' THEN CAST(CD.[Description] AS NVARCHAR(1000))
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CD.CreatedDateTime,121) AS sql_variant)
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
