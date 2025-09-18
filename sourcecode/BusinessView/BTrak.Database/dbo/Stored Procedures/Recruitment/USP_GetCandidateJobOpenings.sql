--EXEC [dbo].[USP_GetCandidateJobOpenings] @OperationsPerformedBy='FB5D135E-D329-47D4-9DDB-D5A65D9542F3',@Email='ggg@rrr.rrr'
CREATE PROCEDURE [dbo].[USP_GetCandidateJobOpenings]
(
	@CandidateJobOpeningId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER = NULL,
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
    @AppliedDateTime DATETIME = NULL,
	@Email NVARCHAR(100) = NULL,
    @InterviewProcessId UNIQUEIDENTIFIER = NULL,
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

		   IF(@CandidateJobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @CandidateJobOpeningId = NULL

	       IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

		   IF(@InterviewProcessId = '00000000-0000-0000-0000-000000000000') SET  @InterviewProcessId = NULL

	       IF(@AppliedDateTime = '') SET  @AppliedDateTime = NULL
		   
		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateJobOpening])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateJobOpening]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CJO.Id AS CandidateJobOpeningId,
				  CJO.CandidateId,
				  C.FirstName + ISNULL(C.LastName,'') CandidateName,
				  CJO.JobOpeningId,
				  JO.JobOpeningTitle,
				  CJO.AppliedDateTime,
				  CJO.InterviewProcessId,
				  HS.[Status] AS HiringStatusName,
				  HS.[Color],
				  CJO.CreatedByUserId,
				  CJO.CreatedDateTime AS AppliedDate,
				  CJO.[TimeStamp]
		   FROM [dbo].[CandidateJobOpening] CJO WITH (NOLOCK)
		        INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CJO.CandidateId
				INNER JOIN JobOpening JO WITH (NOLOCK) ON JO.Id = CJO.JobOpeningId
				INNER JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId
		   WHERE (@CandidateJobOpeningId IS NULL OR CJO.Id = @CandidateJobOpeningId)
		   	     AND (@CandidateId IS NULL OR CJO.CandidateId = @CandidateId)
				 AND CJO.InActiveDateTime IS NULL
				 AND JO.InActiveDateTime IS NULL
				 AND C.InActiveDateTime IS NULL
				 AND (@Email IS NULL OR C.Email = @Email)
				 AND (@JobOpeningId IS NULL OR CJO.JobOpeningId = @JobOpeningId)
				 AND (@AppliedDateTime IS NULL OR CJO.AppliedDateTime = @AppliedDateTime)
				 AND (@InterviewProcessId IS NULL OR CJO.InterviewProcessId = @InterviewProcessId)
		   	     AND (@SearchText IS NULL OR (C.FirstName + ISNULL(C.LastName,'') LIKE @SearchText)
				                          OR (JO.JobOpeningTitle LIKE @SearchText)
										  OR (CJO.AppliedDateTime LIKE @SearchText)
										  OR ( HS.[Status] LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		   	    WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
				WHEN @SortBy = 'AppliedDateTime' THEN CJO.AppliedDateTime
				WHEN @SortBy = 'InterviewStatus' THEN  HS.[Status]
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CJO.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		   	    WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
				WHEN @SortBy = 'AppliedDateTime' THEN CJO.AppliedDateTime
				WHEN @SortBy = 'InterviewStatus' THEN  HS.[Status]
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CJO.CreatedDateTime,121) AS sql_variant)
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