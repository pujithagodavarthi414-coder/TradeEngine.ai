CREATE PROCEDURE [dbo].[Marker298]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

    IF ((SELECT COUNT(*) FROM ActivityTrackerRolePermission WHERE CompanyId = @CompanyId) = 0)
    BEGIN
        INSERT INTO ActivityTrackerRolePermission (Id, CompanyId, CreatedDateTime, CreatedByUserId, IsDeleteScreenShots, IsRecordActivity, IsIdleTime, MinimumIdelTime, IdleScreenShotCaptureTime, IdleAlertTime, IsManualEntryTime, IsOfflineTracking, IsMouseTracking, InActiveDateTime, RoleId)
        SELECT NEWID(), @CompanyId, GETUTCDATE(), @UserId, NULL, 1, 1, 10, 0, 0, NULL, NULL, 1, NULL, Id
        FROM [Role] WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL AND (IsHidden IS NULL OR IsHidden = 0)

        UPDATE ActivityTrackerConfigurationState 
            SET IsBasicTracking = 1,
                    IsTracking = 0,
                    IsScreenshot = 0,
                    IsDelete = 0,
                    DeleteRoles = 0,
                    IsRecord = 1,
                    RecordRoles = 1,
                    IsMouse = 1,
                    MouseRoles = 1,
                    IsIdealTime = 1,
                    IdealTimeRoles = 1,
                    IsManualTime = 0,
                    ManualTimeRole = 0,
                    IsOfflineTracking = 0,
                    offlineOpen = 0,
                    DisableUrls = 0
            WHERE CompanyId = @CompanyId
    END

END
GO