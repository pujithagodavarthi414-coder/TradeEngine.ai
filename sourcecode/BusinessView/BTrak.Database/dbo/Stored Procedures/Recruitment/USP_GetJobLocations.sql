CREATE PROCEDURE [dbo].[USP_GetJobLocations]
(
	@JobLocationId UNIQUEIDENTIFIER = NULL,
	@JobOpeningId UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER,
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

		   IF(@JobLocationId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

	       IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

		   IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET  @BranchId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [JobLocation])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [JobLocation]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT JL.Id AS JobLocationId,
				  JL.JobOpeningId,
				  JO.JobOpeningTitle,
				  JL.BranchId,
				  B.BranchName,
				  JL.CreatedByUserId,
				  JL.CreatedDateTime,
				  JL.[TimeStamp]
		   FROM [dbo].[JobLocation] JL WITH (NOLOCK)
		        INNER JOIN JobOpening JO WITH (NOLOCK) ON JO.Id = JL.JobOpeningId
				INNER JOIN Branch B WITH (NOLOCK) ON B.Id = JL.BranchId
		   WHERE (@JobLocationId IS NULL OR JL.Id = @JobLocationId)
		   	     AND (@JobOpeningId IS NULL OR JL.JobOpeningId = @JobOpeningId)
				 AND (@BranchId IS NULL OR JL.BranchId = @BranchId)
		   	     AND (@SearchText IS NULL OR (JO.JobOpeningTitle LIKE @SearchText)
				                          OR (B.BranchName LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
		   	    WHEN @SortBy = 'BranchName' THEN B.BranchName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JL.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
		   	    WHEN @SortBy = 'BranchName' THEN B.BranchName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JL.CreatedDateTime,121) AS sql_variant)
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
