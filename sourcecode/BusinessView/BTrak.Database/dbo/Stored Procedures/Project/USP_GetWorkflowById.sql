-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkFlows By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkflowById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkflowId='B7A0A6E4-FA8F-4600-894D-0C66D89456D9'

CREATE PROCEDURE [dbo].[USP_GetWorkflowById]
(
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      SELECT W.Id AS WorkFlowId,
		         W.WorkFlow AS WorkflowName,
				 W.CompanyId,
				 W.CreatedDatetime,
				 W.CreatedByUserId,
				 W.UpdatedByUserId,
				 W.UpdatedDateTime
		  FROM  [dbo].[WorkFlow] W WITH (NOLOCK)
		  WHERE W.Id = @WorkflowId
			   AND W.CompanyId = @CompanyId 

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