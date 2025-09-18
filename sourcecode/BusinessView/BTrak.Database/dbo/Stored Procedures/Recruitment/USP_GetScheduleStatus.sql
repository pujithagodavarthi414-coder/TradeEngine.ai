CREATE PROCEDURE [dbo].[USP_GetScheduleStatus]
(
	@ScheduleStatusId UNIQUEIDENTIFIER = NULL,
	@Order INT = NULL,
	@Status NVARCHAR(500)=NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@IsArchived BIT= NULL,
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

		   IF(@ScheduleStatusId = '00000000-0000-0000-0000-000000000000') SET  @ScheduleStatusId = NULL

	       IF(@Status = '') SET  @Status = NULL

		   IF(@Status = '') SET  @Status = NULL
		   
		   IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'Order'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [ScheduleStatus])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [HiringStatus]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT SS.Id AS ScheduleStatusId,
				  SS.[Order],
				  SS.[Status],
				  SS.[Color],
				  SS.CreatedByUserId,
				  SS.CreatedDateTime,
				  SS.[TimeStamp]
		   FROM [dbo].[ScheduleStatus] SS WITH (NOLOCK)
		   WHERE (@ScheduleStatusId IS NULL OR SS.Id = @ScheduleStatusId)
		   	     AND (@Order IS NULL OR SS.[Order] = @Order)
				 AND (@Status IS NULL OR SS.[Status] = @Status)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND SS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND SS.InActiveDateTime IS NULL))	
		   	     AND (@SearchText IS NULL OR (SS.[Order] LIKE @SearchText)
				                          OR (SS.[Status] LIKE @SearchText)
										)
				AND SS.CompanyId = @CompanyId
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'Status' THEN SS.[Status]
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,SS.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'Order' THEN SS.[Order]
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'Status' THEN SS.[Status]
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,SS.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'Order' THEN SS.[Order]
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
