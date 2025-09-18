CREATE PROCEDURE [dbo].[USP_GetAllRateSheets]
	@RateSheetId UNIQUEIDENTIFIER = NULL,
	@RateSheetName NVARCHAR(800),
	@RateSheetForId UNIQUEIDENTIFIER = NULL,
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
		
		   IF(@RateSheetId = '00000000-0000-0000-0000-000000000000') SET @RateSheetId = NULL

		   IF(@RateSheetForId = '00000000-0000-0000-0000-000000000000') SET @RateSheetForId = NULL

		   IF(@RateSheetName = '') SET @RateSheetName = NULL

		   IF(@SearchText = '') SET @SearchText = NULL

		   	IF(@SortDirection IS NULL )
			BEGIN
				SET @SortDirection = 'DESC'
			END

			IF(@SortBy IS NULL)
			BEGIN
				SET @SortBy = 'name'
			END
			ELSE
			BEGIN
				SET @SortBy = @SortBy
			END

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT RS.Id AS RateSheetId,
				  RS.CompanyId,
				  RS.RateSheetName,
				  RS.RateSheetForId ,
				  RSF.RateSheetForName,
				  RS.RatePerHour,
				  RS.RatePerHourMon,
				  RS.RatePerHourTue,
				  RS.RatePerHourWed,
				  RS.RatePerHourThu,
				  RS.RatePerHourFri,
				  RS.RatePerHourSat,
				  RS.RatePerHourSun,
				  RS.CreatedDateTime,
				  RS.CreatedByUserId,
				  RS.[TimeStamp],
				  CASE WHEN RS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER(),
				  RS.[Priority]
           FROM [dbo].[RateSheet] AS RS INNER JOIN RateSheetFor RSF ON RSF.Id = RS.RateSheetForId      
           WHERE RS.CompanyId = @CompanyId
		   	   AND (@RateSheetId IS NULL OR RS.Id = @RateSheetId)
		   	   AND (@RateSheetName IS NULL OR RS.RateSheetName = @RateSheetName)
		   	   AND (@RateSheetForId IS NULL OR RS.RateSheetForId = @RateSheetForId)
		   	   AND (@SearchText IS NULL OR RS.RateSheetName LIKE '%' + @SearchText +'%' OR CAST(CAST(RS.RatePerHour  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%' OR CAST(CAST(RS.RatePerHourMon  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%' OR CAST(CAST(RS.RatePerHourTue  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%'
				OR CAST(CAST(RS.RatePerHourWed  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%' OR CAST(CAST(RS.RatePerHourThu  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%' OR CAST(CAST(RS.RatePerHourFri  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%' OR CAST(CAST(RS.RatePerHourSat  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%'
			   OR CAST(CAST(RS.RatePerHourSun  as float)AS nvarchar(250)) LIKE '%' + @SearchText +'%' OR RSF.RateSheetForName   LIKE '%' + @SearchText +'%')
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND RS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND RS.InActiveDateTime IS NULL))
		   ORDER BY 
						CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'rateSheetName' THEN CAST(RateSheetName AS SQL_VARIANT)
								 WHEN @SortBy = 'rateSheetForName' THEN CAST(RateSheetForName AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHour' THEN CAST(RatePerHour AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourMon' THEN CAST(RatePerHourMon AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourTue' THEN CAST(RatePerHourTue AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourWed' THEN CAST(RatePerHourWed AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourThu' THEN CAST(RatePerHourThu AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourFri' THEN CAST(RatePerHourFri AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSat' THEN CAST(RatePerHourSat AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSun' THEN CAST(RatePerHourSun AS SQL_VARIANT)
								 WHEN @SortBy = 'Priority' THEN CAST([Priority] AS SQL_VARIANT)
						END
						END ASC,
						CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'rateSheetName' THEN CAST(RateSheetName AS SQL_VARIANT)
								 WHEN @SortBy = 'rateSheetForName' THEN CAST(RateSheetForName AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHour' THEN CAST(RatePerHour AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourMon' THEN CAST(RatePerHourMon AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourTue' THEN CAST(RatePerHourTue AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourWed' THEN CAST(RatePerHourWed AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourThu' THEN CAST(RatePerHourThu AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourFri' THEN CAST(RatePerHourFri AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSat' THEN CAST(RatePerHourSat AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSun' THEN CAST(RatePerHourSun AS SQL_VARIANT)
								 WHEN @SortBy = 'Priority' THEN CAST([Priority] AS SQL_VARIANT)
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