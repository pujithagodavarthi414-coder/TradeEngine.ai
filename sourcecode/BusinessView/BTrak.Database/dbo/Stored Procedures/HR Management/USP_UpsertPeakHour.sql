CREATE PROCEDURE [dbo].[USP_UpsertPeakHour]
(
 @PeakHourId UNIQUEIDENTIFIER = NULL,
 @PeakHourOn NVARCHAR(250) = NULL,
 @FilterType NVARCHAR(10) = NULL,
 @IsPeakHour BIT = NULL,
 @PeakHourFrom TIME = NULL,
 @PeakHourTo TIME = NULL,
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
			
			IF (@PeakHourOn IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'PeakHour')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @PeakHourIdCount INT = (SELECT COUNT(1) FROM PeakHour WHERE Id = @PeakHourId AND CompanyId = @CompanyId)
				
				IF (@PeakHourIdCount = 0 AND @PeakHourId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'PeakHour')

				END
				ELSE
				BEGIN
						
					IF(@IsArchived IS NULL)
						SET @IsArchived  = 0
					IF(@IsPeakHour IS NULL)
						SET @IsPeakHour = 0;

						DECLARE @CurrentDate DATETIME = GETDATE()

					SET @PeakHourIdCount = (SELECT COUNT(1) FROM PeakHour PH WHERE PeakHourOn = (CASE WHEN @FilterType = 'D' AND Id <> @PeakHourId THEN CONVERT(VARCHAR,CONVERT(DATE, CONVERT(DATETIME,@PeakHourOn), 103)) 
																									WHEN @FilterType != 'D' THEN @PeakHourOn END) AND PH.PeakHourFrom = @PeakHourFrom 
																			AND PH.PeakHourTo = @PeakHourTo AND ISNULL(PH.IsPeakHour, 0) = @IsPeakHour 
																			AND COALESCE( PH.InActiveDateTime, @CurrentDate ) = CASE WHEN @IsArchived = 1 THEN PH.InActiveDateTime ELSE @CurrentDate END
																			AND CompanyId = @CompanyId AND PH.Id <> @PeakHourId)
					
					IF(@PeakHourIdCount  > 0 ) 
						RAISERROR(50001,16,1,'PeakHour')
					ELSE
					BEGIN


						IF(@PeakHourId IS NULL OR @FilterType = 'W' )
						BEGIN
							
							INSERT INTO PeakHour(Id,
													PeakHourOn,
													FilterType,
													IsPeakHour,
													PeakHourFrom,
													PeakHourTo,
													CreatedDateTime,
													CreatedByUserId,
													InActiveDateTime,
													CompanyId
										)
										SELECT	 NEWID(),
													CASE WHEN @FilterType = 'D' THEN CONVERT(VARCHAR,CONVERT(DATE, CONVERT(DATETIME,[Value]), 103)) ELSE [Value] END,
													@FilterType,
													@IsPeakHour,
													@PeakHourFrom,
													@PeakHourTo,
													@CurrentDate,
													@OperationsPerformedBy,
													CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
													@CompanyId
													FROM dbo.Ufn_StringSplit(@PeakHourOn, ',')
													WHERE [Value] NOT IN (SELECT  PeakHourOn FROM  PeakHour WHERE CompanyId = @CompanyId)
								
										
								UPDATE PH 
									SET IsPeakHour = @IsPeakHour,
										[PeakHourFrom] = @PeakHourFrom,
										[PeakHourTo] = @PeakHourTo,
										[UpdatedDateTime] = @CurrentDate,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
								FROM PeakHour PH
								INNER JOIN dbo.Ufn_StringSplit(@PeakHourOn, ',') ON CASE WHEN @FilterType = 'D' THEN  CONVERT(VARCHAR,CONVERT(DATE, CONVERT(DATETIME,[Value]), 103)) ELSE [Value] END = PeakHourOn AND CompanyId = @CompanyId

						END
						ELSE
						BEGIN
						
							UPDATE PeakHour 
								SET [PeakHourOn] = CASE WHEN @FilterType = 'D' THEN CONVERT(VARCHAR,CONVERT(DATE, CONVERT(DATETIME,@PeakHourOn), 103)) ELSE @PeakHourOn END,
									[FilterType] = @FilterType,
									[IsPeakHour]	= @IsPeakHour,
									[PeakHourFrom] = @PeakHourFrom,
									[PeakHourTo] = @PeakHourTo,
									[CompanyId] = @CompanyId,
									[UpdatedDateTime] = @CurrentDate,
									[UpdatedByUserId] = @OperationsPerformedBy,
									[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
									WHERE Id = @PeakHourId
						END

						
						SELECT Id FROM PeakHour WHERE Id = @PeakHourId

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