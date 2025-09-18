CREATE VIEW [dbo].[V_AllWorkflowTransitions]
	AS SELECT W.Workflow, 
	   FUSS.[Status] FromUserWorkflowStatus, 
	   TUSS.[Status] ToUserWorkflowStatus, 
	   WET.Deadline, 
	   W.Id WorkflowId, 
	   FUSS.ID FromUserStoryStatusId, 
	   TUSS.ID ToUserStoryStatusId
FROM [dbo].[WorkflowEligibleStatusTransition] WET
	 INNER JOIN [dbo].[UserStoryStatus] FUSS ON WET.FromWorkflowUserStoryStatusId = FUSS.Id
	 INNER JOIN [dbo].[UserStoryStatus] TUSS ON WET.ToWorkflowUserStoryStatusId = TUSS.Id
	 INNER JOIN [dbo].[WorkFlow] W ON WET.WorkflowId = W.Id

