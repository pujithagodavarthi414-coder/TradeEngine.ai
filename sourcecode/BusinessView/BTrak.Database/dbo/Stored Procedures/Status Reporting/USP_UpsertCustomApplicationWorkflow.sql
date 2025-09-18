 
 -------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Update or Save Generic Form Keys
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertCustomApplicationWorkflow] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@CustomApplicationId='c6fa8a8b-ea04-40a0-b5b7-29137628b142' ,@RuleJson='{"sourceKey":"bd622613-1e1c-4710-8a21-9a2722c74236","sourceValue":"saajid","logicalOperation":"<>","destinationKey":"1f06b0fd-9630-420f-950e-a625de7ea725","destinationValue":"this is not saajid"}'

-------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_UpsertCustomApplicationWorkflow]
(
	@CustomApplicationWorkflowTypeId UNIQUEIDENTIFIER = NULL,	
	@CustomApplicationWorkflowId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationFormId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER,
	@WorkflowName NVARCHAR(MAX) = NULL,
	@WorkflowTrigger NVARCHAR(MAX) = NULL,
	@WorkflowXml NVARCHAR(MAX) = NULL,
	@RuleJson NVARCHAR(MAX) = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
	IF (@HavePermission = '1')
    BEGIN

	  IF (@CustomApplicationWorkflowId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationWorkflowId = NULL

	  IF (@CustomApplicationWorkflowTypeId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationWorkflowTypeId = NULL

	  IF(@CustomApplicationId IS NULL)
	  BEGIN
		   
		   RAISERROR(50011,16, 2, 'CustomApplicationId')

	  END
	  ELSE 
	  BEGIN

			DECLARE @CustomApplicationWorkflowIdCount INT = (SELECT COUNT(1) FROM CustomApplicationWorkflow WHERE Id = @CustomApplicationWorkflowId)

			IF(@CustomApplicationWorkflowIdCount = 0 AND @CustomApplicationWorkflowId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16,1,'CustomApplicationWorkflowId')

			END
			ELSE
			BEGIN
			
			    DECLARE @CustomApplicationWorkflowNameCount INT = (SELECT COUNT(1) FROM CustomApplicationWorkflow WHERE WorkflowName = @WorkflowName AND (CustomApplicationId = @CustomApplicationId) AND (@CustomApplicationWorkflowId IS NULL OR Id <> @CustomApplicationWorkflowId) )

				IF(@CustomApplicationWorkflowNameCount > 0)
				BEGIN 
				
				RAISERROR(50001,16,1,'CustomApplicationWorkflowName')

				END
				ELSE 
				BEGIN
				  
				DECLARE @Currentdate DATETIME = GETDATE()

			IF(@CustomApplicationWorkflowId IS NULL)
			BEGIN
				
				
			    SET @CustomApplicationWorkflowId = NEWID()

				INSERT INTO [dbo].[CustomApplicationWorkflow](
					            [Id],
								[CustomApplicationId],
								[FormId],
								[WorkflowTypeId],
								[WorkflowXml],
								[WorkflowName],
								[WorkflowTrigger],
								[RuleJson],
								[CreatedDateTime],
					            [CreatedByUserId]
								)
					     SELECT @CustomApplicationWorkflowId,
								@CustomApplicationId,
								@CustomApplicationFormId,
								@CustomApplicationWorkflowTypeId,
								@WorkflowXml,
								@WorkflowName,
								@WorkflowTrigger,
								@RuleJson,
					            @Currentdate,
								@OperationsPerformedBy
					   
				SELECT @CustomApplicationWorkflowId

				END
				ELSE
				BEGIN
					
					UPDATE [dbo].[CustomApplicationWorkflow] 
					SET [RuleJson] = @RuleJson
					    ,[UpdatedDateTime] = @Currentdate
                        ,[WorkflowXml] = @WorkflowXml
						,[WorkflowName] = @WorkflowName
						,[WorkflowTrigger] = @WorkflowTrigger
						,[UpdatedByUserId] = @OperationsPerformedBy
					WHERE Id = @CustomApplicationWorkflowId
					    
				  END

		     END
				END


			 END

    END
    END TRY
    BEGIN CATCH

         THROW

     END CATCH
END
GO
