-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2018-01-07 00:00:00.000'
-- Purpose      To Get The BoardTypeWorkFlow By Id By Appliying BoardTypeWorkFlowId Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetBoardTypeWorkFlowById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BoardTypeWorkFlowId='60E3867D-0EF2-4945-9FB0-2DE58E67D496'

CREATE PROCEDURE [dbo].[USP_GetBoardTypeWorkFlowById]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @BoardTypeWorkFlowId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SELECT BTW.Id,
                 BTW.WorkflowId,
                 BTW.BoardTypeId,
                 W.CompanyId,
				 W.Workflow,
                 BTW.CreatedDatetime,
                 BTW.CreatedByUserId,
                 TotalCount = COUNT(*) OVER()
          FROM  [dbo].[BoardTypeWorkFlow]BTW WITH (NOLOCK)
          INNER JOIN [dbo].[WorkFlow]W ON W.Id = BTW.WorkflowId
          WHERE  W.CompanyId = @CompanyId 
             AND BTW.Id = @BoardTypeWorkFlowId
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