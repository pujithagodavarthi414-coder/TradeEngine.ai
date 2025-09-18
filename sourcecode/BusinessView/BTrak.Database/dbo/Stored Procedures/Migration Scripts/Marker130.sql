CREATE PROCEDURE [dbo].[Marker130]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

    MERGE INTO [dbo].[CustomStoredProcWidget] AS Target 
    USING ( VALUES 
            (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Leaves Report'),'USP_GetLeaves',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"},{"ParameterName":"@IsSickLeave","DataType":"bit","InputData":0},{"ParameterName":"@Day","DataType":"nvarchar","InputData":null}]','[{field: "date", filter: "datetime"}, {field: "leavesCount", filter: "int"}]')
            ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Morning Late Report'),'USP_GetMorningLateDates',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"}]','[{field: "date", filter: "datetime"}, {field: "morningLate", filter: "int"}]')
            ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Break Time Report'),'USP_GetBreakTimings',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"}]','[{field: "date", filter: "datetime"}, {field: "breakInMinutes", filter: "int"}]')
            ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Spent Time Report'),'USP_GetSpentTimeDetails',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"}]','[{field: "date", filter: "datetime"}, {field: "spentTime", filter: "int"}]')
            ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Monday Leave Report'),'USP_GetLeaves',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"},{"ParameterName":"@IsSickLeave","DataType":"bit","InputData":0},{"ParameterName":"@Day","DataType":"nvarchar","InputData":"Monday"}]','[{field: "date", filter: "datetime"}, {field: "leavesCount", filter: "int"}]')
            ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Afternoon Late Report'),'USP_GetMorningLateDates',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"}]','[{field: "date", filter: "datetime"}, {field: "lunchBreakLate", filter: "int"}]')
       --TODO     
    )
    AS Source (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.CompanyId = Source.CompanyId AND Target.ProcName = Source.ProcName
    WHEN MATCHED THEN
    UPDATE SET Inputs = Source.Inputs;

END
GO
