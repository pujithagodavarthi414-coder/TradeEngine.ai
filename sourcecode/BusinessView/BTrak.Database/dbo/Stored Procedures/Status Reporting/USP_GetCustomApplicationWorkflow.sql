---------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Get the custom application workflow
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCustomApplicationWorkflow] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCustomApplicationWorkflow]
(
	@CustomApplicationWorkflowId UNIQUEIDENTIFIER = NULL,		
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CustomApplicationId UNIQUEIDENTIFIER,
	@WorkflowTrigger VARCHAR(1000) 
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@CustomApplicationWorkflowId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationWorkflowId = NULL		  
		   
           SELECT  CAW.Id AS CustomApplicationWorkflowId
				  ,CAW.WorkflowTypeId AS CustomApplicationWorkflowTypeId
				  ,WFT.WorkflowTypeName
				  ,CAW.WorkflowName
				  ,CAW.WorkflowTrigger
		          ,CAW.CustomApplicationId
				  ,CAW.[WorkflowXml]
				  ,CAW.[RuleJson]
				  ,CAW.CreatedDateTime
		   FROM CustomApplicationWorkflow CAW 
		   INNER JOIN WorkFlowType WFT ON CAW.WorkflowTypeId = WFT.Id AND WFT.InActiveDateTime IS NULL
           WHERE (@CustomApplicationWorkflowId IS NULL OR CAW.Id = @CustomApplicationWorkflowId)
		        AND (@WorkflowTrigger IS NULL OR @WorkflowTrigger IN (SELECT ID FROM dbo.UfnSplit(CAW.WorkflowTrigger)))
		        AND (@WorkflowTrigger IS NOT NULL OR CAW.CustomApplicationId = @CustomApplicationId)
		      
           ORDER BY CAW.CreatedDateTime ASC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
