CREATE PROCEDURE [dbo].[Marker268]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	UPDATE WIDGET set widgetname = 'Team top 5 unproductive websites & applications' WHERE Id = (SELECT Id FROM Widget WHERE WidgetName ='Team top five unproductive websites and applications' AND CompanyId = @CompanyId)
END
GO