CREATE PROCEDURE [dbo].[USP_GetJobTypes]
(
	@JobTypeId UNIQUEIDENTIFIER = NULL,
	@JobTypeName NVARCHAR(250) = NULL,
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

	       IF(@JobTypeId = '00000000-0000-0000-0000-000000000000') SET  @JobTypeId = NULL

		   IF(@JobTypeName = '') SET  @JobTypeName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [JobType])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [JobType]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT JT.Id AS JobTypeId,
				  JT.JobTypeName,
				  JT.CreatedByUserId,
				  JT.CreatedDateTime
		   FROM [dbo].[JobType] JT WITH (NOLOCK)
		   WHERE (@JobTypeId IS NULL OR JT.Id = @JobTypeId)
		   	     AND (@JobTypeName IS NULL OR JT.JobTypeName = @JobTypeName)
		   	     AND (@SearchText IS NULL OR (JT.JobTypeName LIKE @SearchText))
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'JobTypeName' THEN JT.JobTypeName
		   	    WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JT.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'JobTypeName' THEN JT.JobTypeName
		   	 	WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JT.CreatedDateTime,121) AS sql_variant)
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
