CREATE PROCEDURE [dbo].[USP_UpsertRateSheet]
(
 @RateSheetId UNIQUEIDENTIFIER = NULL,
 @RateSheetName NVARCHAR(50) = NULL,
 @RateSheetForId UNIQUEIDENTIFIER = NULL,
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
 @Priority INT,
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

		    IF(@IsArchived = 1 AND @RateSheetId IS NOT NULL)
		    BEGIN
		          DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	              IF(EXISTS(SELECT Id FROM EmployeeRateSheet WHERE RateSheetId = @RateSheetId AND InactiveDateTime IS NULL))
	              BEGIN
	              SET @IsEligibleToArchive = 'ThisRateSheetUsedInEmployeeRateSheetPleaseDeleteTheDependenciesAndTryAgain'
	              END
		          IF(@IsEligibleToArchive <> '1')
		          BEGIN
		             RAISERROR (@isEligibleToArchive,11, 1)
		         END
	        END

			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@RateSheetId =  '00000000-0000-0000-0000-000000000000') SET @RateSheetId = NULL

			IF (@RateSheetName = ' ' ) SET @RateSheetName = NULL

			IF (@RateSheetForId = '00000000-0000-0000-0000-000000000000' ) SET @RateSheetForId = NULL

			IF (@RateSheetName IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'RateSheetName')

			END
			ELSE
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @RateSheetIdCount INT = (SELECT COUNT(1) FROM RateSheet WHERE Id = @RateSheetId AND CompanyId = @CompanyId)
				
				DECLARE @RateSheetCount INT = (SELECT COUNT(1) FROM RateSheet WHERE RateSheetName = @RateSheetName AND (@RateSheetId IS NULL OR Id <> @RateSheetId) AND CompanyId = @CompanyId AND  RateSheetForId IS NOT NULL) 

				DECLARE @RateSheetPriorityCount INT = (SELECT COUNT(1) FROM RateSheet WHERE [Priority] = @Priority AND @Priority IS NOT NULL AND (@RateSheetId IS NULL OR Id <> @RateSheetId) AND CompanyId = @CompanyId )

				IF (@RateSheetIdCount = 0 AND @RateSheetId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'RateSheet')

				END
				ELSE IF(@RateSheetCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'RateSheet')

				END
				ELSE IF(@RateSheetPriorityCount > 0)
				BEGIN
				
				    RAISERROR('RateSheetPriorityShouldBeUnique',11,1)

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @RateSheetId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM RateSheet WHERE Id = @RateSheetId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@RateSheetId IS NULL)
						BEGIN

						SET @RateSheetId = NEWID()

						INSERT INTO RateSheet(	Id,
												RateSheetName,
												RateSheetForId,
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
												InactiveDateTime,
												[Priority]
										)
										SELECT  @RateSheetId,
											    @RateSheetName,
												@RateSheetForId,
												@RatePerHour,
												@RatePerHourMon,
												@RatePerHourTue,
												@RatePerHourWed,
												@RatePerHourThu,
												@RatePerHourFri,
												@RatePerHourSat,
												@RatePerHourSun,
												@CompanyId,
												@CurrentDate,
												@OperationsPerformedBy,
												CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
												@Priority

					END
					ELSE
					BEGIN
						
						UPDATE [RateSheet] 
						    SET [RateSheetName] = @RateSheetName,
								[RateSheetForId] = @RateSheetForId,
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
								WHERE Id = @RateSheetId
					END
					
					SELECT Id FROM RateSheet WHERE Id = @RateSheetId

				END
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
