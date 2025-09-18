CREATE PROCEDURE [dbo].[USP_UpsertEmployeeRateSheet]
(
 @EmployeeRateSheetId UNIQUEIDENTIFIER = NULL,
 @RateSheetId UNIQUEIDENTIFIER = NULL,
 @RateSheetForId UNIQUEIDENTIFIER = NULL,
 @EmployeeRateSheetStartDate DATETIME = NULL,
 @EmployeeRateSheetEndDate DATETIME = NULL,
 @RatePerHour DECIMAL(14,2) = NULL,
 @RatePerHourMon DECIMAL(14,2) = NULL,
 @RatePerHourTue DECIMAL(14,2) = NULL,
 @RatePerHourWed DECIMAL(14,2) = NULL,
 @RatePerHourThu DECIMAL(14,2) = NULL,
 @RatePerHourFri DECIMAL(14,2) = NULL,
 @RatePerHourSat DECIMAL(14,2) = NULL,
 @RatePerHourSun DECIMAL(14,2) = NULL,
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

		--IF (@HavePermission = '1')
		--BEGIN
		--		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		--		DECLARE @EmployeeRateSheetIdCount INT = (SELECT COUNT(1) FROM EmployeeRateSheet WHERE Id = @EmployeeRateSheetId AND CompanyId = @CompanyId)
				
		--		DECLARE @EmployeeRateSheetCount INT = (SELECT COUNT(1) FROM EmployeeRateSheet WHERE EmployeeRateSheetName = @EmployeeRateSheetName AND (@EmployeeRateSheetId IS NULL OR Id <> @EmployeeRateSheetId) StartDate AND CompanyId = @CompanyId) 

		--		IF (@EmployeeRateSheetIdCount = 0 AND @EmployeeRateSheetId IS NOT NULL)
		--		BEGIN
				    
		--			RAISERROR(50002,16,1,'EmployeeRateSheet')

		--		END
		--		ELSE IF(@EmployeeRateSheetCount > 0)
		--		BEGIN
				
		--			RAISERROR(50001,16,1,'EmployeeRateSheet')

		--		END
		--		ELSE
		--		BEGIN

		--			DECLARE @IsLatest BIT = (CASE WHEN @EmployeeRateSheetId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EmployeeRateSheet WHERE Id = @EmployeeRateSheetId ) = @TimeStamp THEN 1 ELSE 0 END END )

		--			IF (@IsLatest = 1) 
		--			BEGIN

		--				DECLARE @CurrentDate DATETIME = GETDATE()

		--				IF(@EmployeeRateSheetId IS NULL)
		--				BEGIN

		--				SET @EmployeeRateSheetId = NEWID()

		--				INSERT INTO EmployeeRateSheet(	Id,
		--										RateSheetId,
		--										RateSheetForId,
		--										RateSheetStartDate,
		--										RateSheetEndDate,
		--										RatePerHour,
		--										RatePerHourMon,
		--										RatePerHourTue,
		--										RatePerHourWed,
		--										RatePerHourThu,
		--										RatePerHourFri,
		--										RatePerHourSat,
		--										RatePerHourSun,
		--										CompanyId,
		--										CreatedDateTime,
		--										CreatedByUserId,
		--										InactiveDateTime
		--								)
		--								SELECT  @EmployeeRateSheetId,
		--									    @RateSheetId,
		--										@EmployeeRateSheetForId,
		--										@EmployeeRateSheetStartDate,
		--										@EmployeeRateSheetEndDate,
		--										@RatePerHour,
		--										@RatePerHourMon,
		--										@RatePerHourTue,
		--										@RatePerHourWed,
		--										@RatePerHourThu,
		--										@RatePerHourFri,
		--										@RatePerHourSat,
		--										@RatePerHourSun,
		--										@CompanyId,
		--										@CurrentDate,
		--										@OperationsPerformedBy,
		--										CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

		--			END
		--			ELSE
		--			BEGIN
						
		--				UPDATE [EmployeeRateSheet] 
		--				    SET [EmployeeRateSheetName] = @EmployeeRateSheetName,
		--						[EmployeeRateSheetForId] = @EmployeeRateSheetForId,
		--						[RateSheetStartDate] = @EmployeeRateSheetStartDate,
		--						[RateSheetEndDate] = @EmployeeRateSheetEndDate,
		--						[RatePerHour]	= @RatePerHour,
		--						[RatePerHourMon] = @RatePerHourMon,
		--						[RatePerHourTue] = @RatePerHourTue,
		--						[RatePerHourWed] = @RatePerHourWed,
		--						[RatePerHourThu] = @RatePerHourThu,
		--						[RatePerHourFri] = @RatePerHourFri,
		--						[RatePerHourSat] = @RatePerHourSat,
		--						[RatePerHourSun] = @RatePerHourSun,
		--						[CompanyId] = @CompanyId,
		--						[UpdatedDateTime] = @CurrentDate,
		--						[UpdatedByUserId] = @OperationsPerformedBy,
		--						[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		--						WHERE Id = @EmployeeRateSheetId
		--			END
					
		--			SELECT Id FROM EmployeeRateSheet WHERE Id = @EmployeeRateSheetId;


		--		END
		--		END
		--END
		--ELSE
		--	RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END