-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-06 00:00:00.000'
-- Purpose      To Save or Update the WorkFlows
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertWorkflow] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkFlowName='Test'
--------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertWorkflow]
(
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @WorkFlowName  NVARCHAR(250) = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
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

		  IF(@IsArchived = 1 AND @WorkflowId IS NOT NULL)
		  BEGIN

		    DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    
            IF(EXISTS(SELECT Id FROM [WorkflowStatus] WHERE WorkflowId = @WorkflowId))
            BEGIN
	        
            SET @IsEligibleToArchive = 'ThisWorkFlowUsedInWorkFlowStatusDeleteTheDependenciesAndTryAgain'
            
            END
			ELSE IF(EXISTS(SELECT WorkflowId FROM [WorkflowEligibleStatusTransition] WHERE WorkflowId = @WorkflowId))
            BEGIN
	        
            SET @IsEligibleToArchive = 'ThisCrudOperationUsedInWorkFlowEligibleStatusTransitionDeleteTheDependenciesAndTryAgain'
            
            END

			IF(@IsEligibleToArchive <> '1')
            BEGIN
         
             RAISERROR (@isEligibleToArchive,11, 1)
         
            END
		  END


		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @WorkFlowIdCount INT = (SELECT COUNT(1) FROM WorkFlow WHERE Id = @WorkflowId AND CompanyId = @CompanyId)

		  DECLARE @WorkFlowCount INT = (SELECT COUNT(1) FROM WorkFlow WHERE Workflow = @WorkFlowName AND CompanyId = @CompanyId AND (@WorkflowId IS NULL OR Id <> @WorkflowId)  AND InActiveDateTime IS NULL)

		  IF(@WorkFlowName IS NULL)
		  BEGIN

		  RAISERROR(50011,16, 2, 'WorkFlowName')

		  END
		  ELSE IF(@WorkFlowIdCount = 0 AND @WorkflowId IS NOT NULL)
		  BEGIN

		  	RAISERROR(50002,16, 1,'WorkFlow')

		  END
		  ELSE IF(@WorkFlowName = 'Adhoc WorkFlow')
		  BEGIN
					
				RAISERROR('CreatingAdhocWorkFlowIsNotPermitted',11,1)

		  END
		  ELSE IF(@WorkFlowCount > 0 AND @WorkflowId IS NULL)
		  BEGIN
		  
		  	RAISERROR(50001,16,1,'WorkFlow')
		  
		  END
		  ELSE
		  BEGIN

		  DECLARE @IsLatest BIT = (CASE WHEN @WorkFlowId IS NULL THEN 1 ELSE 
		                           CASE WHEN (SELECT [TimeStamp] FROM WorkFlow WHERE Id = @WorkFlowId) = @TimeStamp THEN 1 ELSE 0 END END) 

		  IF(@IsLatest = 1)
		  BEGIN

		  DECLARE @Currentdate DATETIME = GETDATE()

		  IF (@WorkflowId IS NOT NULL)
	      BEGIN

	           UPDATE [dbo].[WorkFlow]
	           SET [Workflow] = @WorkFlowName, 
			       [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
				   [CompanyId] = @CompanyId,
				   [UpdatedDateTime] = @Currentdate,
				   [UpdatedByUserId] = @OperationsPerformedBy
	           WHERE Id = @WorkflowId

	      END
	      ELSE
	      BEGIN

		      SELECT @WorkflowId = NEWID()

	          INSERT INTO [dbo].[WorkFlow](
			              [Id],
						  [Workflow],
						  [InActiveDateTime],
						  [CompanyId],
						  [CreatedDateTime],
						  [CreatedByUserId])

		           SELECT @WorkflowId,
				          @WorkFlowName,
						   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						  @CompanyId,
						  @Currentdate,
						  @OperationsPerformedBy

	     END
	
	     SELECT Id FROM [dbo].[WorkFlow] where Id = @WorkflowId

		END
	    ELSE
		     
			 RAISERROR(50008,11,1)
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