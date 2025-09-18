CREATE PROCEDURE [dbo].[USP_UpsertActivityTrackerStatus](
	@DeviceId NVARCHAR(500) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserIpAddress NVARCHAR(255) = NULL,
	@TimeZone NVARCHAR(100) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRY

			DECLARE 
				@companyId UNIQUEIDENTIFIER = NULL,
				@UserId UNIQUEIDENTIFIER ,
				@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
				@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop (NOLOCK) WHERE DesktopDeviceId = @DeviceId),
				@CurrentClientDate DATETIME,
                @OffsetMinutes INT

			IF(@OperationsPerformedBy = @EmptyGuid)
			BEGIN
				SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
				IF(@OperationsPerformedBy IS NULL)
				BEGIN
					SET @OperationsPerformedBy = @EmptyGuid
				END
			END

			SET @UserId = (SELECT Id FROM [User] (NOLOCK) WHERE Id = @OperationsPerformedBy AND IsActive = 1 AND InActiveDateTime IS NULL)

			SET @OffsetMinutes = (SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone)
            SET @CurrentClientDate = DATEADD(MINUTE, CASE WHEN @OffsetMinutes IS NOT NULL THEN @OffsetMinutes ELSE 0 END,GETUTCDATE()) 
			
			IF(@UserIpAddress IS NULL)
			BEGIN
				SET @UserIpAddress = (SELECT TOP 1 IpAddress FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId AND [Date] = CONVERT(DATE,@CurrentClientDate))
			END

			IF(@TimeZone IS NULL)
			BEGIN
				SET @TimeZone = (SELECT TOP 1 TimeZone FROM TimeZone (NOLOCK) WHERE Id = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId AND [Date] = CONVERT(DATE,@CurrentClientDate)))
			END

			DECLARE @IdToUpdate UNIQUEIDENTIFIER
			SET @IdToUpdate = (SELECT TOP 1 Id FROM ActivityTrackerStatus (NOLOCK) WHERE 
				@DesktopId = DesktopId
				AND [Date] = CONVERT(DATE,@CurrentClientDate)
				ORDER BY LastActiveDateTime DESC)

			IF(@IdToUpdate IS NULL)
			BEGIN
						
				INSERT INTO [dbo].[ActivityTrackerStatus](
												[Id],
												[UserId],
												[LastActiveDateTime],
												[Date],
												[IpAddress],
												[OffSet],
												[TimeZoneId],
												[DesktopId]
												)
				SELECT NEWID(),
						@UserId,
						GETUTCDATE(),
						@CurrentClientDate,
						@UserIpAddress,
						(CASE WHEN 
							(SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone) IS NULL 
							THEN 0 
							ELSE (SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone) END),
						(SELECT TOP 1 Id FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone),
						@DesktopId

				SELECT 'Inserted Successfully'
			END
			ELSE
			BEGIN
				UPDATE [dbo].[ActivityTrackerStatus] SET
									[UserId] = @UserId,
									[LastActiveDateTime] = GETUTCDATE(),
									[IpAddress] = @UserIpAddress,
									[OffSet] = (CASE WHEN 
									(SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone) IS NULL THEN 0 ELSE 
									(SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone) END),
									[TimeZoneId] = (SELECT TOP 1 Id FROM TimeZone (NOLOCK) WHERE TimeZone = @TimeZone)
									WHERE Id = @IdToUpdate

				SELECT 'Updated Successfully'
			END

		END TRY
		
		BEGIN CATCH
        
		    THROW

	    END CATCH
END