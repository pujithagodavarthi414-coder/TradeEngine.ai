CREATE PROCEDURE [dbo].[USP_UpsertDaysOfWeekConfiguration]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @DayOfWeekId UNIQUEIDENTIFIER = NULL,
   @PartsOfDayId UNIQUEIDENTIFIER = NULL,
   @IsWeekEnd BIT = NULL,
   @FromTime TIME = NULL,
   @ToTime TIME = NULL,
   @ActiveFrom DATETIME,
   @ActiveTo DATETIME = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsBankHoliday BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    
	BEGIN TRY
		IF(@BranchId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE IF(@PartsOfDayId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ShiftsRateSheetForId')

		END
		ELSE IF(@DayOfWeekId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DayOfWeekId')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ActiveFrom')

		END
		ELSE IF(@FromTime IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'FromTime')

		END
		ELSE IF(@ToTime IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ToTime')

		END

		
		DECLARE @DaysCount INT = 0
		DECLARE @TimeOverlapCount INT = 0
		
		IF(@ActiveTo IS NULL)
		BEGIN
			SET @DaysCount = (SELECT COUNT(1) FROM DaysOfWeekConfiguration WHERE BranchId = @BranchId AND DaysOfWeekId = @DayOfWeekId AND PartsOfDayId = @PartsOfDayId 
																										  AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))

			SET @TimeOverlapCount = (SELECT COUNT(1) FROM DaysOfWeekConfiguration WHERE BranchId = @BranchId AND DaysOfWeekId = @DayOfWeekId AND PartsOfDayId = @PartsOfDayId 
																										  AND (Id <> @Id OR @Id IS NULL) AND
																						((@FromTime < FromTime AND @ToTime > ToTime) OR (@FromTime > FromTime AND @ToTime < ToTime AND @FromTime < ToTime)
																						OR (@FromTime < FromTime AND @ToTime < ToTime) OR (@FromTime > FromTime AND @ToTime > ToTime AND @FromTime < ToTime)
																						OR (@FromTime = FromTime AND @ToTime = ToTime)) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN
			SET @DaysCount = (SELECT COUNT(1) FROM DaysOfWeekConfiguration WHERE BranchId = @BranchId AND DaysOfWeekId = @DayOfWeekId AND PartsOfDayId = @PartsOfDayId 
																										  AND (Id <> @Id OR @Id IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))
			
			SET @TimeOverlapCount = (SELECT COUNT(1) FROM DaysOfWeekConfiguration WHERE BranchId = @BranchId AND DaysOfWeekId = @DayOfWeekId AND PartsOfDayId = @PartsOfDayId 
																										  AND (Id <> @Id OR @Id IS NULL) AND
																						((@FromTime < FromTime AND @ToTime > ToTime) OR (@FromTime > FromTime AND @ToTime < ToTime AND @FromTime < ToTime)
																						OR (@FromTime < FromTime AND @ToTime < ToTime) OR (@FromTime > FromTime AND @ToTime > ToTime AND @FromTime < ToTime)
																						OR (@FromTime = FromTime AND @ToTime = ToTime)) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

		IF(@DaysCount > 0)
		BEGIN
			
			RAISERROR(50001,16, 2, 'DaysOfWeekConfiguration')

		END
		IF(@TimeOverlapCount > 0)
		BEGIN
			RAISERROR(50001,16, 2, 'TimeOverLapInDaysOfWeek')
		END

		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @IsLatest BIT = (CASE WHEN @Id  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [DaysOfWeekConfiguration] WHERE Id = @Id) = @TimeStamp
			         									THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
			BEGIN
				
				IF(@Id IS NULL)
				BEGIN
					
					INSERT INTO [dbo].[DaysOfWeekConfiguration](
																[Id],
																[BranchId],
																[DaysOfWeekId],
																[PartsOfDayId],
																[IsWeekend],
																[ActiveFrom],
																[ActiveTo],
																[FromTime],
																[ToTime],
																[CreatedByUserId],
																[CreatedDateTime],
																[IsBankHoliday]
																)
														SELECT NEWID(),
															   @BranchId,
															   @DayOfWeekId,
															   @PartsOfDayId,
															   @IsWeekEnd,
															   @ActiveFrom,
															   @ActiveTo,
															   @FromTime,
															   @ToTime,
															   @OperationsPerformedBy,
															   GETDATE(),
															   @IsBankHoliday
					SELECT 'Inserted Successfully'

				END
				ELSE
				BEGIN

					UPDATE [dbo].[DaysOfWeekConfiguration]
						SET [BranchId] = @BranchId,
						[DaysOfWeekId] = @DayOfWeekId,
						[PartsOfDayId] = @PartsOfDayId,
						[IsWeekend] = @IsWeekEnd,
						[ActiveFrom] = @ActiveFrom,
						[ActiveTo] = @ActiveTo,
						[FromTime] = @FromTime,
						[ToTime] = @ToTime,
						[IsBankHoliday] = @IsBankHoliday,
						[UpdatedByUserId] = @OperationsPerformedBy,
						[UpdatedDateTime] = GETDATE(),
						[InActiveDateTime] = NULL
					WHERE Id = @Id

					IF(@IsArchived = 1)
					BEGIN
						
						UPDATE [dbo].[DaysOfWeekConfiguration]
							SET [InActiveDateTime] = GETDATE()
							WHERE Id = @Id

					END

					SELECT 'Updated Successfully'
				END

			END
			ELSE
			BEGIN
				RAISERROR (50008,11, 1)
			END
		END
		ELSE
		BEGIN

			RAISERROR (@HavePermission,11, 1)

		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END