-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkflowStatus By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetWorkflowStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036972'
CREATE PROCEDURE [dbo].[USP_GetWorkflowStatus]
(
  @WorkflowStatusId UNIQUEIDENTIFIER = NULL,
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @OrderId INT = NULL,
  @IsCompleted BIT = NULL,
  @IsArchived BIT = NULL,
  @IsBlocked BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
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
                         
                         IF(@WorkflowStatusId = '00000000-0000-0000-0000-000000000000') SET  @WorkflowStatusId = NULL
                         
                         IF(@WorkflowId = '00000000-0000-0000-0000-000000000000') SET  @WorkflowId = NULL
                         
                         IF(@UserStoryStatusId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryStatusId = NULL
                         
                         IF(@OrderId = '') SET  @OrderId = NULL
                         
						 DECLARE @AdhocWorkFlowId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[WorkFlow]
		                                           WHERE WorkFlow = 'Adhoc Workflow' 
														 AND CompanyId = @CompanyId)

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
                                WS.CanAdd,
                                WS.CanDelete,
                                WS.[TimeStamp],
                                W.Workflow AS WorkflowName,
                                W.CompanyId,
                                USS.[Status] AS UserStoryStatusName,
                                USS.StatusHexValue AS UserStoryStatusColor,
                                USS.TaskStatusId,
                                T.MaxOrder,
                                TotalCount = Count(1) OVER()
                           FROM [dbo].[WorkflowStatus] WS WITH (NOLOCK)
                                INNER JOIN [dbo].[WorkFlow] W WITH (NOLOCK) ON W.Id = WS.WorkflowId  AND (W.InActiveDateTime IS NULL OR @AdhocWorkFlowId = W.Id)
                                INNER JOIN [dbo].[UserStoryStatus] USS WITH (NOLOCK) ON USS.Id = WS.UserStoryStatusId AND USS.InActiveDateTime IS NULL
                                INNER JOIN (SELECT WorkflowId,MAX(OrderId) AS MaxOrder FROM WorkflowStatus WHERE InActiveDateTime IS NULL GROUP BY WorkflowId) T ON T.WorkflowId = W.Id
                          WHERE W.CompanyId = @CompanyId
                                AND (@WorkflowStatusId IS NULL OR WS.Id = @WorkflowStatusId)
                                AND (@WorkflowId IS NULL OR WS.WorkflowId = @WorkflowId)
                                AND (@UserStoryStatusId IS NULL OR WS.UserStoryStatusId = @UserStoryStatusId)
                                AND (@OrderId IS NULL OR WS.OrderId = @OrderId)
                                AND (@IsCompleted IS NULL OR WS.OrderId = @IsCompleted)
                                AND (@IsArchived IS NULL 
                                     OR (@IsArchived = 1 AND WS.InActiveDateTime IS NOT NULL) 
                                     OR (@IsArchived = 0 AND (WS.InActiveDateTime IS NULL)))
                                --AND (@IsBlocked IS NULL OR WS.IsBlocked = @IsBlocked)
                                
                          ORDER BY WS.OrderId ASC
        END
        ELSE
                
          RAISERROR (@HavePermission,11, 1)
                   
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
