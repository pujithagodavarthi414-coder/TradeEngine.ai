CREATE PROCEDURE [dbo].[USP_GetWorkFlowTriggersByReferenceTypeId]
(
	@ReferenceTypeId UNIQUEIDENTIFIER,
	@ReferenceId UNIQUEIDENTIFIER,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TriggerName NVARCHAR(250) = NULL
)
AS
	
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SELECT 

	T.TriggerName,
	T.Id As TriggerId,
	AWF.Id AS WorkflowId,
	AWF.WorkflowName

	FROM [Trigger] T JOIN WorkflowTrigger WFT ON T.Id=WFT.TriggerId AND  T.InactiveDateTime IS NULL AND WFT.InactiveDateTime IS NULL
	JOIN AutomatedWorkFlow AWF ON AWF.Id = WFT.WorkflowId AND AWF.InactiveDateTime IS NULL
	WHERE RefereceTypeId = @ReferenceTypeId AND WFT.ReferenceId = @ReferenceId 
	       AND AWF.CompanyId = @CompanyId AND T.TriggerName = @TriggerName