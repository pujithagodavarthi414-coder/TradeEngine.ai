CREATE PROCEDURE [dbo].[Marker209]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	UPDATE [dbo].[CustomAppDetails] 
		   SET [VisualizationName] = 'Today''s leaves count_KPI',
			   [VisualizationType] = 'kpi'
			   WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s Leaves Count' AND CompanyId = @CompanyId)
			   AND VisualizationName='Today''s leaves count_gauge'

END
GO