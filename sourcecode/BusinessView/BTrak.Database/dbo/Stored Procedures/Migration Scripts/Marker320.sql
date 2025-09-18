CREATE PROCEDURE [dbo].[Marker320]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN      
   
UPDATE CustomAppDetails SET HeatMapMeasure = '{"legend":[{"legendName":"Full  day leave","value":"1","legendColor":"#d82323"},{"legendName":"Half day leave","value":"0.5","legendColor":"#da8d17"},{"legendName":"Record not inserted/No shift","value":"0","legendColor":"#9ba09b"},{"legendName":"Working day","value":"2","legendColor":"#13e91e"},{"legendName":"Holiday","value":"3","legendColor":"#3e97af"}],"cellSize":null,"showDataInCell":null}'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Employee Leaves Report')

UPDATE CustomAppDetails SET HeatMapMeasure = '{"legend":[{"legendName":"Record not inserted/No shift","value":"0","legendColor":"#bfc8bf"},{"legendName":"Late","value":"1","legendColor":"#d82323"},{"legendName":"On time","value":"2","legendColor":"#13e91e"},{"legendName":"Leave","value":"3","legendColor":"#9e8595"},{"legendName":"Holiday","value":"4","legendColor":"#3e97af"}],"cellSize":null,"showDataInCell":null}'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Employee Afternoon Late Report')

UPDATE CustomAppDetails SET HeatMapMeasure = '{"legend":[{"legendName":"Record not inserted/No shift","value":"0","legendColor":"#bfc8bf"},{"legendName":"Late","value":"1","legendColor":"#d82323"},{"legendName":"On time","value":"2","legendColor":"#13e91e"},{"legendName":"Leave","value":"3","legendColor":"#9e8595"},{"legendName":"Holiday","value":"4","legendColor":"#3e97af"}],"cellSize":null,"showDataInCell":null}'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Employee Morning Late Report')

UPDATE CustomAppDetails SET HeatMapMeasure = '{"legend":[{"legendName":"No Leave","value":"0","legendColor":"#bfc8bf"},{"legendName":"Half day leave","value":"0.5","legendColor":"#da8d17"},{"legendName":"Full  day leave","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Sick Leave Report')

UPDATE CustomAppDetails SET HeatMapMeasure = '{"legend":[{"legendName":"No Leave","value":"0","legendColor":"#bfc8bf"},{"legendName":"Half day leave","value":"0.5","legendColor":"#da8d17"},{"legendName":"Full  day leave","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Monday Leave Report')

END
GO