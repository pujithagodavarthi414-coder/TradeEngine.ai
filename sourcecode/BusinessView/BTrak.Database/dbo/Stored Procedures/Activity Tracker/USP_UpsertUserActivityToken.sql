CREATE PROCEDURE [dbo].[USP_UpsertUserActivityToken]
(
@UserId UNIQUEIDENTIFIER = NULL ,
@ActivityToken NVARCHAR(800) = NULL,
@DeviceId NVARCHAR(800) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY

		DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
			
		--DECLARE @IsInsert INT = (SELECT COUNT(1) FROM UserActivityToken WHERE UserId = @OperationsPerformedBy)
		DECLARE @IsInsert INT
		DECLARE @DesktopId UNIQUEIDENTIFIER
		SET @DesktopId = (SELECT TOP 1 Id FROM ActivityTrackerDesktop WHERE DesktopDeviceId = @DeviceId)

		IF(@OperationsPerformedBy = @EmptyGuid)
		BEGIN
			SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				SET @OperationsPerformedBy = @EmptyGuid
			END
			SET @IsInsert = (SELECT COUNT(1) FROM UserActivityToken WHERE DesktopId = @DesktopId)
		END
		ELSE
		BEGIN
			SET @IsInsert = (SELECT COUNT(1) FROM UserActivityToken WHERE DesktopId = @DesktopId)
		END

		IF(@IsInsert = 0)
		BEGIN
				
			INSERT INTO [dbo].[UserActivityToken](
								[Id],
								[UserId],
								[ActivityToken],
								[DesktopId],
								[CreatedByUserId],
								[CreatedDateTime]
								)
					SELECT NEWID(),
							@OperationsPerformedBy,
							@ActivityToken,
							@DesktopId,
							@OperationsPerformedBy,
							GETUTCDATE()
		END
		ELSE
		BEGIN

			UPDATE [dbo].[UserActivityToken] 
					SET ActivityToken = @ActivityToken,
						UpdatedByUserId = @OperationsPerformedBy,
						UpdatedDateTime = GETUTCDATE(),
						UserId = @OperationsPerformedBy
				WHERE DesktopId = @DesktopId

		END

		SELECT TOP 1 @ActivityToken AS ActivityToken, 1 AS ProcessEnable, 1 AS ScreenshotEnable

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END