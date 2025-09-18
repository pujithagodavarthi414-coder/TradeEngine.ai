CREATE PROCEDURE [dbo].[USP_UpdateRateTagConfiguration]
(
	@RateTagConfigurationId UNIQUEIDENTIFIER = NULL,
	@RateTagRoleBranchConfigurationId UNIQUEIDENTIFIER = NULL,
	@RateTagId UNIQUEIDENTIFIER = NULL,
	@RateTagCurrencyId UNIQUEIDENTIFIER = NULL,
	@RateTagForId UNIQUEIDENTIFIER = NULL,
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

			IF (@RateTagConfigurationId =  '00000000-0000-0000-0000-000000000000') SET @RateTagConfigurationId = NULL
			
			IF (@RateTagId IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'RateTag')

			END
			ELSE
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @RateTagConfigurationIdCount INT = (SELECT COUNT(1) FROM RateTagConfiguration WHERE Id = @RateTagConfigurationId)

				DECLARE @RateTagPriorityCount INT = (SELECT COUNT(1) FROM RateTagConfiguration WHERE RateTagRoleBranchConfigurationId = @RateTagRoleBranchConfigurationId AND [Priority] = @Priority AND @Priority IS NOT NULL AND (@RateTagConfigurationId IS NULL OR Id <> @RateTagConfigurationId))

				IF (@RateTagConfigurationIdCount = 0 AND @RateTagConfigurationId IS NOT NULL )
				BEGIN
					RAISERROR(50002,16,1,'RateTagConfiguration')
				END

				IF (@RateTagPriorityCount > 0)
				BEGIN
					 RAISERROR('PriorityShouldBeUnique',11,1)
				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @RateTagConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM RateTagConfiguration WHERE Id = @RateTagConfigurationId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest <> 1) 
					BEGIN
						RAISERROR (50008,11, 1)
					END
					ELSE
					BEGIN		
					
						    DECLARE @CurrentDate DATETIME = GETDATE();


							UPDATE [RateTagConfiguration] 
						    SET [RateTagRoleBranchConfigurationId] = @RateTagRoleBranchConfigurationId,
								[RateTagId] = @RateTagId,
								[RateTagCurrencyId] = @RateTagCurrencyId,
								[RatePerHour]	= @RatePerHour,
								[RatePerHourMon] = @RatePerHourMon,
								[RatePerHourTue] = @RatePerHourTue,
								[RatePerHourWed] = @RatePerHourWed,
								[RatePerHourThu] = @RatePerHourThu,
								[RatePerHourFri] = @RatePerHourFri,
								[RatePerHourSat] = @RatePerHourSat,
								[RatePerHourSun] = @RatePerHourSun,
								[UpdatedDateTime] = @CurrentDate,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								[Priority] = @Priority
								WHERE Id = @RateTagConfigurationId
					
					END
					
					SELECT Id FROM [RateTagConfiguration] WHERE Id = @RateTagConfigurationId

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
