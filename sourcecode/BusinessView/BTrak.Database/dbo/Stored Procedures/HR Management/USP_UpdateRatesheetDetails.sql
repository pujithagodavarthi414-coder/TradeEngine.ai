CREATE PROCEDURE [dbo].[USP_UpdateRatesheetDetails]
(
 @EmployeeRateSheetId UNIQUEIDENTIFIER,
 @RateSheetId UNIQUEIDENTIFIER = NULL,
 @RateSheetCurrencyId UNIQUEIDENTIFIER = NULL,
 @RateSheetForId UNIQUEIDENTIFIER = NULL,
 @RateSheetStartDate DATETIME = NULL,
 @RateSheetEndDate DATETIME = NULL,
 @RatePerHour DECIMAL(14,2) = NULL,
 @RatePerHourMon DECIMAL(14,2) = NULL,
 @RatePerHourTue DECIMAL(14,2) = NULL,
 @RatePerHourWed DECIMAL(14,2) = NULL,
 @RatePerHourThu DECIMAL(14,2) = NULL,
 @RatePerHourFri DECIMAL(14,2) = NULL,
 @RatePerHourSat DECIMAL(14,2) = NULL,
 @RatePerHourSun DECIMAL(14,2) = NULL,
 @RateSheetEmployeeId UNIQUEIDENTIFIER,
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
			
			IF (@RateSheetId =  '00000000-0000-0000-0000-000000000000') SET @RateSheetId = NULL
			
			IF (@RateSheetForId = '00000000-0000-0000-0000-000000000000' ) SET @RateSheetForId = NULL

			IF (@RateSheetEmployeeId IS NULL)
			BEGIN
				RAISERROR(50011,16,1,'EmployeeId')
			END
			ELSE IF (@RateSheetForId IS NULL)
			BEGIN
				RAISERROR(50011,16,1,'RatesheetForId')
			END
			ELSE IF (@RateSheetId IS NULL)
			BEGIN
				RAISERROR(50011,16,1,'RatesheetId')
			END
			ELSE
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @EmployeeRateSheetIdCount INT = (SELECT COUNT(1) FROM EmployeeRateSheet WHERE Id = @EmployeeRateSheetId AND CompanyId = @CompanyId)

				IF (@EmployeeRateSheetIdCount = 0 AND @EmployeeRateSheetId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16,1,'EmployeeRateSheet')
				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @RateSheetId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EmployeeRateSheet WHERE Id = @RateSheetId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						RAISERROR(50002,16,1,'EmployeeRateSheet')
					END
					ELSE
					BEGIN
						declare @RateSheettIdCount int
						SET @RateSheettIdCount = (SELECT COUNT(1) FROM EmployeeRateSheet E 
													WHERE E.Id <> @EmployeeRateSheetId AND E.RateSheetForId = @RateSheetForId AND E.RateSheetEmployeeId = @RateSheetEmployeeId
													AND( CONVERT(DATE, E.RateSheetStartDate) BETWEEN CONVERT(DATE, @RateSheetStartDate) AND CONVERT(DATE, @RateSheetEndDate)
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


						DECLARE @CurrentDate DATETIME = GETDATE();

						UPDATE [EmployeeRateSheet] 
						    SET [RateSheetEmployeeId] = @RateSheetEmployeeId,
								[RateSheetId] = @RateSheetId,
								[RateSheetForId] = @RateSheetForId,
								[RateSheetCurrencyId] = @RateSheetCurrencyId,
								[RateSheetStartDate] = @RateSheetStartDate,
								[RateSheetEndDate] = @RateSheetEndDate,
								[RatePerHour]	= @RatePerHour,
								[RatePerHourMon] = @RatePerHourMon,
								[RatePerHourTue] = @RatePerHourTue,
								[RatePerHourWed] = @RatePerHourWed,
								[RatePerHourThu] = @RatePerHourThu,
								[RatePerHourFri] = @RatePerHourFri,
								[RatePerHourSat] = @RatePerHourSat,
								[RatePerHourSun] = @RatePerHourSun,
								[CompanyId] = @CompanyId,
								[UpdatedDateTime] = @CurrentDate,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
								WHERE Id = @EmployeeRateSheetId
					END
					
					SELECT Id FROM [EmployeeRateSheet] WHERE Id = @EmployeeRateSheetId

				END
			END
		END
		ELSE
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END