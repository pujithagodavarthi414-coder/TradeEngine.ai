CREATE PROCEDURE [dbo].[USP_UpsertRateTag]
(
 @RateTagId UNIQUEIDENTIFIER = NULL,
 @RateTagName NVARCHAR(50) = NULL,
 @RateTagForIds XML = NULL,
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
 @MaxTime INT = NULL,
 @MinTime INT = NULL,
 @RoleId UNIQUEIDENTIFIER = NULL,
 @BranchId UNIQUEIDENTIFIER = NULL,
 @EmployeeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN

		    IF(@IsArchived = 1 AND @RateTagId IS NOT NULL)
		    BEGIN
		          DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	              IF(EXISTS(SELECT Id FROM EmployeeRateTag WHERE RateTagId = @RateTagId AND InactiveDateTime IS NULL))
	              BEGIN
	              SET @IsEligibleToArchive = 'ThisRateTagUsedInEmployeeRateTagPleaseDeleteTheDependenciesAndTryAgain'
	              END
		          IF(@IsEligibleToArchive <> '1')
		          BEGIN
		             RAISERROR (@isEligibleToArchive,11, 1)
		         END
	        END

			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@RateTagId =  '00000000-0000-0000-0000-000000000000') SET @RateTagId = NULL

			IF (@RateTagName = ' ' ) SET @RateTagName = NULL

			IF (@RateTagName IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'RateTagName')

			END
			ELSE
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @RateTagIdCount INT = (SELECT COUNT(1) FROM RateTag WHERE Id = @RateTagId AND CompanyId = @CompanyId)
				
				DECLARE @RateTagCount INT = (SELECT COUNT(1) FROM RateTag WHERE RateTagName = @RateTagName AND (@RateTagId IS NULL OR Id <> @RateTagId) AND CompanyId = @CompanyId) 

				IF (@RateTagIdCount = 0 AND @RateTagId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'RateTag')

				END
				ELSE IF(@RateTagCount > 0)
				BEGIN
				
					RAISERROR(50001,16,1,'RateTag')

				END
				ELSE
				BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @RateTagId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM RateTag WHERE Id = @RateTagId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@RateTagId IS NULL)
						BEGIN

						SET @RateTagId = NEWID()

						INSERT INTO RateTag(Id,
											RateTagName,
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
											[MaxTime],
											[MinTime],
											RoleId,
											BranchId,
											EmployeeId)
								     SELECT @RateTagId,
								    	    @RateTagName,
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
											@MaxTime,
											@MinTime,
											@RoleId,
											@BranchId,
											@EmployeeId

					END
					ELSE
					BEGIN
						
						 UPDATE [RateTag] 
						    SET [RateTagName] = @RateTagName,
								[RatePerHour]	= @RatePerHour,
								[RatePerHourMon] = @RatePerHourMon,
								[RatePerHourTue] = @RatePerHourTue,
								[RatePerHourWed] = @RatePerHourWed,
								[RatePerHourThu] = @RatePerHourThu,
								[RatePerHourFri] = @RatePerHourFri,
								[RatePerHourSat] = @RatePerHourSat,
								[RatePerHourSun] = @RatePerHourSun,
								[MaxTime] = @MaxTime,
								[MinTime] = @MinTime,
								[CompanyId] = @CompanyId,
								[UpdatedDateTime] = @CurrentDate,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								RoleId = @RoleId,
								BranchId = @BranchId,
								EmployeeId = @EmployeeId
								WHERE Id = @RateTagId

								DELETE FROM RateTagDetails WHERE RateTagId = @RateTagId
					END
					
					DECLARE @RateTagDetails TABLE
                    (
                       RateTagDetailsId UNIQUEIDENTIFIER DEFAULT NEWID(),
                       RateTagForId UNIQUEIDENTIFIER,
					   RateTagForType NVARCHAR(50),
					   RateTagForName NVARCHAR(250),
                       RateTagId UNIQUEIDENTIFIER
                    )

					INSERT INTO @RateTagDetails(RateTagForId,RateTagForType,RateTagForName,RateTagId)
                    SELECT x.value('RateTagForId[1]','UNIQUEIDENTIFIER'), 
						   x.value('RateTagForType[1]','NVARCHAR(50)'), 
						   x.value('RateTagForName[1]','NVARCHAR(250)'),
						   @RateTagId
                    FROM @RateTagForIds.nodes('/GenericListOfRateTagForTypeModel/ListItems/RateTagForTypeModel') XmlData(x)

                    INSERT INTO [dbo].[RateTagDetails](
                    [Id],
                    [RateTagForId],
					[RateTagForType],
	                [RateTagForTypeName],
					[RateTagId],
                    [CreatedDateTime],
                    [CreatedByUserId])
                    SELECT RateTagDetailsId,
                    RateTagForId,
					RateTagForType,
					RateTagForName,
                    RateTagId,
                    @Currentdate,
                    @OperationsPerformedBy
                    FROM @RateTagDetails

					SELECT Id FROM RateTag WHERE Id = @RateTagId

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
GO
