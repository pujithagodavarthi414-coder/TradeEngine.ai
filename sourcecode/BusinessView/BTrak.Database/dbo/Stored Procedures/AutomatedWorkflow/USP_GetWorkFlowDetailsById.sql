CREATE PROCEDURE [dbo].[USP_GetWorkFlowDetailsById]
	@WorkflowId UNIQUEIDENTIFIER
AS
	SELECT 
	Id as WorkflowId,
	WorkflowName,
	WorkflowXml
	FROM [AutomatedWorkFlow] WHERE Id = @WorkflowId