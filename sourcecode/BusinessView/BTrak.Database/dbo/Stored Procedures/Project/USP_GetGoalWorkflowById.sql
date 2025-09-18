-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2018-01-07 00:00:00.000'
-- Purpose      To Get The GoalWorkflow By Id By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetGoalWorkflowById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalWorkflowId='B71E180B-6EFB-4BA3-86B7-00EE862BC06F'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGoalWorkflowById]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
  @GoalWorkflowId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      SELECT GW.Id,
		         GW.WorkflowId,
				 GW.GoalId,
				 W.CompanyId,
				 W.Workflow,
				 GW.CreatedDatetime,
				 GW.CreatedByUserId,
				 TotalCount = Count(*) OVER()

		  FROM  [dbo].[GoalWorkflow]GW WITH (NOLOCK)
		  INNER JOIN [dbo].[WorkFlow]W WITH (NOLOCK) ON W.Id = GW.WorkflowId
		  WHERE  W.CompanyId = @CompanyId 
			 AND GW.Id = @GoalWorkflowId
	 END TRY  
	 BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH
END
GO