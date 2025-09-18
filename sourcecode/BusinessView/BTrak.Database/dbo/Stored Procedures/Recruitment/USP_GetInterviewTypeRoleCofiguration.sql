CREATE PROCEDURE [dbo].[USP_GetInterviewTypeRoleCofiguration]
(
	@InterviewTypeRoleCofigurationId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER,
	@RoleId UNIQUEIDENTIFIER,
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

		   IF(@InterviewTypeRoleCofigurationId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeRoleCofigurationId = NULL

	       IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET  @RoleId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [InterviewTypeRoleCofiguration])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [InterviewTypeRoleCofiguration]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT ITRS.Id AS InterviewTypeRoleCofigurationId,
				  ITRS.InterviewTypeId,
				  IT.InterviewTypeName,
				  ITRS.RoleId,
				  R.RoleName,
				  ITRS.CreatedByUserId,
				  ITRS.CreatedDateTime,
				  ITRS.[TimeStamp]
		   FROM [dbo].[InterviewTypeRoleCofiguration] ITRS WITH (NOLOCK)
		        INNER JOIN InterviewType IT WITH (NOLOCK) ON IT.Id = ITRS.InterviewTypeId
				INNER JOIN [Role] R WITH (NOLOCK) ON R.Id = ITRS.RoleId
		   WHERE (@InterviewTypeRoleCofigurationId IS NULL OR ITRS.Id = @InterviewTypeRoleCofigurationId)
		   	     AND (@InterviewTypeId IS NULL OR ITRS.InterviewTypeId = @InterviewTypeId)
				 AND (@RoleId IS NULL OR ITRS.RoleId = @RoleId)
		   	     AND (@SearchText IS NULL OR (IT.InterviewTypeName LIKE @SearchText)
				                          OR (R.RoleName LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'RoleName' THEN R.RoleName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,ITRS.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'RoleName' THEN R.RoleName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,ITRS.CreatedDateTime,121) AS sql_variant)
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
