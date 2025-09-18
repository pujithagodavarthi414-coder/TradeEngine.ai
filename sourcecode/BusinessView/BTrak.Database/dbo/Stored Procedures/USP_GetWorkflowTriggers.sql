-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkFlow triggers By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkflowTriggers] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetWorkflowTriggers]
(
  @TriggerId UNIQUEIDENTIFIER = NULL,
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @WorkflowName NVARCHAR(250) = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
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
		   
	       IF (@TriggerId = '00000000-0000-0000-0000-000000000000')  SET @TriggerId = NULL
		   
	       IF (@WorkflowName = '')  SET @WorkflowName = NULL
		   
		   SELECT WFT.WorkflowId,
		          WFT.Id WorkflowTriggerId,
		          AWF.WorkflowName,
				  AWF.WorkflowXml,
				  T.Id TriggerId,
				  T.TriggerName,
		          WFT.ReferenceId,
				  WFT.RefereceTypeId ReferenceTypeId,
				  RT.ReferenceTypeName
			 FROM  WorkflowTrigger WFT INNER JOIN AutomatedWorkFlow AWF ON WFT.WorkflowId = AWF.Id AND  AWF.InActiveDateTime IS NULL AND WFT.InactiveDateTime IS NULL
		                               INNER JOIN [Trigger]T ON T.Id = WFT.TriggerId AND T.InactiveDateTime IS NULL
									   INNER JOIN ReferenceType RT ON RT.Id = WFT.RefereceTypeId AND RT.InActiveDateTime IS NULL
				WHERE (@ReferenceId IS NULL OR WFT.ReferenceId = @ReferenceId)    
					 AND (@ReferenceTypeId IS NULL OR RT.Id  = @ReferenceTypeId)   
					 AND (@WorkflowId IS NULL OR WFT.WorkflowId = @WorkflowId)
					 AND (@TriggerId IS NULL OR T.Id = @TriggerId) 
					 AND (@WorkflowName IS NULL OR AWF.WorkflowName = @WorkflowName)
					 AND AWF.CompanyId = @CompanyId order by AWF.UpdatedDateTime, AWF.CreatedDateTime desc
					           

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

