CREATE PROCEDURE [dbo].[Marker453]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

DECLARE @Currentdate DATETIME = GETDATE()

UPDATE [dbo].[Widget]
SET [WidgetName] = 'Daily Positions & P n L Reporting',
    [UpdatedByUserId] = @UserId,
    [UpdatedDateTime] = @Currentdate
WHERE WidgetName = 'Vessel level Daily Position and P&L Reporting'

END
GO