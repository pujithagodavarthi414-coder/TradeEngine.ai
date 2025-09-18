CREATE PROCEDURE [dbo].[USP_GetCandidateInterviewScheduleAssignees]
(
	@CandidateInterviewScheduleAssigneeId UNIQUEIDENTIFIER = NULL,
	@AssignToUserId UNIQUEIDENTIFIER = NULL,
	@CandidateInterviewScheduleId UNIQUEIDENTIFIER = NULL,
	@IsApproved BIT = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@IsArchived BIT = NULL,
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

		   IF(@CandidateInterviewScheduleAssigneeId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewScheduleAssigneeId = NULL

	       IF(@AssignToUserId = '00000000-0000-0000-0000-000000000000') SET  @AssignToUserId = NULL

		   IF(@CandidateInterviewScheduleId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewScheduleId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateInterviewScheduleAssignee])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateInterviewScheduleAssignee]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   IF(@IsArchived IS NULL) SET @IsArchived = 0

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CISA.Id AS CandidateInterviewScheduleAssigneeId,
				  CISA.AssignToUserId,
				  U.FirstName + ISNULL(U.SurName,'') AssignToUserName,
				  CISA.CandidateInterviewScheduleId,
				  CISA.[IsApproved],
				  CISA.CreatedByUserId,
				  CISA.CreatedDateTime,
				  CISA.[TimeStamp],
				  convert(char(5), CIS.StartTime, 108) AS StartTime,
				  convert(char(5), CIS.EndTime, 108) AS EndTime,
				  CIS.InterviewDate,
				  IT.InterviewTypeName,
				  U.UserName,
				CX.CronExpression,
				CX.TimeStamp AS CronExpressionTimeStamp,
				CX.Id AS CronExpressionId,
				CX.JobId,
				CX.EndDate AS ScheduleEndDate,
				CX.IsPaused,
				C.Email AS CandidateEmail,
				IT.IsVideoCalling
		   FROM [dbo].[CandidateInterviewScheduleAssignee] CISA WITH (NOLOCK)
		        INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				INNER JOIN CandidateInterviewSchedule CIS WITH (NOLOCK) ON CIS.Id = CISA.CandidateInterviewScheduleId
				LEFT JOIN [Candidate] C WITH (NOLOCK) ON C.Id = CIS.CandidateId AND C.InActiveDateTime IS NULL
				LEFT JOIN CronExpression CX ON CX.CustomWidgetId = CISA.AssignToUserId AND CX.ResponsibleUserId = CISA.CandidateInterviewScheduleId
				LEFT JOIN InterviewType IT ON  IT.Id = CIS.InterviewTypeId
		   WHERE (@CandidateInterviewScheduleAssigneeId IS NULL OR CISA.Id = @CandidateInterviewScheduleAssigneeId)
		   	     AND (@AssignToUserId IS NULL OR CISA.AssignToUserId = @AssignToUserId)
				 AND (@CandidateInterviewScheduleId IS NULL OR CISA.CandidateInterviewScheduleId = @CandidateInterviewScheduleId)
				 AND (@IsApproved IS NULL OR CISA.[IsApproved] = @IsApproved)
		   	     AND (@SearchText IS NULL OR (U.FirstName + ISNULL(U.SurName,'') LIKE @SearchText)
										  OR (CISA.[IsApproved] LIKE @SearchText)
										)
				 AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND CISA.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND CISA.InActiveDateTime IS NULL))
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'AssignToUserName' THEN U.FirstName + ISNULL(U.SurName,'')
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CISA.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'IsApproved' THEN CISA.[IsApproved]
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'AssignToUserName' THEN U.FirstName + ISNULL(U.SurName,'')
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CISA.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'IsApproved' THEN CISA.[IsApproved]
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
