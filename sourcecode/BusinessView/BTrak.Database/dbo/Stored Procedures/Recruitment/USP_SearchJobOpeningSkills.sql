CREATE PROCEDURE [dbo].[USP_SearchJobOpeningSkills]
(
	@JobOpeningSkillId UNIQUEIDENTIFIER = NULL,
	@JobOpeningId UNIQUEIDENTIFIER,
	@SkillId UNIQUEIDENTIFIER = NULL,
	@MinExperience FLOAT = NULL,
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

		   IF(@JobOpeningSkillId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningSkillId = NULL

	       IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

		   IF(@SkillId = '00000000-0000-0000-0000-000000000000') SET  @SkillId = NULL

	       IF(@MinExperience = '') SET  @MinExperience = NULL

		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [JobOpeningSkill])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [JobOpeningSkill]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT JOS.Id AS JobOpeningSkillId,
				  JOS.JobOpeningId,
				  JO.JobOpeningTitle,
				  JOS.SkillId,
				  S.SkillName,
				  JOS.MinExperience,
				  JOS.CreatedByUserId,
				  JOS.CreatedDateTime,
				  JOS.[TimeStamp]
		   FROM [dbo].[JobOpeningSkill] JOS WITH (NOLOCK)
		        INNER JOIN JobOpening JO WITH (NOLOCK) ON JO.Id = JOS.JobOpeningId
				INNER JOIN Skill S WITH (NOLOCK) ON S.Id = JOS.SkillId
		   WHERE (@JobOpeningSkillId IS NULL OR JOS.Id = @JobOpeningSkillId)
		   	     AND (@JobOpeningId IS NULL OR JOS.JobOpeningId = @JobOpeningId)
				 AND (@SkillId IS NULL OR JOS.SkillId = @SkillId)
				 AND (@MinExperience IS NULL OR JOS.MinExperience = @MinExperience)
		   	     AND (@SearchText IS NULL OR (JO.JobOpeningTitle LIKE @SearchText)
				                          OR (S.SkillName LIKE @SearchText)
										  OR (JOS.MinExperience LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
		   	    WHEN @SortBy = 'SkillName' THEN S.SkillName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JOS.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'MinExperience' THEN JOS.MinExperience
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
		   	    WHEN @SortBy = 'SkillName' THEN S.SkillName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JOS.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'MinExperience' THEN JOS.MinExperience
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
