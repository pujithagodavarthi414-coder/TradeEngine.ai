-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkflowStatus By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkflowStatusById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkflowStatusId='E2C5C6AE-A01E-484E-B301-23DAD3DC2BFF'

CREATE PROCEDURE [dbo].[USP_GetWorkflowStatusById]
(
  @WorkflowStatusId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	 SET NOCOUNT ON

     BEGIN TRY

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      SELECT WS.Id AS WorkflowStatusId,
		         WS.WorkflowId,
				 WS.UserStoryStatusId,
				 --WS.IsCompleted,
				 --WS.IsArchived,
				 --WS.IsBlocked,
				 WS.OrderId,
				 WS.CreatedByUserId,
				 WS.CreatedDateTime,
				 WS.UpdatedByUserId,
				 WS.UpdatedDateTime,
				 W.Workflow AS WorkflowName,
				 W.CompanyId,
				 USS.[Status] AS UserStoryStatusName,
			     USS.StatusHexValue AS UserStoryStatusColor
		   FROM [dbo].[WorkflowStatus] WS WITH (NOLOCK) 
		        INNER JOIN [dbo].[WorkFlow] W WITH (NOLOCK) ON W.Id = WS.WorkflowId
		        INNER JOIN [dbo].[UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = WS.UserStoryStatusId
		  WHERE WS.Id = @WorkflowStatusId
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