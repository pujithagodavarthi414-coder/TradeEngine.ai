CREATE PROCEDURE [dbo].[USP_GetCandidateSkills]
(
	@CandidateSkillId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER,
	@SkillId UNIQUEIDENTIFIER = NULL,
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

		   IF(@CandidateSkillId = '00000000-0000-0000-0000-000000000000') SET  @CandidateSkillId = NULL

	       IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@SkillId = '00000000-0000-0000-0000-000000000000') SET  @SkillId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateSkills])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateSkills]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CS.Id AS CandidateSkillId,
				  CS.CandidateId,
				  C.FirstName + ISNULL(C.LastName,'') CandidateName,
				  CS.SkillId,
				  S.SkillName,
				  CS.Experience,
				  CS.CreatedByUserId,
				  CS.CreatedDateTime,
				  CS.[TimeStamp]
		   FROM [dbo].[CandidateSkills] CS WITH (NOLOCK)
		        INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CS.CandidateId
				INNER JOIN Skill S WITH (NOLOCK) ON S.Id = CS.SkillId
		   WHERE (@CandidateSkillId IS NULL OR CS.Id = @CandidateSkillId)
		   	     AND (@CandidateId IS NULL OR CS.CandidateId = @CandidateId)
				 AND (@SkillId IS NULL OR CS.SkillId = @SkillId)
		   	     AND (@SearchText IS NULL OR (C.FirstName + ISNULL(C.LastName,'') LIKE @SearchText)
				                          OR (S.SkillName LIKE @SearchText)
										)
				 AND ((@IsArchived IS NULL AND CS.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND CS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CS.InActiveDateTime IS NULL))
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		   	    WHEN @SortBy = 'SkillName' THEN S.SkillName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CS.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		   	    WHEN @SortBy = 'SkillName' THEN S.SkillName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CS.CreatedDateTime,121) AS sql_variant)
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
