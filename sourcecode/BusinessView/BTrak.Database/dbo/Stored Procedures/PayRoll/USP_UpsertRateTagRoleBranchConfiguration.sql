CREATE PROCEDURE [dbo].[USP_UpsertRateTagRoleBranchConfiguration]
(
	@RateTagRoleBranchConfigurationId UNIQUEIDENTIFIER = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@RoleId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@Priority INT = NULL,
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
			
			IF (@BranchId =  '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

			IF (@RoleId =  '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL

			IF (@RateTagRoleBranchConfigurationId =  '00000000-0000-0000-0000-000000000000') SET @RateTagRoleBranchConfigurationId = NULL
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @RateTagRoleBranchConfigurationPriorityCount INT = 0

			SET @RateTagRoleBranchConfigurationPriorityCount = (SELECT COUNT(1) FROM RateTagRoleBranchConfiguration WHERE [Priority] = @Priority AND CompanyId = @CompanyId AND (@RateTagRoleBranchConfigurationId IS NULL OR Id <> @RateTagRoleBranchConfigurationId))

			DECLARE @RateTagRoleBranchConfigurationIdCount INT = (SELECT COUNT(1) FROM RateTagRoleBranchConfiguration WHERE Id = @RateTagRoleBranchConfigurationId)

			IF(@RateTagRoleBranchConfigurationPriorityCount > 0)
			BEGIN

			    RAISERROR('PriorityShouldBeUnique',11,1)

			END
			ELSE IF (@RateTagRoleBranchConfigurationIdCount = 0 AND @RateTagRoleBranchConfigurationId IS NOT NULL )
			BEGIN
				RAISERROR(50002,16,1,'RateTagRoleBranchConfiguration')
			END
			ELSE
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @RateTagRoleBranchConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM RateTagRoleBranchConfiguration WHERE Id = @RateTagRoleBranchConfigurationId ) = @TimeStamp THEN 1 ELSE 0 END END )

				IF (@IsLatest <> 1) 
				BEGIN
					RAISERROR (50008,11, 1)
				END
				ELSE
				BEGIN

			        	DECLARE @RateTagtIdCount INT

						IF(@BranchId IS NULL AND @RoleId IS NOT NULL)
						BEGIN

							SET @RateTagtIdCount = (SELECT COUNT(1) FROM RateTagRoleBranchConfiguration E 
													WHERE (@RateTagRoleBranchConfigurationId IS NULL OR E.Id <> @RateTagRoleBranchConfigurationId) AND E.RoleId = @RoleId AND E.BranchId IS NULL 
													AND( CONVERT(DATE, E.StartDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
															OR CONVERT(DATE, E.EndDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
															OR CONVERT(DATE, @StartDate) BETWEEN CONVERT(DATE, E.StartDate) AND CONVERT(DATE, E.EndDate)
															OR CONVERT(DATE, @EndDate) BETWEEN CONVERT(DATE, E.StartDate) AND CONVERT(DATE, E.EndDate)
													)
													AND E.InActiveDateTime IS NULL)

						END
						ELSE IF(@RoleId IS NULL AND @BranchId IS NOT NULL)
						BEGIN

							SET @RateTagtIdCount = (SELECT COUNT(1) FROM RateTagRoleBranchConfiguration E 
													WHERE (@RateTagRoleBranchConfigurationId IS NULL OR E.Id <> @RateTagRoleBranchConfigurationId) AND E.BranchId = @BranchId AND E.RoleId IS NULL 
													AND( CONVERT(DATE, E.StartDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
															OR CONVERT(DATE, E.EndDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
															OR CONVERT(DATE, @StartDate) BETWEEN CONVERT(DATE, E.StartDate) AND CONVERT(DATE, E.EndDate)
															OR CONVERT(DATE, @EndDate) BETWEEN CONVERT(DATE, E.StartDate) AND CONVERT(DATE, E.EndDate)
													)
													AND E.InActiveDateTime IS NULL)

						END
						ELSE IF(@RoleId IS NOT NULL AND @BranchId IS NOT NULL)
						BEGIN

							SET @RateTagtIdCount = (SELECT COUNT(1) FROM RateTagRoleBranchConfiguration E 
													WHERE (@RateTagRoleBranchConfigurationId IS NULL OR E.Id <> @RateTagRoleBranchConfigurationId) AND E.BranchId = @BranchId AND E.RoleId = @RoleId
													AND( CONVERT(DATE, E.StartDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
															OR CONVERT(DATE, E.EndDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
															OR CONVERT(DATE, @StartDate) BETWEEN CONVERT(DATE, E.StartDate) AND CONVERT(DATE, E.EndDate)
															OR CONVERT(DATE, @EndDate) BETWEEN CONVERT(DATE, E.StartDate) AND CONVERT(DATE, E.EndDate)
													)
													AND E.InActiveDateTime IS NULL)

						END

						IF (@RateTagtIdCount > 0)
						BEGIN
							RAISERROR(50027,16,1,'RateTagRoleBranchDateStartOrEndDateMatchesWithOtherStartDateOrEndDate')
						END


						DECLARE @CurrentDate DATETIME = GETDATE();

						IF(@RateTagRoleBranchConfigurationId IS NULL)
						BEGIN

						SET @RateTagRoleBranchConfigurationId = NEWID();

						INSERT INTO [dbo].[RateTagRoleBranchConfiguration](
			 	     		          [Id],
			 	     		          [BranchId],
			 						  [RoleId],
									  [StartDate],
									  [EndDate],
									  [Priority],
			 	     		          [CreatedDateTime],
			 	     		          [CreatedByUserId],
									  CompanyId)
			 	     		   SELECT @RateTagRoleBranchConfigurationId,
			 	     		          @BranchId,
			 						  @RoleId,
									  @StartDate,
									  @EndDate,
									  @Priority,
			 	     		          @Currentdate,
			 	     		          @OperationsPerformedBy,
									  @CompanyId

						END
						ELSE
						BEGIN

							UPDATE [RateTagRoleBranchConfiguration] 
						    SET [BranchId] = @BranchId,
							    [RoleId] = @RoleId,
								[StartDate] = @StartDate,
								[EndDate] = @EndDate,
								[Priority] = @Priority,
								[UpdatedDateTime] = @CurrentDate,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
								WHERE Id = @RateTagRoleBranchConfigurationId

						END

					
					END
				
				SELECT Id FROM [RateTagRoleBranchConfiguration] WHERE Id = @RateTagRoleBranchConfigurationId

			END
		END
		ELSE
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
