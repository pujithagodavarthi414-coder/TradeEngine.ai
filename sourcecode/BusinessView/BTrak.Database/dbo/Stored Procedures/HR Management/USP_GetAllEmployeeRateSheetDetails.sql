--EXEC [dbo].[USP_GetAllEmployeeRateSheetDetails] @OperationsPerformedBy='873A35E6-64FC-4655-803B-03B15B6CBC02' ,@EmployeeId='F9733940-1260-40F0-A561-05A8019EA7EC'

CREATE PROCEDURE [dbo].[USP_GetAllEmployeeRateSheetDetails]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@PageNo INT = 1,
	@PageSize INT = 10,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@SortBy VARCHAR(50) = null,
	@SortDirectionAsc BIT = null,
	@IsFilter varchar(10) = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
		   IF(@SearchText = '') SET @SearchText = NULL
		   DECLARE @SortDirection VARCHAR(50)

		   IF(@SortDirectionAsc = 1) SET @SortDirection = 'ASC'
		   ELSE SET @SortDirection = 'DESC'
		   
		   IF(@SortBy IS NULL) SET @SortBy = 'rateSheetName'

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT ERS.Id AS EmployeeRateSheetId,
				  RS.ID RateSheetId,
				  RS.CompanyId,
				  RS.RateSheetName,
				  ERS.RateSheetForId,
				  RSF.RateSheetForName,
				  C.Id [RateSheetCurrencyId],
				  C.CurrencyName [RateSheetCurrencyName],
				  C.CurrencyCode [RateSheetCurrencyCode],
				  ERS.RateSheetStartDate,
				  ERS.RateSheetEndDate,
				  ERS.RatePerHour,
				  ERS.RatePerHourMon,
				  ERS.RatePerHourTue,
				  ERS.RatePerHourWed,
				  ERS.RatePerHourThu,
				  ERS.RatePerHourFri,
				  ERS.RatePerHourSat,
				  ERS.RatePerHourSun,
				  ERS.CreatedDateTime,
				  ERS.CreatedByUserId,
				  ERS.[TimeStamp],
				  ERS.RateSheetEmployeeId,
				  ES.IsPermanent,
				  CASE WHEN ERS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[EmployeeRateSheet] AS ERS 
		   INNER JOIN Employee E ON E.Id = ERS.RateSheetEmployeeId
		   INNER JOIN [USER] U ON U.Id = E.UserId and U.InActiveDateTime IS NULL AND U.IsActive = 1
		   INNER JOIN RateSheet AS RS on ERS.RateSheetId = RS.Id AND RS.InActiveDateTime IS NULL
		   INNER JOIN Job AS J ON J.EmployeeId = ERS.RateSheetEmployeeId AND J.InActiveDateTime IS NULL
		   INNER JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId AND ES.InActiveDateTime IS NULL
		   INNER JOIN RateSheetFor RSF ON RSF.Id = RS.RateSheetForId
		   LEFT JOIN Currency C ON C.Id = ERS.RateSheetCurrencyId AND C.Companyid = ERS.CompanyId
           WHERE RS.CompanyId = @CompanyId AND CONVERT(DATE, ERS.RateSheetEndDate) >= CONVERT(DATE, GETDATE())
				AND (@EmployeeId IS NULL OR ERS.RateSheetEmployeeId = @EmployeeId)				
		   		AND (@SearchText IS NULL OR RS.RateSheetName LIKE '%' + @SearchText +'%' OR RS.RatePerHour LIKE '%' + @SearchText +'%' OR RS.RatePerHourMon LIKE '%' + @SearchText +'%' OR RS.RatePerHourTue LIKE '%' + @SearchText +'%'
				OR RS.RatePerHourWed LIKE '%' + @SearchText +'%' OR RS.RatePerHourThu LIKE '%' + @SearchText +'%' OR RS.RatePerHourFri LIKE '%' + @SearchText +'%' OR RS.RatePerHourSat LIKE '%' + @SearchText +'%'
			    OR RS.RatePerHourSun LIKE '%' + @SearchText +'%')
				AND ERS.InActiveDateTime IS NULL
				AND (@BranchId IS NULL OR ERS.RateSheetEmployeeId IN(
						SELECT E.ID FROM EmployeeBranch  EB
						INNER JOIN EMPLOYEE E ON E.Id = EB.EmployeeId
						INNER JOIN [User] U1 ON U1.Id = E.UserId
						WHERE CompanyId = @CompanyId AND EB.BranchId = @BranchId)
				)
		   ORDER BY 
						CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'rateSheetName' THEN CAST(ERS.RateSheetName AS SQL_VARIANT)
								 WHEN @SortBy = 'rateSheetForName' THEN CAST(RateSheetForName AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHour' THEN CAST(ERS.RatePerHour AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourMon' THEN CAST(ERS.RatePerHourMon AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourTue' THEN CAST(ERS.RatePerHourTue AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourWed' THEN CAST(ERS.RatePerHourWed AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourThu' THEN CAST(ERS.RatePerHourThu AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourFri' THEN CAST(ERS.RatePerHourFri AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSat' THEN CAST(ERS.RatePerHourSat AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSun' THEN CAST(ERS.RatePerHourSun AS SQL_VARIANT)
						END
						END ASC,
						CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'rateSheetName' THEN CAST(ERS.RateSheetName AS SQL_VARIANT)
								 WHEN @SortBy = 'rateSheetForName' THEN CAST(RateSheetForName AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHour' THEN CAST(ERS.RatePerHour AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourMon' THEN CAST(ERS.RatePerHourMon AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourTue' THEN CAST(ERS.RatePerHourTue AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourWed' THEN CAST(ERS.RatePerHourWed AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourThu' THEN CAST(ERS.RatePerHourThu AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourFri' THEN CAST(ERS.RatePerHourFri AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSat' THEN CAST(ERS.RatePerHourSat AS SQL_VARIANT)
								 WHEN @SortBy = 'ratePerHourSun' THEN CAST(ERS.RatePerHourSun AS SQL_VARIANT)
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