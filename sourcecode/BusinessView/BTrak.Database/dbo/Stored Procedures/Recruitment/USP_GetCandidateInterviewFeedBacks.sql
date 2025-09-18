CREATE PROCEDURE [dbo].[USP_GetCandidateInterviewFeedBacks]
(
	@CandidateInterviewFeedBackId UNIQUEIDENTIFIER = NULL,
	@CandidateInterviewScheduleId UNIQUEIDENTIFIER,
	@InterviewRatingId UNIQUEIDENTIFIER=NULL,
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

		   IF(@CandidateInterviewFeedBackId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewFeedBackId = NULL

	       IF(@CandidateInterviewScheduleId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewScheduleId = NULL

		   IF(@InterviewRatingId = '00000000-0000-0000-0000-000000000000') SET  @InterviewRatingId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateInterviewFeedBack])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateInterviewFeedBack]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CIF.Id AS CandidateInterviewFeedBackId,
				  CIF.CandidateInterviewScheduleId,
				  CIF.InterviewRatingId,
				  IR.InterviewRatingName,
				  CIF.CreatedByUserId,
				  CIF.CreatedDateTime,
				  CIF.[TimeStamp]
		   FROM [dbo].[CandidateInterviewFeedBack] CIF WITH (NOLOCK)
		        INNER JOIN CandidateInterviewSchedule CIS WITH (NOLOCK) ON CIS.Id = CIF.CandidateInterviewScheduleId
				INNER JOIN InterviewRating IR WITH (NOLOCK) ON IR.Id = CIF.InterviewRatingId
		   WHERE (@CandidateInterviewFeedBackId IS NULL OR CIF.Id = @CandidateInterviewFeedBackId)
		   	     AND (@CandidateInterviewScheduleId IS NULL OR CIF.CandidateInterviewScheduleId = @CandidateInterviewScheduleId)
				 AND (@InterviewRatingId IS NULL OR CIF.InterviewRatingId = @InterviewRatingId)
		   	     AND (@SearchText IS NULL OR (IR.InterviewRatingName LIKE @SearchText)
				 AND CIF.CreatedByUserId = @OperationsPerformedBy
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewRatingName' THEN IR.InterviewRatingName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CIF.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewRatingName' THEN IR.InterviewRatingName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CIF.CreatedDateTime,121) AS sql_variant)
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
