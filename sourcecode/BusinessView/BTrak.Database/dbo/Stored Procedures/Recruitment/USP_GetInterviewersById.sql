CREATE PROCEDURE [dbo].[USP_GetInterviewersById]
(
	@CandidateInterviewScheduleId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER = NULL,
	@InterviwerId UNIQUEIDENTIFIER = NULL,
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

	DECLARE @HavePermission NVARCHAR(250)  = 1-- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@CandidateInterviewScheduleId = '00000000-0000-0000-0000-000000000000') SET  @CandidateInterviewScheduleId = NULL

	       IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL
		   
		   IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateInterviewSchedule])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateInterviewSchedule]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT  U.FirstName + ' ' +ISNULL(U.SurName,'') AssigneeNames,
				  CIS.IsConfirmed,
				  CIS.IsCancelled,
				  U.Id as Assignee,
				  TotalCount = COUNT(1) OVER(),
				  @PageSize AS PageSize,
				  @PageNumber AS PageNumber
				  --AssigneeIds = (STUFF((SELECT ',' + LOWER(CAST(U.Id AS NVARCHAR(MAX))) [text()]
				  --FROM CandidateInterviewScheduleAssignee CISA 
				  --INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				  --WHERE CISA.CandidateInterviewScheduleId = CIS.Id 
						--AND CISA.InActiveDateTime IS NULL
				  --FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))		   
				  --,AssigneeNames = (STUFF((SELECT ',' + LOWER(CAST(U.FirstName +' ' + ISNULL(U.SurName,'') AS NVARCHAR(MAX))) [text()]
				  --FROM CandidateInterviewScheduleAssignee CISA 
				  --INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				  --WHERE CISA.CandidateInterviewScheduleId = CIS.Id 
						--AND CISA.InActiveDateTime IS NULL
				  --FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
		   FROM [dbo].[CandidateInterviewSchedule] CIS WITH (NOLOCK)
				JOIN CandidateInterviewScheduleAssignee CISA WITH (NOLOCK) ON  CIS.Id = CISA.CandidateInterviewScheduleId
		        INNER JOIN InterviewType IT WITH (NOLOCK) ON IT.Id = CIS.InterviewTypeId
				INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CIS.CandidateId
				INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
		   WHERE (@CandidateInterviewScheduleId IS NULL OR CIS.Id = @CandidateInterviewScheduleId)
		   	     AND (@InterviewTypeId IS NULL OR CIS.InterviewTypeId = @InterviewTypeId)
				 AND (@InterviwerId IS NULL OR U.Id = @InterviwerId)
				 AND (@CandidateId IS NULL OR CIS.CandidateId = @CandidateId)
		   	     AND (@SearchText IS NULL OR (IT.InterviewTypeName LIKE @SearchText)
				                          OR (C.FirstName + ISNULL(C.LastName,'') LIKE @SearchText)
										  OR (CIS.IsConfirmed LIKE @SearchText)
										  OR (CIS.IsCancelled LIKE @SearchText)
										  OR (CIS.IsRescheduled LIKE @SearchText)
										)
				AND CIS.InActiveDateTime IS NULL AND C.InActiveDateTime IS NULL 
				AND U.CompanyId = @CompanyId
				AND IT.InActiveDateTime IS NULL
			    AND U.InActiveDateTime IS NULL
				AND IsCancelled <> 1
				Group by U.FirstName + ' ' +ISNULL(U.SurName,''),  CIS.IsConfirmed,CIS.IsCancelled, U.Id 
		   ORDER BY U.FirstName + ' ' +ISNULL(U.SurName,'') 
		    
		   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize Rows ONLY

	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO
