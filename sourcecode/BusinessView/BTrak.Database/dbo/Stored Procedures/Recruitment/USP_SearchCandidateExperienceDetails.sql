--EXEC  [dbo].[USP_SearchCandidateExperienceDetails] @OperationsPerformedBy='F2437331-8FD0-4395-BC80-2B12156FA0DC',@CandidateId='c4d9c356-8706-4b26-9ca7-34b9323d670e',@Salary=0

CREATE PROCEDURE [dbo].[USP_SearchCandidateExperienceDetails]
(
	@CandidateExperienceDetailsId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER,
	@OccupationTitle NVARCHAR(500) = NULL,
	@Company NVARCHAR(500) = NULL,
	@CompanyType NVARCHAR(500) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@IsArchived BIT = NULL,
	@Location NVARCHAR(500) = NULL,
	@IsCurrentlyWorkingHere BIT = NULL,
	@Salary FLOAT = NULL,
	@CurrencyId UNIQUEIDENTIFIER = NULL,
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

		   IF(@CandidateExperienceDetailsId = '00000000-0000-0000-0000-000000000000') SET  @CandidateExperienceDetailsId = NULL

		   IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET  @CurrencyId = NULL

	       IF(@OccupationTitle = '') SET  @OccupationTitle = NULL

		   IF(@Company = '') SET  @Company = NULL

		   IF(@CompanyType = '') SET  @CompanyType = NULL

		   IF(@DateFrom = '') SET  @DateFrom = NULL

		   IF(@DateTo = '') SET  @DateTo = NULL

		   IF(@Location = '') SET  @Location = NULL

		   IF(@IsCurrentlyWorkingHere = '') SET  @IsCurrentlyWorkingHere = NULL

		   IF(@Salary = 0) SET  @Salary = NULL

		   --IF(@CurrencyId = '') SET  @CurrencyId = NULL

		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [CandidateExperienceDetails])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [CandidateExperienceDetails]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT CED.Id AS CandidateExperienceDetailsId,
				  CED.CandidateId,
				  C.FirstName + ISNULL(C.LastName,'') CandidateName,
				  CED.OccupationTitle,
				  CED.Company,
				  CED.CompanyType,
				  CED.[Description],
				  CED.DateFrom,
				  CED.DateTo,
				  CED.[Location],
				  CED.IsCurrentlyWorkingHere,
				  CED.Salary,
				  CED.CurrencyId,
				  SC.CurrencyName,
				  CED.CreatedByUserId,
				  CED.CreatedDateTime,
				  CED.[TimeStamp]
		   FROM [dbo].[CandidateExperienceDetails] CED WITH (NOLOCK)
		        INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CED.CandidateId
				LEFT JOIN SYS_Currency SC WITH (NOLOCK) ON SC.Id = CED.CurrencyId
		   WHERE (@CandidateExperienceDetailsId IS NULL OR CED.Id = @CandidateExperienceDetailsId)
		   	     AND (@CandidateId IS NULL OR CED.CandidateId = @CandidateId)
				 AND (@OccupationTitle IS NULL OR CED.OccupationTitle = @OccupationTitle)
				 AND (@Company IS NULL OR CED.Company = @Company)
				 AND (@CompanyType IS NULL OR CED.CompanyType = @CompanyType)
				 AND (@Description IS NULL OR CED.[Description] = @Description)
				 AND (@DateFrom IS NULL OR CED.DateFrom = @DateFrom)
				 AND (@DateTo IS NULL OR CED.DateTo = @DateTo)
				 AND (@Location IS NULL OR CED.[Location] = @Location)
				 AND (@IsCurrentlyWorkingHere IS NULL OR CED.IsCurrentlyWorkingHere = @IsCurrentlyWorkingHere)
				 AND (@Salary IS NULL OR CED.Salary = @Salary)
				 AND (@CurrencyId IS NULL OR CED.CurrencyId = @CurrencyId)
				 AND ((@IsArchived IS NULL AND CED.InActiveDateTime IS NULL) 
				 OR (@IsArchived = 1 AND CED.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CED.InActiveDateTime IS NULL))
		   	     AND (@SearchText IS NULL OR (C.FirstName + ISNULL(C.LastName,'') LIKE @SearchText)
				                          OR (CED.OccupationTitle LIKE @SearchText)
										  OR (CED.Company LIKE @SearchText)
				                          OR (CED.CompanyType LIKE @SearchText)
										  OR (CED.[Description] LIKE @SearchText)
				                          OR (CED.DateFrom LIKE @SearchText)
										  OR (CED.DateTo LIKE @SearchText)
				                          OR (CED.[Location] LIKE @SearchText)
										  OR (CED.IsCurrentlyWorkingHere LIKE @SearchText)
				                          OR (CED.Salary LIKE @SearchText)
										  OR (SC.CurrencyName LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		        WHEN @SortBy = 'OccupationTitle' THEN CED.OccupationTitle
				WHEN @SortBy = 'Company' THEN CED.Company
				WHEN @SortBy = 'CompanyType' THEN CED.CompanyType
				WHEN @SortBy = 'Description' THEN CAST(CED.[Description] AS NVARCHAR(1000))
				WHEN @SortBy = 'DateFrom' THEN CAST(CONVERT(DATETIME,CED.DateFrom,121) AS sql_variant)
				WHEN @SortBy = 'DateTo' THEN CAST(CONVERT(DATETIME,CED.DateTo) AS sql_variant)
				WHEN @SortBy = 'Location' THEN CED.[Location]
				WHEN @SortBy = 'IsCurrentlyWorkingHere' THEN CED.IsCurrentlyWorkingHere
				WHEN @SortBy = 'CurrencyName' THEN SC.CurrencyName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CED.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'Salary' THEN CED.Salary
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'CandidateName' THEN C.FirstName + ISNULL(C.LastName,'')
		        WHEN @SortBy = 'OccupationTitle' THEN CED.OccupationTitle
				WHEN @SortBy = 'Company' THEN CED.Company
				WHEN @SortBy = 'CompanyType' THEN CED.CompanyType
				WHEN @SortBy = 'Description' THEN CAST(CED.[Description] AS NVARCHAR(1000))
				WHEN @SortBy = 'DateFrom' THEN CAST(CONVERT(DATETIME,CED.DateFrom,121) AS sql_variant)
				WHEN @SortBy = 'DateTo' THEN CAST(CONVERT(DATETIME,CED.DateTo,121) AS sql_variant)
				WHEN @SortBy = 'Location' THEN CED.[Location]
				WHEN @SortBy = 'IsCurrentlyWorkingHere' THEN CED.IsCurrentlyWorkingHere
				WHEN @SortBy = 'CurrencyName' THEN SC.CurrencyName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CED.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'Salary' THEN CED.Salary
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
