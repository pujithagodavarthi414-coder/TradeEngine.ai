CREATE FUNCTION [dbo].[Ufn_GetUsersModeType]
(
	@DeviceId NVARCHAR(500) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@UtcTime DATETIME = NULL
)
RETURNS @ModeConfig TABLE
(
	DeviceId NVARCHAR(500),
	ModeTypeEnum INT,
	CompanyId UNIQUEIDENTIFIER NULL,
	ShiftBased BIT,
	PunchCardBased BIT,
	IsActiveShift BIT NULL,
	UserId UNIQUEIDENTIFIER
)
BEGIN

	DECLARE --@CompanyId UNIQUEIDENTIFIER = (SELECT TOP 1 CompanyId FROM [User] WHERE Id = @UserId),
					@ModeTypeEnum INT,
					@ShiftBased BIT,
					@PunchCardBased BIT,
					@StealthModeId UNIQUEIDENTIFIER = '0FF0AC91-DDB3-4907-BEAE-C2C6B1A289BD',
					@PrModeId UNIQUEIDENTIFIER = '786F40B4-4ED5-45B6-AED2-5D6A775AE71C',
					@PunchCardModeId UNIQUEIDENTIFIER = '734D6880-639D-4CC5-97A7-46D1182F0BB8',
					@MessengerModeId UNIQUEIDENTIFIER = '11A41B04-FCAB-4457-B42A-05CA8DD12616',
					@IsActiveShift BIT = NULL,
					@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'

	DECLARE @UserIds TABLE
	(
		UserId UNIQUEIDENTIFIER,
		RowNumber INT
	)
	IF(@DeviceId IS NOT NULL)
	BEGIN
		INSERT INTO @UserIds
		SELECT U.Id, ROW_NUMBER() OVER (ORDER BY U.Id) AS RowNumber FROM [User] U
												JOIN ActivityTrackerDesktop (NOLOCK) ATD ON U.DesktopId = ATD.Id
												WHERE ATD.DesktopDeviceId = @DeviceId
	END
	ELSE IF(@OperationsPerformedBy IS NOT NULL AND @OperationsPerformedBy <> @EmptyGuid)
	BEGIN
		INSERT INTO @UserIds
		SELECT @OperationsPerformedBy,  1
	END
	

	DECLARE @UserMinRow INT = 1
	DECLARE @UserMaxRow INT = (SELECT MAX(RowNumber) FROM @UserIds)

	WHILE(@UserMinRow <= @UserMaxRow)
	BEGIN
		DECLARE @UserId UNIQUEIDENTIFIER = (SELECT TOP 1 UserId FROM @UserIds WHERE RowNumber = @UserMinRow)
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT TOP 1 CompanyId FROM [User] (NOLOCK) WHERE Id = @UserId)
		DECLARE @UserRoles TABLE
		(
			RoleId UNIQUEIDENTIFIER,
			RowNumber INT
		) 

		INSERT INTO @UserRoles
		SELECT R.Id,ROW_NUMBER() OVER (ORDER BY R.Id) AS RowNumber FROM UserRole (NOLOCK) UR
			INNER JOIN [Role] R ON R.Id = UR.RoleId 
			AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
		WHERE UR.UserId = @UserId

		DECLARE @RoleMinRow INT = 1
		DECLARE @RoleMaxRow INT = (SELECT MAX(RowNumber) FROM @UserRoles)
		SET @ModeTypeEnum = 0
		WHILE(@RoleMinRow <= @RoleMaxRow)
		BEGIN
			DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT TOP 1 RoleId FROM @UserRoles WHERE RowNumber = @RoleMinRow)

			-- messenger mode
			IF((SELECT COUNT(*) FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CHARINDEX(CONVERT(NVARCHAR(500), @RoleId), Roles) > 0 AND ModeId = @MessengerModeId) > 0)
			BEGIN
				SET @ModeTypeEnum = (SELECT TOP 1 ModeTypeEnum FROM  ActivityTrackerMode (NOLOCK) WHERE Id = @MessengerModeId)
				SET @ShiftBased = (SELECT TOP 1 ShiftBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @MessengerModeId)
				SET @PunchCardBased = (SELECT TOP 1 PunchCardBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @MessengerModeId)
				BREAK
			END

			-- punch card mode
			IF((SELECT COUNT(*) FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CHARINDEX(CONVERT(NVARCHAR(500), @RoleId), Roles) > 0 AND ModeId = @PunchCardModeId) > 0)
			BEGIN
				SET @ModeTypeEnum = (SELECT TOP 1 ModeTypeEnum FROM  ActivityTrackerMode (NOLOCK) WHERE Id = @PunchCardModeId)
				SET @ShiftBased = (SELECT TOP 1 ShiftBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @PunchCardModeId)
				SET @PunchCardBased = (SELECT TOP 1 PunchCardBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @PunchCardModeId)
				BREAK
			END

			-- pause/resume mode
			IF((SELECT COUNT(*) FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CHARINDEX(CONVERT(NVARCHAR(500), @RoleId), Roles) > 0 AND ModeId = @PrModeId) > 0)
			BEGIN
				SET @ModeTypeEnum = (SELECT TOP 1 ModeTypeEnum FROM  ActivityTrackerMode (NOLOCK) WHERE Id = @PrModeId)
				SET @ShiftBased = (SELECT TOP 1 ShiftBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @PrModeId)
				SET @PunchCardBased = (SELECT TOP 1 PunchCardBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @PrModeId)
				BREAK
			END

			-- stealth mode
			IF((SELECT COUNT(*) FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CHARINDEX(CONVERT(NVARCHAR(500), @RoleId), Roles) > 0 AND ModeId = @StealthModeId) > 0)
			BEGIN
				SET @ModeTypeEnum = (SELECT TOP 1 ModeTypeEnum FROM  ActivityTrackerMode (NOLOCK) WHERE Id = @StealthModeId)
				SET @ShiftBased = (SELECT TOP 1 ShiftBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @StealthModeId)
				SET @PunchCardBased = (SELECT TOP 1 PunchCardBased FROM ActivityTrackerModeConfiguration (NOLOCK) WHERE CompanyId = @CompanyId AND ModeId = @StealthModeId)
				BREAK
			END

			SET @RoleMinRow = @RoleMinRow + 1
		END

		INSERT INTO @ModeConfig(DeviceId, ModeTypeEnum, CompanyId, ShiftBased, PunchCardBased, IsActiveShift, UserId)
		SELECT @DeviceId, @ModeTypeEnum , @CompanyId, @ShiftBased, @PunchCardBased, (SELECT TOP 1 IsActiveShift FROM dbo.Ufn_GetUserShiftStatus(@UserId, @UtcTime, NULL)), @UserId
		SET @UserMinRow = @UserMinRow + 1
	END
	IF(@DeviceId IS NOT NULL)
	BEGIN
		DECLARE @UserToReturn UNIQUEIDENTIFIER
		SET @UserToReturn = (SELECT TOP 1 UserId FROM @ModeConfig ORDER BY ModeTypeEnum DESC, ShiftBased DESC,IsActiveShift DESC)
		DELETE @ModeConfig 
		WHERE UserId <> @UserToReturn
		--DELETE @ModeConfig 
		--WHERE ShiftBased = 1 AND (IsActiveShift = 0 OR IsActiveShift IS NULL) AND (ModeTypeEnum = 1 OR ModeTypeEnum = 2)
	END
	RETURN 
END
GO
