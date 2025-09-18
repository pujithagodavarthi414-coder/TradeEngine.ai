CREATE PROCEDURE [dbo].[USP_GetAllPeakHours]
	@PeakHourId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250),
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@SortBy NVARCHAR(250) = NULL,
	@SortDirection NVARCHAR(50) = NULL,
	@PageNo INT = 1,
	@PageSize INT = 10
AS

BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
		   IF(@PeakHourId = '00000000-0000-0000-0000-000000000000') SET @PeakHourId = NULL

		   IF(@SearchText = '') SET @SearchText = NULL

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   		   
		   	IF(@SortDirection IS NULL )
			BEGIN
				SET @SortDirection = 'DESC'
			END

			IF(@SortBy IS NULL)
			BEGIN
				SET @SortBy = 'PeakHourOn'
			END
			ELSE
			BEGIN
				SET @SortBy = @SortBy
			END

		   SELECT	[Id] PeakHourId,
					[PeakHourOn],
					[FilterType],
					[IsPeakHour],
					[PeakHourFrom],
					[PeakHourTo],
					[CreatedDateTime],
					[CreatedByUserId],
					[TimeStamp],
					CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			TotalCount = COUNT(1) OVER()
			FROM [PeakHour]
			WHERE CompanyId = @CompanyId
		   	   AND (@PeakHourId IS NULL OR Id = @PeakHourId)
		   	   AND (@SearchText IS NULL OR [PeakHourOn] LIKE '%' + @SearchText +'%' OR [PeakHourFrom] LIKE '%' + @SearchText +'%' OR [PeakHourTo] LIKE '%' + @SearchText +'%' OR (CASE WHEN [IsPeakHour] = 1 THEN 'Yes' ELSE 'No' END) LIKE '%'+ @SearchText +'%')
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND InActiveDateTime IS NULL))
           ORDER BY 
						CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'peakHourOn' THEN CAST(PeakHourOn AS SQL_VARIANT)
								 WHEN @SortBy = 'peakHourFrom' THEN CAST(PeakHourFrom AS SQL_VARIANT)
								 WHEN @SortBy = 'peakHourTo' THEN CAST(PeakHourTo AS SQL_VARIANT)
						END
						END ASC,
						CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'peakHourOn' THEN CAST(PeakHourOn AS SQL_VARIANT)
								 WHEN @SortBy = 'peakHourFrom' THEN CAST(PeakHourFrom AS SQL_VARIANT)
								 WHEN @SortBy = 'peakHourTo' THEN CAST(PeakHourTo AS SQL_VARIANT)
							END
						END DESC
		   OFFSET ((@PageNo - 1) * @PageSize) ROWS 

		END
		ELSE
		BEGIN
			RAISERROR (@HavePermission,11, 1)
		END

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END