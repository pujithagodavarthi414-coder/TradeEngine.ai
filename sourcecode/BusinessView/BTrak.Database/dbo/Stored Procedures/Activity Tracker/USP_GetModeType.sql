CREATE PROCEDURE [dbo].[USP_GetModeType]
(
	@DeviceId nvarchar(250),
	@DesktopName nvarchar(250),
	@HostAddress nvarchar(250),
	@OSName nvarchar(250),
	@OSVersion nvarchar(150),
	@Platform nvarchar(50),
	@TimeChampVersion nvarchar(50)
)
AS
BEGIN

SET NOCOUNT ON
	BEGIN  TRY
		
		DECLARE @CompanyId UNIQUEIDENTIFIER

		DECLARE @ModeConfig TABLE
		(
			DeviceId NVARCHAR(500),
			CompanyId UNIQUEIDENTIFIER NULL,
			ModeTypeEnum INT,
			ShiftBased BIT,
			PunchCardBased BIT
		)

		IF((SELECT COUNT(*) FROM [dbo].[ActivityTrackerDesktop] WHERE DesktopDeviceId = @DeviceId) > 0)
		BEGIN
			
			SET @CompanyId = (SELECT TOP 1 Id FROM [dbo].[Company] WHERE SiteAddress = @HostAddress ORDER BY CreatedDateTime DESC)

			UPDATE [ActivityTrackerDesktop] SET DesktopName = @DesktopName, CompanyId = @CompanyId, TimechampVersion = @TimeChampVersion WHERE DesktopDeviceId = @DeviceId

			DECLARE @UserId UNIQUEIDENTIFIER = (SELECT TOP 1 U.Id FROM [User] U
													JOIN ActivityTrackerDesktop ATD ON U.DesktopId = ATD.Id
													WHERE ATD.DesktopDeviceId = @DeviceId)

			DECLARE @ModeTypeEnum INT = 1

			IF(@UserId IS NULL)
			BEGIN
				INSERT INTO @ModeConfig (DeviceId, ModeTypeEnum, CompanyId, ShiftBased, PunchCardBased)
				SELECT @DeviceId AS DeviceId, 1 AS ModeTypeEnum, @CompanyId AS CompanyId, 0, 0
			END

			IF(@UserId IS NOT NULL)
			BEGIN
				INSERT INTO @ModeConfig (DeviceId, ModeTypeEnum, CompanyId, ShiftBased, PunchCardBased)
				SELECT TOP 1 DeviceId, ModeTypeEnum, CompanyId, ShiftBased, PunchCardBased FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL)
			END

			SELECT * FROM @ModeConfig
		END
		ELSE
		BEGIN
			SET @CompanyId = NULL

			SET @CompanyId = (SELECT TOP 1 Id FROM [dbo].[Company] WHERE SiteAddress = @HostAddress ORDER BY CreatedDateTime DESC)

			INSERT INTO [dbo].[ActivityTrackerDesktop]
						(Id, 
						DesktopDeviceId, 
						DesktopName, 
						OSName,
						OSVersion,
						[Platform],
						[TimechampVersion],
						CompanyId, 
						CreatedDateTime)
				 VALUES (NEWID(), 
						@DeviceId, 
						@DesktopName, 
						@OSName,
						@OSVersion,
						@Platform,
						@TimeChampVersion,
						@CompanyId, 
						GETUTCDATE())
			
			SELECT @DeviceId AS DeviceId, 1 AS ModeTypeEnum, @CompanyId AS CompanyId
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END