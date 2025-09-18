CREATE PROCEDURE [dbo].[USP_UpdateEmployeeRateTagDetails]
(
 @EmployeeRateTagId UNIQUEIDENTIFIER,
 @RateTagId UNIQUEIDENTIFIER = NULL,
 @RateTagCurrencyId UNIQUEIDENTIFIER = NULL,
 @RateTagForId UNIQUEIDENTIFIER = NULL,
 @RateTagStartDate DATETIME = NULL,
 @RateTagEndDate DATETIME = NULL,
 @RatePerHour DECIMAL(14,2) = NULL,
 @RatePerHourMon DECIMAL(14,2) = NULL,
 @RatePerHourTue DECIMAL(14,2) = NULL,
 @RatePerHourWed DECIMAL(14,2) = NULL,
 @RatePerHourThu DECIMAL(14,2) = NULL,
 @RatePerHourFri DECIMAL(14,2) = NULL,
 @RatePerHourSat DECIMAL(14,2) = NULL,
 @RatePerHourSun DECIMAL(14,2) = NULL,
 @RateTagEmployeeId UNIQUEIDENTIFIER,
 @TimeStamp TIMESTAMP = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @Priority INT
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
			
			IF (@RateTagId =  '00000000-0000-0000-0000-000000000000') SET @RateTagId = NULL
			
			IF (@RateTagForId = '00000000-0000-0000-0000-000000000000' ) SET @RateTagForId = NULL

			IF (@RateTagEmployeeId IS NULL)
			BEGIN
				RAISERROR(50011,16,1,'EmployeeId')
			END
			ELSE IF (@RateTagId IS NULL)
			BEGIN
				RAISERROR(50011,16,1,'RateTagId')
			END
			ELSE
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @EmployeeRateTagIdCount INT = (SELECT COUNT(1) FROM EmployeeRateTag WHERE Id = @EmployeeRateTagId AND CompanyId = @CompanyId)

				DECLARE @RateTagPriorityCount INT = (SELECT COUNT(1) FROM EmployeeRateTag WHERE [Priority] = @Priority AND RateTagEmployeeId = @RateTagEmployeeId AND @Priority IS NOT NULL AND (@EmployeeRateTagId IS NULL OR Id <> @EmployeeRateTagId))


				IF (@EmployeeRateTagIdCount = 0 AND @EmployeeRateTagId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16,1,'EmployeeRateTag')
				END
				IF (@RateTagPriorityCount > 0)
				BEGIN
					 RAISERROR('PriorityShouldBeUnique',11,1)
				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @RateTagId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM EmployeeRateTag WHERE Id = @RateTagId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						RAISERROR(50002,16,1,'EmployeeRateTag')
					END
					ELSE
					BEGIN
						declare @RateTagtIdCount int
						SET @RateTagtIdCount = (SELECT COUNT(1) FROM EmployeeRateTag E 
													WHERE E.Id <> @EmployeeRateTagId AND E.RateTagForId = @RateTagForId AND E.RateTagEmployeeId = @RateTagEmployeeId
													AND( CONVERT(DATE, E.RateTagStartDate) BETWEEN CONVERT(DATE, @RateTagStartDate) AND CONVERT(DATE, @RateTagEndDate)
															OR CONVERT(DATE, E.RateTagEndDate) BETWEEN CONVERT(DATE, @RateTagStartDate) AND CONVERT(DATE, @RateTagEndDate)
															OR CONVERT(DATE, @RateTagStartDate) BETWEEN CONVERT(DATE, E.RateTagStartDate) AND CONVERT(DATE, E.RateTagEndDate)
															OR CONVERT(DATE, @RateTagEndDate) BETWEEN CONVERT(DATE, E.RateTagStartDate) AND CONVERT(DATE, E.RateTagEndDate)
													)
													AND E.InActiveDateTime IS NULL
													AND E.CompanyId = @CompanyId)
						IF (@RateTagtIdCount > 0)
						BEGIN
							RAISERROR(50027,16,1,'RateTagDateStartOrEndDateMatchesWithOtherStartDateOrEndDate')
						END


						DECLARE @CurrentDate DATETIME = GETDATE();

						UPDATE [EmployeeRateTag] 
						    SET [RateTagEmployeeId] = @RateTagEmployeeId,
								[RateTagId] = @RateTagId,
								[RateTagCurrencyId] = @RateTagCurrencyId,
								[RateTagStartDate] = @RateTagStartDate,
								[RateTagEndDate] = @RateTagEndDate,
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
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								[Priority] = @Priority
								WHERE Id = @EmployeeRateTagId
					END
					
					SELECT Id FROM [EmployeeRateTag] WHERE Id = @EmployeeRateTagId

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