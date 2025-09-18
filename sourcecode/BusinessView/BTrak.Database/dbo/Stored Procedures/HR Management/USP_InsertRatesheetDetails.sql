CREATE PROCEDURE [dbo].[USP_InsertRatesheetDetails]
(
 @RateSheetStartDate DATETIME = NULL,
 @RateSheetEndDate DATETIME = NULL,
 @RateSheetEmployeeId UNIQUEIDENTIFIER,
 @RateSheetCurrencyId UNIQUEIDENTIFIER,
 @RateSheetDetails NVARCHAR(MAX),
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@RateSheetEmployeeId IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'Employee')

			END
			ELSE IF (@RateSheetStartDate IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'StartDate')

			END
			ELSE IF (@RateSheetStartDate IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'EndDate')

			END
			ELSE IF (@RateSheetDetails IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'RatesheetDetails')

			END
			ELSE
			BEGIN
				
				CREATE TABLE #RatesheetDetails 
				(
					EmployeeRateSheetId UNIQUEIDENTIFIER,
					RateSheetId UNIQUEIDENTIFIER,
					RateSheetName NVARCHAR(250),
					RateSheetCurrencyId UNIQUEIDENTIFIER,
					RateSheetForId UNIQUEIDENTIFIER,
					RateSheetForName NVARCHAR(250),
					RateSheetStartDate NVARCHAR(250),
					RateSheetEndDate NVARCHAR(250),
					RatePerHour DECIMAL(10,2),
					RatePerHourMon DECIMAL(10,2),
					RatePerHourTue DECIMAL(10,2),
					RatePerHourWed DECIMAL(10,2),
					RatePerHourThu DECIMAL(10,2),
					RatePerHourFri DECIMAL(10,2),
					RatePerHourSat DECIMAL(10,2),
					RatePerHourSun DECIMAL(10,2),
					RateSheetEmployeeId UNIQUEIDENTIFIER,
					IsArchived BIT
				)

				INSERT INTO #RateSheetDetails
				SELECT *
				FROM OPENJSON(@RateSheetDetails)
				WITH (EmployeeRateSheetId UNIQUEIDENTIFIER,
					RateSheetId UNIQUEIDENTIFIER,
					RateSheetName NVARCHAR(250),
					RateSheetCurrencyId UNIQUEIDENTIFIER,
					RateSheetForId UNIQUEIDENTIFIER,
					RateSheetForName NVARCHAR(250),
					RateSheetStartDate NVARCHAR(250),
					RateSheetEndDate NVARCHAR(250),
					RatePerHour DECIMAL(10,2),
					RatePerHourMon DECIMAL(10,2),
					RatePerHourTue DECIMAL(10,2),
					RatePerHourWed DECIMAL(10,2),
					RatePerHourThu DECIMAL(10,2),
					RatePerHourFri DECIMAL(10,2),
					RatePerHourSat DECIMAL(10,2),
					RatePerHourSun DECIMAL(10,2),
					RateSheetEmployeeId UNIQUEIDENTIFIER,
					IsArchived BIT)

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @RateSheettIdCount INT = (SELECT COUNT(1) FROM EmployeeRateSheet E JOIN #RatesheetDetails R ON E.RateSheetEmployeeId = @RateSheetEmployeeId AND E.RateSheetId = R.RateSheetId 
													AND E.RateSheetStartDate  = @RateSheetStartDate AND E.RateSheetEndDate = @RateSheetEndDate 
													AND E.InActiveDateTime IS NULL
													AND E.CompanyId = @CompanyId)
				
				IF (@RateSheettIdCount > 0)
				BEGIN
				    
					RAISERROR(50012,16,1,'Ratesheet')

				END
				SET @RateSheettIdCount = (SELECT COUNT(1) FROM EmployeeRateSheet E JOIN #RatesheetDetails R ON E.RateSheetEmployeeId = @RateSheetEmployeeId AND E.RateSheetId = R.RateSheetId 
													AND ( CONVERT(DATE, E.RateSheetStartDate) BETWEEN CONVERT(DATE, @RateSheetStartDate) AND CONVERT(DATE, @RateSheetEndDate)
														OR CONVERT(DATE, E.RateSheetEndDate) BETWEEN CONVERT(DATE, @RateSheetStartDate) AND CONVERT(DATE, @RateSheetEndDate)
														OR CONVERT(DATE, @RateSheetStartDate) BETWEEN CONVERT(DATE, E.RateSheetStartDate) AND CONVERT(DATE, E.RateSheetEndDate)
														OR CONVERT(DATE, @RateSheetEndDate) BETWEEN CONVERT(DATE, E.RateSheetStartDate) AND CONVERT(DATE, E.RateSheetEndDate)
													)
													AND E.InActiveDateTime IS NULL
													AND E.CompanyId = @CompanyId)
				IF (@RateSheettIdCount > 0)
				BEGIN
				    
					RAISERROR(50027,16,1,'RatesheetDateStartOrEndDateMatchesWithOtherStartDateOrEndDate')

				END
				ELSE
				BEGIN
					DECLARE @CurrentDate DATETIME = GETDATE();

					INSERT INTO EmployeeRateSheet(	Id, 
													RateSheetEmployeeId,
													RateSheetId,
													RateSheetCurrencyId,
													RateSheetForId,
													RateSheetStartDate,
													RateSheetEndDate,
													RatePerHour,
													RatePerHourMon,
													RatePerHourTue,
													RatePerHourWed,
													RatePerHourThu,
													RatePerHourFri,
													RatePerHourSat,
													RatePerHourSun,
													CompanyId,
													CreatedDateTime,
													CreatedByUserId,
													InActiveDateTime)
					SELECT NEWID(),
							@RateSheetEmployeeId,
							R.RateSheetId,
							@RateSheetCurrencyId,
							R.RateSheetForId,
							@RateSheetStartDate,
							@RateSheetEndDate,
							R.RatePerHour,
							R.RatePerHourMon,
							R.RatePerHourTue,
							R.RatePerHourWed,
							R.RatePerHourThu,
							R.RatePerHourFri,
							R.RatePerHourSat,
							R.RatePerHourSun,
							@CompanyId,
							@CurrentDate,
							@OperationsPerformedBy,
							CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
					FROM #RatesheetDetails R

					SELECT TOP 1 Id FROM EmployeeRateSheet WHERE CreatedDateTime = @CurrentDate
				END
			END
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END