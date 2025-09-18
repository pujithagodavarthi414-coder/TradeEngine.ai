CREATE PROCEDURE [dbo].[USP_GetInterviewRatings]
(
	@InterviewRatingId UNIQUEIDENTIFIER = NULL,
	@InterviewRatingName NVARCHAR(250) = NULL,
	@Value FLOAT = NULL,
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

	       IF(@InterviewRatingId = '00000000-0000-0000-0000-000000000000') SET  @InterviewRatingId = NULL

		   IF(@InterviewRatingName = '') SET  @InterviewRatingName = NULL

	       IF(@Value = '') SET  @Value = NULL
		   
		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [InterviewRating])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [InterviewRating]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT IR.Id AS InterviewRatingId,
				  IR.InterviewRatingName,
				  IR.[Value],
				  IR.CreatedByUserId,
				  IR.CreatedDateTime,
				  IR.[TimeStamp]
		   FROM [dbo].[InterviewRating] IR WITH (NOLOCK)
		   WHERE (@InterviewRatingId IS NULL OR IR.Id = @InterviewRatingId)
		   	     AND (@InterviewRatingName IS NULL OR IR.InterviewRatingName = @InterviewRatingName)
				 AND (@Value IS NULL OR IR.[Value] = @Value)
		   	     AND (@SearchText IS NULL OR (IR.InterviewRatingName LIKE @SearchText))
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND IR.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND IR.InActiveDateTime IS NULL))	
				 AND IR.CompanyId = @CompanyId
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewRatingName' THEN IR.InterviewRatingName
		   	    WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IR.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'Value' THEN IR.[Value]
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewRatingName' THEN IR.InterviewRatingName
		   	 	WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IR.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'Value' THEN IR.[Value]
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
