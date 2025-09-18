CREATE PROCEDURE [dbo].[Marker97]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    UPDATE [dbo].[SoftLabelConfigurations] 
    SET RunLabel = 'Test run'
        ,RunsLabel = 'Test runs'
        ,ScenarioLabel = 'Test suite'
        ,ScenariosLabel = 'Test suites'
        ,UpdatedByUserId = @UserId
        ,UpdatedDateTime = GETDATE()
    WHERE CompanyId = @CompanyId

END
GO