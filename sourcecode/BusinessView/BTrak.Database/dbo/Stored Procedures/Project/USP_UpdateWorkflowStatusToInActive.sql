-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To Get The Each Employee WorkAllocation By Applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpdateWorkflowStatusToInActive] @WorkFlowId='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ExistedUserStoryStatusId='694A1346-07B5-4CA4-8AB6-0012B2BB46B9',
-- @CurrentUserStoryStatusId='9D7C4139-64CA-4BEA-8614-00238D6B53D9'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateWorkflowStatusToInActive]
(
	@WorkFlowId uniqueidentifier,
	@ExistedUserStoryStatusId uniqueidentifier,
	@CurrentUserStoryStatusId uniqueidentifier
)

AS
BEGIN

	SET NOCOUNT ON
	
	--UPDATE WorkflowStatus SET IsArchived = 1 WHERE WorkflowId = @WorkFlowId AND UserStoryStatusId = @ExistedUserStoryStatusId

	--UPDATE WorkflowStatus SET IsCompleted = ISNULL((SELECT IsCompleted FROM WorkflowStatus WHERE WorkflowId = @WorkFlowId AND UserStoryStatusId = @ExistedUserStoryStatusId),0) 
	--										WHERE WorkflowId = @WorkFlowId AND UserStoryStatusId = @CurrentUserStoryStatusId
	
	UPDATE UserStory SET UserStoryStatusId = @CurrentUserStoryStatusId WHERE Id IN (SELECT US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId
	                                                                                                               INNER JOIN GoalWorkFlow GW ON GW.GoalId = G.Id
								                                                                                   INNER JOIN WorkFlow WF ON WF.Id = GW.WorkflowId
								                                                                 WHERE GW.WorkflowId = @WorkFlowId AND US.UserStoryStatusId = @ExistedUserStoryStatusId) 
  SELECT @CurrentUserStoryStatusId

END
GO