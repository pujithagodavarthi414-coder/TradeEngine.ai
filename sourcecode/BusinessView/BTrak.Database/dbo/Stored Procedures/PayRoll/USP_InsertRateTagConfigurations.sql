CREATE PROCEDURE [dbo].[USP_InsertRateTagConfigurations]
(
	@RateTagRoleBranchConfigurationId UNIQUEIDENTIFIER,
	@RateTagCurrencyId UNIQUEIDENTIFIER,
	@RateTagDetails NVARCHAR(MAX),
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
			
		    IF (@RateTagDetails IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'RateTagDetails')

			END
			ELSE
			BEGIN
				
				CREATE TABLE #RateTagConfigurationDetails 
				(
					RateTagConfigurationId UNIQUEIDENTIFIER,
					RateTagId UNIQUEIDENTIFIER,
					RateTagName NVARCHAR(250),
					RateTagCurrencyId UNIQUEIDENTIFIER,
					RateTagForId UNIQUEIDENTIFIER,
					RateTagForName NVARCHAR(250),
					RatePerHour DECIMAL(10,2),
					RatePerHourMon DECIMAL(10,2),
					RatePerHourTue DECIMAL(10,2),
					RatePerHourWed DECIMAL(10,2),
					RatePerHourThu DECIMAL(10,2),
					RatePerHourFri DECIMAL(10,2),
					RatePerHourSat DECIMAL(10,2),
					RatePerHourSun DECIMAL(10,2),
					IsArchived BIT,
					[Priority] INT,
				    RowNumber INT IDENTITY(1,1)
				)

				INSERT INTO #RateTagConfigurationDetails
				SELECT *
				FROM OPENJSON(@RateTagDetails)
				WITH (RateTagConfigurationId UNIQUEIDENTIFIER,
					RateTagId UNIQUEIDENTIFIER,
					RateTagName NVARCHAR(250),
					RateTagCurrencyId UNIQUEIDENTIFIER,
					RateTagForId UNIQUEIDENTIFIER,
					RateTagForName NVARCHAR(250),
					RatePerHour DECIMAL(10,2),
					RatePerHourMon DECIMAL(10,2),
					RatePerHourTue DECIMAL(10,2),
					RatePerHourWed DECIMAL(10,2),
					RatePerHourThu DECIMAL(10,2),
					RatePerHourFri DECIMAL(10,2),
					RatePerHourSat DECIMAL(10,2),
					RatePerHourSun DECIMAL(10,2),
					IsArchived BIT,
					[Priority] INT)

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @CurrentDate DATETIME = GETDATE()


				DECLARE @RateTagIdCount INT = (SELECT COUNT(1) FROM RateTagConfiguration RTC 
				                                    JOIN #RateTagConfigurationDetails RTCD
													ON RTC.RateTagRoleBranchConfigurationId = @RateTagRoleBranchConfigurationId 
													AND RTC.RateTagId = RTCD.RateTagId 
													AND RTCD.RateTagConfigurationId IS NULL
													AND RTC.InActiveDateTime IS NULL)
				

				IF (@RateTagIdCount > 0)
				BEGIN
				    
					RAISERROR(50027,16,1,'OneOfTheRateTagAlreadyExistsTryAgain')

				END
				ELSE
				BEGIN

				IF((SELECT COUNT(1) FROM RateTagConfiguration WHERE RateTagRoleBranchConfigurationId = @RateTagRoleBranchConfigurationId AND InActiveDateTime IS NULL) > 0 AND @RateTagRoleBranchConfigurationId IS NOT NULL)
				DELETE FROM RateTagConfiguration WHERE RateTagRoleBranchConfigurationId = @RateTagRoleBranchConfigurationId AND InActiveDateTime IS NULL

				INSERT INTO RateTagConfiguration(Id, 
												RateTagRoleBranchConfigurationId,
												RateTagId,
												RateTagCurrencyId,
												RatePerHour,
												RatePerHourMon,
												RatePerHourTue,
												RatePerHourWed,
												RatePerHourThu,
												RatePerHourFri,
												RatePerHourSat,
												RatePerHourSun,
												CreatedDateTime,
												CreatedByUserId,
												InActiveDateTime,
												[Priority])
					 SELECT NEWID(),
							@RateTagRoleBranchConfigurationId,
							R.RateTagId,
							@RateTagCurrencyId,
							R.RatePerHour,
							R.RatePerHourMon,
							R.RatePerHourTue,
							R.RatePerHourWed,
							R.RatePerHourThu,
							R.RatePerHourFri,
							R.RatePerHourSat,
							R.RatePerHourSun,
							@CurrentDate,
							@OperationsPerformedBy,
							CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							[Priority]
					FROM #RateTagConfigurationDetails R

				END

				SELECT TOP 1 Id FROM RateTagConfiguration WHERE CreatedDateTime = @CurrentDate
			END
		END
		ELSE
		RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
