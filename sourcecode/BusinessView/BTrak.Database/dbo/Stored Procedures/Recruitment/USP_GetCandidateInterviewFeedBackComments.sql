CREATE PROCEDURE [dbo].[USP_GetCandidateInterviewFeedBackComments]
(
	@CandidateInterviewFeedBackCommentsId UNIQUEIDENTIFIER = NULL,
	@AssigneeId UNIQUEIDENTIFIER = NULL,
	@CandidateInterviewScheduleId UNIQUEIDENTIFIER,
	@AssigneeComments NVARCHAR(MAX) = NULL,
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

		   IF(@CandidateInterviewFeedBackCommentsId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewFeedBackCommentsId = NULL

	       IF(@AssigneeId = '00000000-0000-0000-0000-000000000000') SET  @AssigneeId = NULL

		   IF(@CandidateInterviewScheduleId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewScheduleId = NULL

	       IF(@AssigneeComments = '') SET  @AssigneeComments = NULL
		   
		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateInterviewFeedBackComments])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateInterviewFeedBackComments]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CISA.Id AS CandidateInterviewFeedBackCommentsId,
				  CISA.AssigneeId,
				  U.FirstName + ISNULL(U.SurName,'') AssignToUserName,
				  U.ProfileImage,
				  CISA.CandidateInterviewScheduleId,
				  CISA.AssigneeComments,
				  CISA.CreatedByUserId,
				  CISA.CreatedDateTime,
				  CISA.[TimeStamp]
		   FROM [dbo].[CandidateInterviewFeedBackComments] CISA WITH (NOLOCK)
		        INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssigneeId
				INNER JOIN CandidateInterviewSchedule CIS WITH (NOLOCK) ON CIS.Id = CISA.CandidateInterviewScheduleId
		   WHERE (@CandidateInterviewFeedBackCommentsId IS NULL OR CISA.Id = @CandidateInterviewFeedBackCommentsId)
		   	     AND (@AssigneeId IS NULL OR CISA.AssigneeId = @AssigneeId)
				 AND (@CandidateInterviewScheduleId IS NULL OR CISA.CandidateInterviewScheduleId = @CandidateInterviewScheduleId)
				 AND (@AssigneeComments IS NULL OR CISA.AssigneeComments = @AssigneeComments)
		   	     AND (@SearchText IS NULL OR (U.FirstName + ISNULL(U.SurName,'') LIKE @SearchText)
										  OR (CISA.AssigneeComments LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'AssignToUserName' THEN U.FirstName + ISNULL(U.SurName,'')
				WHEN @SortBy = 'ScheduleComments' THEN CAST(CISA.AssigneeComments AS NVARCHAR(1000))
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CISA.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'AssignToUserName' THEN U.FirstName + ISNULL(U.SurName,'')
		        WHEN @SortBy = 'ScheduleComments' THEN CAST(CISA.AssigneeComments AS NVARCHAR(1000))
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CISA.CreatedDateTime,121) AS sql_variant)
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
