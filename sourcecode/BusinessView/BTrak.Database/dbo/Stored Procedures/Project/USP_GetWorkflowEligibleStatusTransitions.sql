-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-11 00:00:00.000'
-- Purpose      To Get the WorkflowEligibleStatusTransitions By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetWorkflowEligibleStatusTransitions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetWorkflowEligibleStatusTransitions]
(
  @WorkflowEligibleStatusTransitionId UNIQUEIDENTIFIER = NULL,
  @FromWorkflowUserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @ToWorkflowUserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @DisplayName NVARCHAR(250) = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @GoalId UNIQUEIDENTIFIER = NULL,
  @SprintId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
          DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		  IF (@HavePermission = '1')
		  BEGIN
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	      DECLARE @BoardTypeId UNIQUEIDENTIFIER
	      IF(@WorkflowEligibleStatusTransitionId = '00000000-0000-0000-0000-000000000000') SET  @WorkflowEligibleStatusTransitionId = NULL
	      IF(@FromWorkflowUserStoryStatusId = '00000000-0000-0000-0000-000000000000') SET  @FromWorkflowUserStoryStatusId = NULL
	      IF(@ToWorkflowUserStoryStatusId = '00000000-0000-0000-0000-000000000000') SET  @ToWorkflowUserStoryStatusId = NULL
	      IF(@WorkflowId = '00000000-0000-0000-0000-000000000000') SET  @WorkflowId = NULL
	      IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL
	      IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET  @ProjectId = NULL
	      IF(@DisplayName = '') SET  @DisplayName = NULL
		  IF(@GoalId = '00000000-0000-0000-0000-000000000000') SET  @GoalId = NULL
		  IF(@GoalId = '00000000-0000-0000-0000-000000000000') SET  @SprintId = NULL
		  IF(@GoalId IS NOT NULL)
		  BEGIN
				SELECT @BoardTypeId = BoardTypeId FROM GOAL G WHERE G.Id = @GoalId
				SELECT @WorkflowId = WorkflowId FROM BoardTypeWorkFlow BTW WHERE BTW.BoardTypeId = @BoardTypeId
		  END
		  ELSE IF(@SprintId IS NOT NULL)
		  BEGIN
		        SELECT @BoardTypeId = BoardTypeId FROM Sprints S WHERE S.Id = @SprintId
				SELECT @WorkflowId = WorkflowId FROM BoardTypeWorkFlow BTW WHERE BTW.BoardTypeId = @BoardTypeId
		  END
	      SELECT WEST.Id AS WorkflowEligibleStatusTransitionId,
		         WEST.FromWorkflowUserStoryStatusId,
				 FromUSS.[Status] FromWorkflowUserStoryStatus,
				 FromUSS.[StatusColor] FromWorkflowUserStoryStatusColor,
		         WEST.ToWorkflowUserStoryStatusId,
				 ToUSS.[Status] ToWorkflowUserStoryStatus,
				 ToUSS.[StatusColor] ToWorkflowUserStoryStatusColor,
		         WEST.WorkflowId,
				 WEST.Deadline AS DeadlineName,
				 W.WorkFlow AS WorkflowName,
				 W.CompanyId,
				 WEST.[TimeStamp],
				 CASE WHEN WEST.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
		         TotalCount = Count(1) OVER()
		  FROM  [dbo].[WorkflowEligibleStatusTransition] WEST WITH (NOLOCK)
				JOIN [WorkflowEligibleStatusTransition] WEST1 ON WEST1.Id = WEST.Id
		        INNER JOIN [dbo].[WorkFlow] W  WITH (NOLOCK) ON W.Id = WEST.WorkflowId AND W.InActiveDateTime IS NULL
		        INNER JOIN [dbo].[UserStorystatus] FromUSS WITH (NOLOCK) ON FromUSS.Id = WEST.FromWorkflowUserStoryStatusId
				                                                        AND FromUSS.InActiveDateTime IS NULL
																		AND WEST.CompanyId = FromUSS.CompanyId
		        INNER JOIN [dbo].[UserStorystatus] ToUSS WITH (NOLOCK) ON ToUSS.Id = WEST.ToWorkflowUserStoryStatusId AND ToUSS.InActiveDateTime IS NULL
		  WHERE FromUSS.CompanyId = @CompanyId
		        AND (@WorkflowEligibleStatusTransitionId IS NULL OR WEST.Id = @WorkflowEligibleStatusTransitionId)
		        AND (@FromWorkflowUserStoryStatusId IS NULL OR WEST.FromWorkflowUserStoryStatusId = @FromWorkflowUserStoryStatusId)
		        AND (@ToWorkflowUserStoryStatusId IS NULL OR WEST.ToWorkflowUserStoryStatusId = @ToWorkflowUserStoryStatusId)
		        AND (@WorkflowId IS NULL OR WEST.WorkflowId = @WorkflowId)
		        AND (@DisplayName IS NULL OR WEST.DisplayName = @DisplayName)
				AND WEST.InactiveDateTime IS NULL
	 END
	 ELSE
	     RAISERROR(@HavePermission,11,1)
	 END TRY
	 BEGIN CATCH
		THROW
	END CATCH
END
GO