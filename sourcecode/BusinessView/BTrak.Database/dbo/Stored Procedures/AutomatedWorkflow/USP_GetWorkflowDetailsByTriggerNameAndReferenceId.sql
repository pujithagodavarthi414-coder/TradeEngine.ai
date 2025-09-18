CREATE PROCEDURE [dbo].[USP_GetWorkflowDetailsByTriggerNameAndReferenceId]
(
	@ReferenceId UNIQUEIDENTIFIER,
	@TriggerName NVARCHAR(50),
	@ReferenceTypeId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
	
	SELECT 
    AWF.WorkflowName,
	AWF.WorkflowXml,
	AWF.Id
    FROM [AutomatedWorkFlow] AWF 
	JOIN [Trigger] T ON T.TriggerName =@TriggerName 
	JOIN [WorkflowTrigger]WT ON WT.WorkflowId = AWF.Id 
	     AND AWF.InactiveDateTime IS NULL AND T.InactiveDateTime IS NULL
		 WHERE WT.ReferenceId = @ReferenceId AND WT.InactiveDateTime IS NULL
		         AND WT.RefereceTypeId = @ReferenceTypeId
