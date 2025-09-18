---------------------------------------------------------------------------
-- Author       Saajid Syed
-- Created      '2020-04-30 00:00:00.000'
-- Purpose      To Get the custom application workflow by workflow name and custom application name
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCustomApplicationWorkflowByWorkflowName] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCustomApplicationWorkflowByWorkflowName]
(
	@CustomApplicationWorkflowName NVARCHAR(MAX) = NULL,	
	@CustomApplicationWorkflowtrigger NVARCHAR(MAX) = NULL,	
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CustomApplicationName NVARCHAR(MAX) 
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

		   DECLARE @CustomApplicationId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM  CustomApplication WHERE CustomApplicationName = @CustomApplicationName AND InActiveDateTime IS NULL)
		   DECLARE @CustomApplicationWorkflowId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM  CustomApplicationWorkflow WHERE WorkflowName = @CustomApplicationWorkflowName)

		   DECLARE @CustomApplicationWorkflowtriggers Table
           (
           	 TriggerValue NVARCHAR(250)
           )
           INSERT INTO @CustomApplicationWorkflowtriggers(TriggerValue)
           SELECT Id FROM [dbo].[ufnSplit](@CustomApplicationWorkflowtrigger)

		   IF(@CustomApplicationWorkflowId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationWorkflowId = NULL		  
		   
           SELECT  CAW.Id AS CustomApplicationWorkflowId
				  ,CAW.WorkflowTypeId AS CustomApplicationWorkflowTypeId
				  ,WFT.WorkflowTypeName
				  ,CAW.WorkflowName
		          ,CAW.CustomApplicationId
				  ,CAW.[WorkflowXml]
				  ,CAW.[RuleJson]
				  ,CAW.CreatedDateTime
		   FROM CustomApplicationWorkflow CAW 
		   INNER JOIN WorkFlowType WFT ON CAW.WorkflowTypeId = WFT.Id AND WFT.InActiveDateTime IS NULL
		   INNER JOIN (
		                SELECT CAW1.Id
		                FROM CustomApplicationWorkflow CAW1
		                     CROSS APPLY (SELECT Id FROM [dbo].[ufnSplit](CAW1.WorkflowTrigger)) T
		                WHERE (@CustomApplicationWorkflowtrigger IS NULL OR T.Id IN (SELECT TriggerValue FROM @CustomApplicationWorkflowtriggers))
		                GROUP BY CAW1.Id
		   ) CAWInner ON CAWInner.Id = CAW.Id
           WHERE (@CustomApplicationWorkflowId IS NULL OR CAW.Id = @CustomApplicationWorkflowId)
		        AND (CAW.CustomApplicationId = @CustomApplicationId)
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
