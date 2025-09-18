-------------------------------------------------------------------------------
-- Author       Manoj Gurram
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkFlows By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkflowsForTriggers] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetWorkflowsForTriggers]
(
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @WorkflowName NVARCHAR(250) = NULL,
  @IsArchived BIT = NULL,
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
		   
	       IF (@WorkflowName = '')  SET @WorkflowName = NULL

		   IF (@IsArchived IS NULL)  SET @IsArchived = 0
		   
		   SELECT AW.Id WorkflowId,
				  AW.WorkflowName,
				  AW.WorkflowXml,
				  AW.WorkFlowTypeId
			 FROM  AutomatedWorkFlow AW 
				WHERE (@WorkflowId IS NULL OR AW.Id = @WorkflowId)
					 AND (@WorkflowName IS NULL OR AW.WorkflowName = @WorkflowName)
					 AND ((AW.InActiveDateTime IS NULL AND @IsArchived = 0) OR (AW.InActiveDateTime IS NOT NULL AND @IsArchived = 1))
					 AND AW.CompanyId = @CompanyId

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

