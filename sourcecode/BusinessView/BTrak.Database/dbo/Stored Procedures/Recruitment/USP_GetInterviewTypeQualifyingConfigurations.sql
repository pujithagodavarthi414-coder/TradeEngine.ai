CREATE PROCEDURE [dbo].[USP_GetInterviewTypeQualifyingConfigurations]
(
	@InterviewTypeQualifyingConfigurationId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER,
	@InterviewRatingId UNIQUEIDENTIFIER,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
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

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@InterviewTypeQualifyingConfigurationId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeQualifyingConfigurationId = NULL

	       IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@InterviewRatingId = '00000000-0000-0000-0000-000000000000') SET  @InterviewRatingId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [InterviewTypeQualifyingConfiguration])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [InterviewTypeQualifyingConfiguration]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT ITQC.Id AS InterviewTypeQualifyingConfigurationId,
				  ITQC.InterviewTypeId,
				  IT.InterviewTypeName,
				  ITQC.InterviewRatingId,
				  IR.InterviewRatingName,
				  ITQC.CreatedByUserId,
				  ITQC.CreatedDateTime,
				  ITQC.[TimeStamp]
		   FROM [dbo].[InterviewTypeQualifyingConfiguration] ITQC WITH (NOLOCK)
		        INNER JOIN InterviewType IT WITH (NOLOCK) ON IT.Id = ITQC.InterviewTypeId
				INNER JOIN InterviewRating IR WITH (NOLOCK) ON IR.Id = ITQC.InterviewRatingId
		   WHERE (@InterviewTypeQualifyingConfigurationId IS NULL OR ITQC.Id = @InterviewTypeQualifyingConfigurationId)
		   	     AND (@InterviewTypeId IS NULL OR ITQC.InterviewTypeId = @InterviewTypeId)
				 AND (@InterviewRatingId IS NULL OR ITQC.InterviewRatingId = @InterviewRatingId)
		   	     AND (@SearchText IS NULL OR (IT.InterviewTypeName LIKE @SearchText)
				                          OR (IR.InterviewRatingName LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'InterviewRatingName' THEN IR.InterviewRatingName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,ITQC.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'InterviewRatingName' THEN IR.InterviewRatingName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,ITQC.CreatedDateTime,121) AS sql_variant)
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
