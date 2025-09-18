CREATE FUNCTION [dbo].[UfnGetStatusColor](@GoalId UNIQUEIDENTIFIER,@TransitionId UNIQUEIDENTIFIER)
RETURNS VARCHAR(250) 
BEGIN
   DECLARE @StatusColor VARCHAR(250)
   DECLARE @MinOrderIdExpected INT
   SET @MinOrderIdExpected = (select MIN(OrderId) FROM WorkflowStatus WS
   INNER JOIN UserStoryStatus USS ON USS.Id = WS.UserStoryStatusId
   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
   WHERE WS.InActiveDateTime IS NULL AND
   WorkflowId = (SELECT WorkFlowId FROM GoalWorkFlow WHERE GoalId = @GoalId AND InActiveDateTime IS NULL) AND TS.TaskStatusName = 'Done')
   
   --(SELECT MIN(WS.OrderId) FROM [dbo].[WorkflowEligibleStatusTransition] WEST
   --                    INNER JOIN WorkflowStatus WS ON WEST.ToWorkflowUserStoryStatusId = WS.UserStoryStatusId
   --                    WHERE WEST.[Id] = @TransitionId)

    DECLARE @ApprovedState UNIQUEIDENTIFIER
    SET @ApprovedState = (SELECT GoalStatusId FROM Goal WHERE Id = @GoalId AND InActiveDateTime IS NULL AND [OnboardProcessDate] <= CONVERT(DATE,GETUTCDATE()))
    
   DECLARE @FailedCount INT
   SET @FailedCount = (SELECT COUNT(1) FROM [dbo].[UserStory] US
   INNER JOIN [dbo].[WorkflowStatus] WS ON WS.UserStoryStatusId = US.UserStoryStatusId AND WS.InActiveDateTime IS NULL
   AND WS.WorkflowId = (SELECT WorkFlowId FROM GoalWorkFlow WHERE GoalId = @GoalId AND InActiveDateTime IS NULL)
   INNER JOIN UserStoryStatus USS ON USS.Id = WS.UserStoryStatusId
   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
    WHERE DeadLineDate < [dbo].[ufnGetTransitionFormulaToActualDate](@TransitionId) AND GoalId = @GoalId AND (TS.TaskStatusName <> 'Blocked')
    AND WS.OrderId < @MinOrderIdExpected AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL
	AND US.InActiveDateTime IS NULL)

   DECLARE @BlockedCount INT
   SET @BlockedCount = (SELECT COUNT(1) FROM [dbo].[UserStory] US
   INNER JOIN [dbo].[WorkflowStatus] WS ON WS.UserStoryStatusId = US.UserStoryStatusId AND WS.InActiveDateTime IS NULL
   AND WS.WorkflowId = (SELECT WorkFlowId FROM GoalWorkFlow WHERE GoalId = @GoalId AND InActiveDateTime IS NULL)
   INNER JOIN UserStoryStatus USS ON USS.Id = WS.UserStoryStatusId
   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId 
	WHERE DeadLineDate < [dbo].[ufnGetTransitionFormulaToActualDate](@TransitionId) AND GoalId = @GoalId AND TS.TaskStatusName = 'Blocked'
    AND WS.OrderId < @MinOrderIdExpected AND US.ParkedDateTime IS NULL	AND US.InActiveDateTime IS NULL)
   
   IF(@FailedCount > 0 OR (@ApprovedState = 'F6F118EA-7023-45F1-BCF6-CE6DB1CEE5C3' OR @ApprovedState IS NULL))
   BEGIN
     SET @StatusColor = '#ff141c'
   END
   ELSE IF (@BlockedCount > 0)
   BEGIN
       SET @StatusColor = '#ead1dd'
   END
   ELSE
   BEGIN
       SET @StatusColor = '#04fe02'
   END  
   
   RETURN @StatusColor
       
END