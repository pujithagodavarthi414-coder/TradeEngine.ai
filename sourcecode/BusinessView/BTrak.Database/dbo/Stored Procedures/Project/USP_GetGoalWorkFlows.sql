-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Get the GoalWorkFlows By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetGoalWorkFlows] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGoalWorkFlows]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@GoalId = '00000000-0000-0000-0000-000000000000') SET  @GoalId = NULL

	      IF(@WorkflowId = '00000000-0000-0000-0000-000000000000') SET  @WorkflowId = NULL

	      SELECT GW.Id AS GoalWorkFlowId,
		         GW.GoalId,
		         GW.WorkflowId,
				 GW.CreatedByUserId,
				 GW.CreatedDateTime,
				 GW.UpdatedByUserId,
				 GW.UpdatedDateTime,
		         G.ProjectId,
			     G.BoardTypeId,
			     G.BoardTypeApiId,
		         --G.ArchivedDateTime,
			     G.GoalBudget,
			     G.GoalName,
			     G.GoalStatusId,
			     G.GoalShortName,
			     G.GoalStatusColor,
			     --G.IsArchived AS GoalIsArchived,
			     G.IsLocked,
			     G.IsProductiveBoard,
			     G.IsToBeTracked,
			     G.OnboardProcessDate AS OnboardDate,
			     --G.IsParked GoalIsParked,
			     G.IsApproved,
			     G.ParkedDateTime,
			     G.GoalResponsibleUserId,
			     G.ConfigurationId,
			     G.ConsiderEstimatedHoursId,
		         W.WorkFlow AS WorkflowName,
				 W.CompanyId,
				 GW.[TimeStamp],
				 CASE WHEN GW.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		         TotalCount = Count(1) OVER()
		  FROM  [dbo].[GoalWorkFlow] GW WITH (NOLOCK) 
		        INNER JOIN [dbo].[WorkFlow] W WITH (NOLOCK) ON W.Id = GW.WorkflowId
		        INNER JOIN [dbo].[Goal] G WITH (NOLOCK) ON G.Id = GW.GoalId
		  WHERE W.CompanyId = @CompanyId 
		        AND (@GoalId IS NULL OR GW.GoalId = @GoalId)
		        AND (@WorkflowId IS NULL OR GW.WorkflowId = @WorkflowId)
		        AND (@IsArchived IS NULL OR G.InActiveDateTime IS NULL)
				AND (@IsArchived IS NULL OR (@IsArchived = 0 AND GW.InActiveDateTime IS NULL)
				  OR (@IsArchived = 1 AND GW.InActiveDateTime IS NOT NULL))

		 END
         ELSE
           RAISERROR (@HavePermission,11, 1)
	 END TRY  
	 BEGIN CATCH 
		
		THROW

	END CATCH

END
GO