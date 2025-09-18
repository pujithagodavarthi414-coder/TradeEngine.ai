CREATE PROCEDURE [dbo].[USP_SearchCandidateInterviewSchedules]
(
	@CandidateInterviewScheduleId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER,
	@CandidateId UNIQUEIDENTIFIER,
	@StartTime DATETIME = NULL,
	@EndTime DATETIME = NULL,
	@InterviewDate DATETIME = NULL,
	@IsConfirmed BIT = NULL,
	@IsCancelled BIT = NULL,
	@IsRescheduled BIT = NULL,
	@ScheduleComments NVARCHAR(MAX) = NULL,
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

		   IF(@CandidateInterviewScheduleId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewScheduleId = NULL

	       IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

	       IF(@StartTime = '') SET  @StartTime = NULL

		   IF(@EndTime = '') SET  @EndTime = NULL

		   IF(@InterviewDate = '') SET  @InterviewDate = NULL

		   IF(@IsConfirmed = '') SET  @IsConfirmed = NULL

		   IF(@IsCancelled = '') SET  @IsCancelled = NULL

		   IF(@IsRescheduled = '') SET  @IsRescheduled = NULL

		   IF(@ScheduleComments = '') SET  @ScheduleComments = NULL

		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateInterviewSchedule])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateInterviewSchedule]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CIS.Id AS CandidateInterviewScheduleId,
				  CIS.InterviewTypeId,
				  IT.InterviewTypeName,
				  CIS.CandidateId,
				  C.FirstName + ' ' +ISNULL(C.LastName,'') CandidateName,
				  convert(char(5), CIS.StartTime, 108) AS StartTime,
				  convert(char(5), CIS.EndTime, 108) AS EndTime,
				  CIS.InterviewDate,
				  CIS.IsConfirmed,
				  CIS.IsCancelled,
				  CIS.IsRescheduled,
				  CIS.ScheduleComments,
				  CIS.CreatedByUserId,
				  CIS.CreatedDateTime,
				  CIS.[TimeStamp],
				  CIS.[Assignee],
				  AssigneeIds = (STUFF((SELECT ',' + LOWER(CAST(U.Id AS NVARCHAR(MAX))) [text()]
				  FROM CandidateInterviewScheduleAssignee CISA 
				  INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				  WHERE CISA.CandidateInterviewScheduleId = CIS.Id 
						AND CISA.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))		   
				  ,AssigneeNames = (STUFF((SELECT ',' + LOWER(CAST(U.FirstName +' ' + ISNULL(U.SurName,'') AS NVARCHAR(MAX))) [text()]
				  FROM CandidateInterviewScheduleAssignee CISA 
				  INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				  WHERE CISA.CandidateInterviewScheduleId = CIS.Id 
						AND CISA.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				CX.CronExpression,
				CX.TimeStamp AS CronExpressionTimeStamp,
				CX.Id AS CronExpressionId,
				CX.JobId,
				CX.EndDate AS ScheduleEndDate,
				CX.IsPaused
		   FROM [dbo].[CandidateInterviewSchedule] CIS WITH (NOLOCK)
		        INNER JOIN InterviewType IT WITH (NOLOCK) ON IT.Id = CIS.InterviewTypeId
				INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CIS.CandidateId
				LEFT JOIN CronExpression CX ON CX.CustomWidgetId = C.Id AND CX.ResponsibleUserId = CIS.Id
		   WHERE (@CandidateInterviewScheduleId IS NULL OR CIS.Id = @CandidateInterviewScheduleId)
		   	     AND (@InterviewTypeId IS NULL OR CIS.InterviewTypeId = @InterviewTypeId)
				 AND (@CandidateId IS NULL OR CIS.CandidateId = @CandidateId)
				 AND (@IsConfirmed IS NULL OR CIS.IsConfirmed = @IsConfirmed)
				 AND (@IsCancelled IS NULL OR CIS.IsCancelled = @IsCancelled)
				 AND (@IsRescheduled IS NULL OR CIS.IsRescheduled = @IsRescheduled)
		   	     AND (@SearchText IS NULL OR (IT.InterviewTypeName LIKE @SearchText)
				                          OR (C.FirstName + ISNULL(C.LastName,'') LIKE @SearchText)
										  OR (CIS.IsConfirmed LIKE @SearchText)
										  OR (CIS.IsCancelled LIKE @SearchText)
										  OR (CIS.IsRescheduled LIKE @SearchText)
										)
				AND CIS.InActiveDateTime IS NULL
				AND CIS.IsCancelled <> 1
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
				WHEN @SortBy = 'ScheduleComments' THEN  CAST(CIS.ScheduleComments AS NVARCHAR(1000))
				WHEN @SortBy = 'StartTime' THEN CAST(CONVERT(DATETIME,CIS.StartTime,121) AS sql_variant)
				WHEN @SortBy = 'EndTime' THEN CAST(CONVERT(DATETIME,CIS.EndTime,121) AS sql_variant)
				WHEN @SortBy = 'InterviewDate' THEN CAST(CONVERT(DATETIME,CIS.InterviewDate,121) AS sql_variant)
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CIS.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'IsConfirmed' THEN CIS.IsConfirmed
		        WHEN @SortBy = 'IsCancelled' THEN CIS.IsCancelled
		        WHEN @SortBy = 'IsRescheduled' THEN CIS.IsRescheduled
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
				WHEN @SortBy = 'ScheduleComments' THEN CAST(CIS.ScheduleComments AS NVARCHAR(1000))
				WHEN @SortBy = 'StartTime' THEN CAST(CONVERT(DATETIME,CIS.StartTime,121) AS sql_variant)
				WHEN @SortBy = 'EndTime' THEN CAST(CONVERT(DATETIME,CIS.EndTime,121) AS sql_variant)
				WHEN @SortBy = 'InterviewDate' THEN CAST(CONVERT(DATETIME,CIS.InterviewDate,121) AS sql_variant)
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CIS.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'IsConfirmed' THEN CIS.IsConfirmed
		        WHEN @SortBy = 'IsCancelled' THEN CIS.IsCancelled
		        WHEN @SortBy = 'IsRescheduled' THEN CIS.IsRescheduled
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
