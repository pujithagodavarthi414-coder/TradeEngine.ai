CREATE PROCEDURE [dbo].[Marker189]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON 

   UPDATE CustomWidgets SET WidgetQuery = NULL ,IsProc =1,ProcName = 'USP_GetLeavesCustomReport' WHERE CustomWidgetName = 'Attendance report' AND CompanyId = @CompanyId

 MERGE INTO [dbo].[CustomStoredProcWidget] AS Target 
    USING ( VALUES 
	   (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Attendance report'),'USP_GetLeavesCustomReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"}]',null)
	  )
  AS SOURCE (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
  ON  Target.CustomWidgetId = Source.CustomWidgetId  AND Target.ProcName =Source.ProcName   AND Target.CompanyId =Source.CompanyId 
    WHEN MATCHED THEN
    UPDATE SET Inputs  = SOURCE.Inputs
    WHEN NOT MATCHED BY TARGET  AND  SOURCE.CustomWidgetId IS NOT NULL THEN 
    INSERT  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs) 
    VALUES  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs);
END
GO