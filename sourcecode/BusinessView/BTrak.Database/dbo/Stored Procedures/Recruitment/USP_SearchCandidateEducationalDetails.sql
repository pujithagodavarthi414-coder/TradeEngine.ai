CREATE PROCEDURE [dbo].[USP_SearchCandidateEducationalDetails]
(
	@CandidateEducationalDetailId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER,
	@Institute NVARCHAR(500) = NULL,
	@Department NVARCHAR(500) = NULL,
	@NameOfDegree NVARCHAR(500) = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@IsPursuing BIT = NULL,
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

		   IF(@CandidateEducationalDetailId = '00000000-0000-0000-0000-000000000000') SET  @CandidateEducationalDetailId = NULL

	       IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL
		   
	       IF(@Institute = '') SET  @Institute = NULL

	       IF(@Department = '') SET  @Department = NULL

	       IF(@NameOfDegree = '') SET  @NameOfDegree = NULL

	       IF(@DateFrom = '') SET  @DateFrom = NULL

	       IF(@DateTo = '') SET  @DateTo = NULL

	       IF(@IsPursuing = '') SET  @IsPursuing = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateEducationalDetails])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateEducationalDetails]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CED.Id AS CandidateEducationalDetailId,
				  CED.CandidateId,
				  C.FirstName + ISNULL('',C.LastName) CandidateName,
				  CED.Institute,
				  CED.Department,
				  CED.NameOfDegree,
				  CED.DateFrom,
				  CED.DateTo,
				  CED.IsPursuing,
				  CED.CreatedByUserId,
				  CED.CreatedDateTime,
				  CED.[TimeStamp]
		   FROM [dbo].[CandidateEducationalDetails] CED WITH (NOLOCK)
		        INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CED.CandidateId
		   WHERE (@CandidateEducationalDetailId IS NULL OR CED.Id = @CandidateEducationalDetailId)
		   	     AND (@CandidateId IS NULL OR CED.CandidateId = @CandidateId)
				 AND (@Institute IS NULL OR CED.Institute = @Institute)
				 AND (@Department IS NULL OR CED.Department = @Department)
				 AND (@NameOfDegree IS NULL OR CED.NameOfDegree = @NameOfDegree)
				 AND (@DateFrom IS NULL OR CED.DateFrom = @DateFrom)
				 AND (@DateTo IS NULL OR CED.DateTo = @DateTo)
				 AND (@IsPursuing IS NULL OR CED.IsPursuing = @IsPursuing)
		   	     AND (@SearchText IS NULL OR (C.FirstName + ISNULL(' ',C.LastName) LIKE @SearchText)
				                          OR (CED.Institute LIKE @SearchText)
										  OR (CED.Department LIKE @SearchText)
										  OR (CED.NameOfDegree LIKE @SearchText)
										  OR (CED.DateFrom LIKE @SearchText)
										  OR (CED.DateTo LIKE @SearchText)
										  OR (CED.IsPursuing LIKE @SearchText)
										)
				AND (((@IsArchived IS NULL OR @IsArchived = 0) AND CED.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND CED.InActiveDateTime IS NOT NULL))
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN CAST(C.FirstName + ISNULL(' ',C.LastName) AS sql_variant)
		   	    WHEN @SortBy = 'Institute' THEN CAST(CED.Institute AS sql_variant)
				WHEN @SortBy = 'Department' THEN CAST(CED.Department AS sql_variant)
				WHEN @SortBy = 'NameOfDegree' THEN CAST(CED.NameOfDegree AS sql_variant)
				WHEN @SortBy = 'IsPursuing' THEN CAST(CED.IsPursuing AS sql_variant)
				WHEN @SortBy = 'DateFrom' THEN CAST(CONVERT(DATETIME,CED.DateFrom,121) AS sql_variant)
				WHEN @SortBy = 'DateTo' THEN CAST(CONVERT(DATETIME,CED.DateTo,121) AS sql_variant)
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CED.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN CAST(C.FirstName + ISNULL(' ',C.LastName) AS sql_variant)
		   	    WHEN @SortBy = 'Institute' THEN CAST(CED.Institute AS sql_variant)
				WHEN @SortBy = 'Department' THEN CAST(CED.Department AS sql_variant)
				WHEN @SortBy = 'NameOfDegree' THEN CAST(CED.NameOfDegree AS sql_variant)
				WHEN @SortBy = 'IsPursuing' THEN CAST(CED.IsPursuing AS sql_variant)
				WHEN @SortBy = 'DateFrom' THEN CAST(CONVERT(DATETIME,CED.DateFrom,121) AS sql_variant)
				WHEN @SortBy = 'DateTo' THEN CAST(CONVERT(DATETIME,CED.DateTo,121) AS sql_variant)
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CED.CreatedDateTime,121) AS sql_variant)
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
