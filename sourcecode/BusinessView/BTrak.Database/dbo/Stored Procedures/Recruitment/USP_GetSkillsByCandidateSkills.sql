CREATE PROCEDURE [dbo].[USP_GetSkillsByCandidateSkills]
(
	@CandidateSkillId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
    @PageSize INT = NULL,
    @PageNumber INT = NULL
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
		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [Candidate])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [Candidate]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1
	       
		   IF(@CandidateSkillId = '00000000-0000-0000-0000-000000000000') SET  @CandidateSkillId = NULL
		 SELECT * FROM (
		    SELECT S.Id AS SkillId,
                      S.SkillName,
                      S.CreatedDateTime,
                      S.CreatedByUserId,
                      S.[TimeStamp],
					  (SELECT COUNT(1) FROM CandidateSkills C INNER JOIN CandidateJobOpening CJ ON CJ.CandidateId = C.CandidateId INNER JOIN JobOpening J ON J.Id = CJ.JobOpeningId WHERE C.SkillId = S.Id AND C.InActiveDateTime IS NULL AND CJ.InActiveDateTime IS NULL AND J.InActiveDateTime IS NULL) AS TotalCounts,
					 CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  TotalCount = COUNT(1) OVER(),
				  @PageSize AS PageSize,
				  @PageNumber AS PageNumber
				   FROM Skill S  WITH (NOLOCK)
				   INNER  JOIN CandidateSkills SK ON SK.SkillId = S.Id AND SK.InActiveDateTime IS NULL
				   LEFT JOIN CandidateJobOpening CJO ON CJO.CandidateId = SK.CandidateId
				   LEFT JOIN JobOpening JO ON JO.Id = CJO.Id
		   WHERE S.CompanyId = @CompanyId AND SK.InActiveDateTime IS NULL 
				AND JO.InActiveDateTime IS NULL 
				AND CJO.InActiveDateTime IS NULL
				 AND (@CandidateSkillId IS NULL OR S.Id = @CandidateSkillId)
				 GROUP BY S.SkillName,S.Id,S.CreatedByUserId,S.CreatedDateTime,S.TimeStamp,S.InActiveDateTime ) T
				 WHERE TotalCounts > 0
			ORDER BY SkillName ASC
			 OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize Rows ONLY
				
	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
