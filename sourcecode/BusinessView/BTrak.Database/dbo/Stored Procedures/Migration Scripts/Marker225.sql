CREATE PROCEDURE [dbo].[Marker225]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
   UPDATE CustomStoredProcWidget SET Inputs = '[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@IsActive","DataType":"bit","InputData":"@IsActive"}]' 
WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Employees Details Project Wise' AND CompanyId = @CompanyId)
   UPDATE CustomStoredProcWidget SET Inputs = '[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@IsActive","DataType":"bit","InputData":"@IsActive"}]' 
WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Employees Overview Details' AND CompanyId = @CompanyId)
	
END
GO