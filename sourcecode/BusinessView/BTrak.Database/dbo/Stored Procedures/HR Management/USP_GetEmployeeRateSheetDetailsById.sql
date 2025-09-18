CREATE PROCEDURE [dbo].[USP_GetEmployeeRateSheetDetailsById]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250),
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeRateSheetId  UNIQUEIDENTIFIER = null
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
				  CASE WHEN ERS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[EmployeeRateSheet] AS ERS 
		   INNER JOIN RateSheet AS RS on ERS.RateSheetId = RS.Id AND RS.InActiveDateTime IS NULL
		   INNER JOIN RateSheetFor RSF ON RSF.Id = RS.RateSheetForId
		   LEFT JOIN Currency C ON C.Id = ERS.RateSheetCurrencyId AND C.Companyid = ERS.CompanyId
           WHERE RS.CompanyId = @CompanyId AND ERS.RateSheetEmployeeId = @EmployeeId	
				AND (@EmployeeRateSheetId IS NULL OR ERS.Id = @EmployeeRateSheetId)			
		   		AND (@SearchText IS NULL OR RS.RateSheetName LIKE '%' + @SearchText +'%' OR RS.RatePerHour LIKE '%' + @SearchText +'%' OR RS.RatePerHourMon LIKE '%' + @SearchText +'%' OR RS.RatePerHourTue LIKE '%' + @SearchText +'%'
					OR RS.RatePerHourWed LIKE '%' + @SearchText +'%' OR RS.RatePerHourThu LIKE '%' + @SearchText +'%' OR RS.RatePerHourFri LIKE '%' + @SearchText +'%' OR RS.RatePerHourSat LIKE '%' + @SearchText +'%'
					OR RS.RatePerHourSun LIKE '%' + @SearchText +'%')
		   ORDER BY  RS.RateSheetName, RateSheetForName
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