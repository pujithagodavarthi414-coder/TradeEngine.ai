--EXEC [dbo].[USP_GetInterviewTypes] @OperationsPerformedBy='498C2AC7-A670-42F7-AF90-2B35624617E8'
CREATE PROCEDURE [dbo].[USP_GetInterviewTypes]
(
	@InterviewTypeId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeName NVARCHAR(250) = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@IsArchived BIT= NULL,
	@IsVideo BIT=NULL,
	@IsPhone BIT=NULL,
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

	       IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@InterviewTypeName = '') SET  @InterviewTypeName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [InterviewType])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [InterviewType]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT IT.Id AS InterviewTypeId,
				  IT.InterviewTypeName,
				  IT.Color,
				  IT.IsVideoCalling AS IsVideo,
				  IT.IsPhoneCalling AS IsAudio,
				  STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),ITRC.RoleId))
                                FROM [InterviewTypeRoleCofiguration] ITRC
                                     INNER JOIN [Role] R ON R.Id = ITRC.RoleId 
                                                AND R.InactiveDateTime IS NULL AND ITRC.InactiveDateTime IS NULL
                                WHERE ITRC.InterviewTypeId = IT.Id
                                ORDER BY R.RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleId,
                    STUFF((SELECT ', ' + RoleName 
                                FROM [InterviewTypeRoleCofiguration] ITRC
                                     INNER JOIN [Role] R ON R.Id = ITRC.RoleId 
                                                AND R.InactiveDateTime IS NULL AND ITRC.InactiveDateTime IS NULL
                                WHERE ITRC.InterviewTypeId = IT.Id
                                ORDER BY R.RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
                  IT.CreatedByUserId,
				  IT.CreatedDateTime,
				  IT.[TimeStamp],
				  CASE WHEN IT.IsVideoCalling = 1 THEN 'Video call' ELSE 
				  CASE WHEN IT.IsPhoneCalling=1 THEN 'Phone call' ELSE 'None'  END END AS ModeOfInterview
		   FROM [dbo].[InterviewType] IT WITH (NOLOCK)
		   WHERE (@InterviewTypeId IS NULL OR IT.Id = @InterviewTypeId)
		   	     AND (@InterviewTypeName IS NULL OR IT.InterviewTypeName = @InterviewTypeName)
				 AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND IT.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND IT.InActiveDateTime IS NULL))
		   	     AND (@SearchText IS NULL OR (IT.InterviewTypeName LIKE @SearchText))
				 AND IT.CompanyId = @CompanyId
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		        WHEN @SortBy = 'IsVideoCalling' THEN IT.IsVideoCalling
				WHEN @SortBy = 'IsPhoneCalling' THEN IT.IsPhoneCalling
		   	    WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IT.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		        WHEN @SortBy = 'IsVideoCalling' THEN IT.IsVideoCalling
				WHEN @SortBy = 'IsPhoneCalling' THEN IT.IsPhoneCalling
		   	 	WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IT.CreatedDateTime,121) AS sql_variant)
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
