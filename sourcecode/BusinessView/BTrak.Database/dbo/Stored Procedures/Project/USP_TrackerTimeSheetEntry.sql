CREATE PROCEDURE [dbo].[USP_TrackerTimeSheetEntry]
(
   @StartDate DATE = NULL,
   @EndDate DATE = NULL,
   @CompanyIds NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
		DECLARE @TimeSheet TABLE
		(
			Id UNIQUEIDENTIFIER,
			UserId UNIQUEIDENTIFIER,
			InTime DATETIMEOFFSET,
			InTimeTimeZone UNIQUEIDENTIFIER,
			RowNumber INT,
			OutTime DATETIMEOFFSET NULL,
			OutTimeTimeZone UNIQUEIDENTIFIER NULL,
			PunchCardBased BIT NULL,
			SameDateOutTime DATETIMEOFFSET NULL,
			UpComingInTime DATETIMEOFFSET NULL,
			UpCommingDateOutTime DATETIMEOFFSET NULL --if user stayed after midnight and before the next in time
		)

		INSERT INTO @TimeSheet(Id, UserId, InTime, InTimeTimeZone, RowNumber, OutTime, OutTimeTimeZone)
		SELECT Id, UserId, InTime, InTimeTimeZone, ROW_NUMBER() OVER (ORDER BY InTime), OutTime, InTimeTimeZone FROM [TimeSheet] WHERE 
		OutTime IS NULL 
		--OR 
		--DATEADD(DAY, 2, InTime) > GETUTCDATE()

		DECLARE @MinRow INT
		DECLARE @MaxRow INT
		SET @MinRow = 1
		SET @MaxRow = (SELECT MAX(RowNumber) FROM @TimeSheet)

		WHILE(@MinRow <= @MaxRow)
		BEGIN
	
			DECLARE @InTime DATETIMEOFFSET,
				@OutTimeTimeZone UNIQUEIDENTIFIER,
				@UserId UNIQUEIDENTIFIER,
				@OffSetMinutes INT,
				@PreviousDate DATE,
				@UpComingInTime DATETIMEOFFSET,
				@SameDateOutTime DATETIMEOFFSET,
				@UpCommingDateOutTime DATETIMEOFFSET,
				@CompanyId UNIQUEIDENTIFIER,
				@MaxHours INT

			SET @UserId = (SELECT TOP 1 UserId FROM @TimeSheet WHERE RowNumber = @MinRow)
			SET @CompanyId = (SELECT TOP 1 CompanyId FROM [user] WHERE Id = @UserId)
			SET @MaxHours = CAST ((SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MaximumWorkingHours') AS INT)

			IF(@MaxHours IS NULL OR @MaxHours = 0)
			BEGIN
				SET @MaxHours = 16
			END
			
			UPDATE @TimeSheet SET PunchCardBased = (SELECT TOP 1 PunchCardBased FROM dbo.Ufn_GetUsersModeType(NULL, @UserId, NULL)) WHERE RowNumber = @MinRow
			SET @InTime = (SELECT TOP 1 InTime FROM @TimeSheet WHERE RowNumber = @MinRow)
			SET @OutTimeTimeZone = (SELECT TOP 1 InTimeTimeZone FROM @TimeSheet WHERE RowNumber = @MinRow)
			SET @OffSetMinutes = 
				CASE WHEN 
					(SELECT TOP 1 OffsetMinutes FROM TimeZone WHERE Id = @OutTimeTimeZone) IS NOT NULL 
					THEN (SELECT TOP 1 OffsetMinutes FROM TimeZone WHERE Id = @OutTimeTimeZone) 
					ELSE 0 
				END

			IF((SELECT TOP 1 PunchCardBased FROM @TimeSheet WHERE RowNumber = @MinRow) <> 1
				OR (SELECT TOP 1 PunchCardBased FROM @TimeSheet WHERE RowNumber = @MinRow) IS NULL)
			BEGIN

				SET @SameDateOutTime = 
				(
					SELECT TOP 1 TrackedDateTime FROM UserActivityTrackerStatus WHERE UserId = @UserId AND 
					--CAST(DATEADD(MINUTE, @OffSetMinutes, TrackedDateTime) AS DATE) = CAST(@InTime AS DATE) 
					CAST(TrackedDateTime AS DATE) = CAST(@InTime AS DATE) 
					AND (KeyStroke <> 0 OR MouseMovement <> 0)
					ORDER BY TrackedDateTime DESC
				)
				SET @SameDateOutTime = TODATETIMEOFFSET(DATEADD(MINUTE, @OffSetMinutes, @SameDateOutTime), @OffSetMinutes)

				UPDATE @TimeSheet SET SameDateOutTime = @SameDateOutTime WHERE RowNumber = @MinRow

				/**
				* Calculating upcoming time if user statyed after midnight
				*/
				SET @UpComingInTime = 
				(
					SELECT TOP 1 InTime 
						FROM TimeSheet 
						WHERE [UserId] = @UserId AND InTime > @SameDateOutTime 
						ORDER BY InTime
				)

				UPDATE @TimeSheet SET UpComingInTime = @UpComingInTime WHERE RowNumber = @MinRow

				IF
				(
					@UpComingInTime IS NOT NULL AND 
					(
						SELECT TOP 1 TrackedDateTime 
							FROM UserActivityTrackerStatus 
							WHERE DATEADD(MINUTE, @OffSetMinutes, TrackedDateTime) < @UpComingInTime 
							AND DATEADD(MINUTE, @OffSetMinutes, TrackedDateTime) > @SameDateOutTime 
							AND UserId = @UserId
							AND CAST(TrackedDateTime AS DATE) <> CAST(@InTime AS DATE) 
							AND (KeyStroke <> 0 OR MouseMovement <> 0)
							ORDER BY TrackedDateTime DESC
					) IS NOT NULL
				)
				BEGIN
					SET @UpCommingDateOutTime = 
					(
						SELECT TOP 1 TrackedDateTime 
							FROM UserActivityTrackerStatus 
							WHERE DATEADD(MINUTE, @OffSetMinutes, TrackedDateTime) < @UpComingInTime 
							AND DATEADD(MINUTE, @OffSetMinutes, TrackedDateTime) > @SameDateOutTime 
							AND UserId = @UserId
							AND CAST(TrackedDateTime AS DATE) <> CAST(@InTime AS DATE) 
							AND (KeyStroke <> 0 OR MouseMovement <> 0)
							ORDER BY TrackedDateTime DESC
					)
					SET @UpCommingDateOutTime = TODATETIMEOFFSET(DATEADD(MINUTE, @OffSetMinutes, @UpCommingDateOutTime), @OffSetMinutes)

					UPDATE @TimeSheet SET UpCommingDateOutTime = @UpCommingDateOutTime WHERE RowNumber = @MinRow
				END

				/**
				* If user is in active for 4 hours setting outtime as the last active track time
				*/
				IF
				(
					@SameDateOutTime IS NOT NULL 
					AND @UpCommingDateOutTime IS NULL
					AND DATEADD(HOUR, 4, @SameDateOutTime) < TODATETIMEOFFSET(DATEADD(MINUTE, @OffSetMinutes, GETUTCDATE()), @OffSetMinutes)
					AND @InTime < @SameDateOutTime
				)
				BEGIN
					--UPDATE @TimeSheet SET OutTime = @SameDateOutTime, OutTimeTimeZone = @OutTimeTimeZone WHERE RowNumber = @MinRow
					UPDATE TimeSheet SET OutTime = @SameDateOutTime, OutTimeTimeZone = @OutTimeTimeZone WHERE Id = (SELECT TOP 1 Id FROM @TimeSheet WHERE RowNumber = @MinRow)
				END
				ELSE IF 
				(
					@UpCommingDateOutTime IS NOT NULL
					AND DATEADD(HOUR, 4, @UpCommingDateOutTime) < TODATETIMEOFFSET(DATEADD(MINUTE, @OffSetMinutes, GETUTCDATE()), @OffSetMinutes)
					AND @InTime < @UpCommingDateOutTime
				)
				BEGIN
					--UPDATE @TimeSheet SET OutTime = @UpCommingDateOutTime, OutTimeTimeZone = @OutTimeTimeZone WHERE RowNumber = @MinRow
					UPDATE TimeSheet SET OutTime = @UpCommingDateOutTime, OutTimeTimeZone = @OutTimeTimeZone WHERE Id = (SELECT TOP 1 Id FROM @TimeSheet WHERE RowNumber = @MinRow)
				END
				ELSE IF
				(
					(@SameDateOutTime IS NULL OR @InTime > @SameDateOutTime)
					AND 
					(@UpCommingDateOutTime IS NULL OR @InTime > @UpCommingDateOutTime)
					AND DATEDIFF(hour, @InTime, GETUTCDATE()) > 16
				)
				BEGIN
					--UPDATE @TimeSheet SET OutTime = DATEADD(minute,1,@InTime), OutTimeTimeZone = @OutTimeTimeZone WHERE RowNumber = @MinRow
					UPDATE TimeSheet SET OutTime = DATEADD(minute,1,@InTime), OutTimeTimeZone = @OutTimeTimeZone WHERE Id = (SELECT TOP 1 Id FROM @TimeSheet WHERE RowNumber = @MinRow)
				END

				/**
				* If user got active after 4 hours setting setting the outtime null so that in next intervel it may set finish time
				*/
				--IF
				--(
				--	(SELECT TOP 1 OutTime FROM @TimeSheet WHERE RowNumber = @MinRow) IS NOT NULL 
				--	AND @OutTime < TODATETIMEOFFSET(DATEADD(MINUTE, @OffSetMinutes, GETUTCDATE()), @OffSetMinutes)
				--)
				--BEGIN
				--	--UPDATE @TimeSheet SET OutTime = NULL, OutTimeTimeZone = NULL WHERE RowNumber = @MinRow
				--	UPDATE TimeSheet SET OutTime = NULL, OutTimeTimeZone = NULL WHERE Id = (SELECT TOP 1 Id FROM @TimeSheet WHERE RowNumber = @MinRow)
				--END
			END
			ELSE IF(DATEADD(HOUR, @MaxHours, @InTime) < TODATETIMEOFFSET(DATEADD(MINUTE, @OffSetMinutes, GETUTCDATE()), @OffSetMinutes))
			BEGIN

				/**
				* Calculating upcoming time if user statyed after midnight
				*/
				SET @UpComingInTime = 
				(
					SELECT TOP 1 InTime 
						FROM TimeSheet 
						WHERE [UserId] = @UserId AND InTime > @SameDateOutTime 
						ORDER BY InTime
				)

				UPDATE @TimeSheet SET UpComingInTime = @UpComingInTime WHERE RowNumber = @MinRow

				IF(@UpComingInTime IS NULL)
				BEGIN
					--UPDATE @TimeSheet SET OutTime = DATEADD(hour,@MaxHours,@InTime), OutTimeTimeZone = @OutTimeTimeZone WHERE RowNumber = @MinRow
					UPDATE TimeSheet SET OutTime = DATEADD(hour,@MaxHours,@InTime), OutTimeTimeZone = @OutTimeTimeZone WHERE Id = (SELECT TOP 1 Id FROM @TimeSheet WHERE RowNumber = @MinRow)
				END
				ELSE IF(@UpComingInTime IS NOT NULL)
				BEGIN
					--UPDATE @TimeSheet SET OutTime = DATEADD(hour,-1,@UpComingInTime), OutTimeTimeZone = @OutTimeTimeZone WHERE RowNumber = @MinRow
					UPDATE TimeSheet SET OutTime = DATEADD(hour,-1,@UpComingInTime), OutTimeTimeZone = @OutTimeTimeZone WHERE Id = (SELECT TOP 1 Id FROM @TimeSheet WHERE RowNumber = @MinRow)
				END
			END

			SET @MinRow = @MinRow + 1
		END
		--SELECT UserId,InTime,RowNumber,OutTime,PunchCardBased,SameDateOutTime,UpComingInTime,UpCommingDateOutTime FROM @TimeSheet order by InTime desc

	END TRY 
	BEGIN CATCH
		 THROW
	END CATCH
END
