-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkFlows By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkFlows] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetWorkFlows]
(
  @WorkFlowId UNIQUEIDENTIFIER = NULL,
  @Workflow NVARCHAR(250) = NULL,
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
		   
	       IF (@WorkFlowId = '00000000-0000-0000-0000-000000000000')  SET @WorkFlowId = NULL
		   
	       IF (@Workflow = '')  SET @Workflow = NULL
		   
	       IF (@IsArchived = '')  SET @IsArchived = NULL
		   
	        SELECT W.Id AS WorkFlowId,
		           W.WorkFlow AS WorkflowName,
		   		   W.CompanyId,
		   		   W.CreatedDatetime,
		   		   W.CreatedByUserId,
		   		   W.UpdatedByUserId,
		   		   W.UpdatedDateTime,
				   W.[TimeStamp],
				   CASE WHEN W.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
		   		   TotalCount = COUNT(1) OVER()
	       FROM [dbo].[WorkFlow] W WITH (NOLOCK)
	       WHERE Workflow <> 'Adhoc Workflow'
		         AND (@WorkFlowId IS NULL OR W.Id = @WorkFlowId) 
		         AND (@IsArchived IS NULL OR (W.InActiveDateTime IS NULL AND @IsArchived = 0) OR (W.InActiveDateTime IS NOT NULL AND @IsArchived = 1))
		         AND (@Workflow IS NULL OR  W.Workflow = @Workflow)
		   	     AND (W.CompanyId = @CompanyId) 
           ORDER BY WorkFlow ASC 

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