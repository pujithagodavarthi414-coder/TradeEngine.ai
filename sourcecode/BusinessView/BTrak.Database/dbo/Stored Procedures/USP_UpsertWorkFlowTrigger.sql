-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-01-23 00:00:00.000'
-- Purpose      To Save or Update the WorkFlows
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertWorkflow] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkFlowName='Test'
--------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertWorkFlowTrigger]
(
  @WorkFlowId UNIQUEIDENTIFIER = NULL,
  @WorkflowTriggerId UNIQUEIDENTIFIER = NULL,
  @WorkflowName NVARCHAR(50) = NULL,
  @WorkflowXml NVARCHAR(MAX) = NULL,
  @TriggerId UNIQUEIDENTIFIER = NULL,
  @WorkFlowTypeId UNIQUEIDENTIFIER = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT  = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @CurrentDate DATETIME = GETDATE()

          IF (@HavePermission = '1')
          BEGIN
		  
		  DECLARE @WorkFlowNameCount INT = (SELECT COUNT(1) FROM AutomatedWorkFlow WHERE WorkflowName = @WorkflowName AND CompanyId = @CompanyId AND InactiveDateTime IS NULL AND (@WorkFlowId IS NULL OR Id <> @WorkFlowId))

		  IF(@WorkflowName IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'WorkflowName')
		  
		  END		 
		  ELSE IF(@WorkflowXml IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'Workflow')
		  
		  END		 
		  ELSE IF(@WorkFlowNameCount > 0)
		  BEGIN
		     
		           RAISERROR(50001,16, 2,'WorkflowName')
		  
		  END
		  ELSE
		  BEGIN
		         IF(@WorkflowId IS NULL)
		         BEGIN

		               SET @WorkFlowId = NEWID()

		                INSERT INTO [dbo].[AutomatedWorkFlow](
									      Id,
									      WorkflowName,
									      WorkflowXml,
										  CompanyId,
										  WorkFlowTypeId,
									      CreatedDateTime,
									      CreatedByUserId,
									      InActiveDateTime
									      )
								  SELECT  @WorkFlowId,
										  @WorkflowName,
										  @WorkflowXml,
										  @CompanyId,
										  @WorkFlowTypeId,
										  @CurrentDate,
										  @OperationsPerformedBy,
										  CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
												
		         END
		         ELSE 
				 BEGIN

				           UPDATE [dbo].[AutomatedWorkFlow]
						      SET WorkflowName =  @WorkflowName,
								  WorkflowXml = @WorkflowXml,
								  WorkFlowTypeId = @WorkFlowTypeId,
								  UpdatedDateTime = @CurrentDate,
								  UpdatedByUserId = @OperationsPerformedBy,
								  InActiveDateTime = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
								  WHERE Id = @WorkFlowId

				 END

				 IF(@WorkflowTriggerId IS NULL)
				 BEGIN

				 SET @WorkflowTriggerId = (SELECT Id FROM WorkflowTrigger WHERE WorkflowId = @WorkFlowId AND TriggerId = @TriggerId AND RefereceTypeId = @ReferenceTypeId AND ReferenceId = @ReferenceId AND InactiveDateTime IS NULL)

				 END

				 IF(@WorkflowTriggerId IS NULL)
				 BEGIN

				  INSERT INTO [dbo].[WorkflowTrigger](
									Id,
									WorkflowId,
									TriggerId,
									CreatedDateTime,
									CreatedByUserId,
									RefereceTypeId,
									ReferenceId,
									InActiveDateTime
									)
						    SELECT  NEWID(),
									@WorkFlowId,
									@TriggerId,
									@CurrentDate,
									@OperationsPerformedBy,
									@ReferenceTypeId,
									@ReferenceId,
									CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
                  
				  END
				  ELSE
				  BEGIN

				       UPDATE [dbo].[WorkflowTrigger]
						 SET  WorkflowId = @WorkFlowId,
							  TriggerId = @TriggerId,
							  RefereceTypeId = @ReferenceTypeId,
							  ReferenceId = @ReferenceId,
							  UpdatedDateTime =  @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy,
							  InActiveDateTime = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
							  WHERE Id = @WorkflowTriggerId
												    
				  END

				  SELECT Id FROM AutomatedWorkFlow WHERE Id = @WorkFlowId
		 END
		 END
		 ELSE
                 
		   RAISERROR (@HavePermission,11, 1)
                   
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO

