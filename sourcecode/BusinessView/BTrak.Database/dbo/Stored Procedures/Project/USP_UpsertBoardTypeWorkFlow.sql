-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-09 00:00:00.000'
-- Purpose      To Save or Update BoardTypeWorkFlow
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertBoardTypeWorkFlow] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@BoardTypeId='B2684575-8FF4-4826-877D-3119B776441E',@WorkFlowId='E36CA831-A26E-414D-80CF-8C340CC3B395'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBoardTypeWorkFlow]
(
  @BoardTypeWorkFlowId UNIQUEIDENTIFIER = NULL,
  @BoardTypeId UNIQUEIDENTIFIER = NULL,
  @WorkFlowId UNIQUEIDENTIFIER = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT = NULL,
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
		DECLARE @BoardTypeWorkFlowIdCount INT = (SELECT COUNT(1) FROM BoardTypeWorkFlow WHERE Id = @BoardTypeWorkFlowId)

		DECLARE @BoardTypeIdCount INT = (SELECT COUNT(1) FROM BoardTypeWorkFlow WHERE BoardTypeId = @BoardTypeId AND WorkFlowId = @WorkFlowId AND (@BoardTypeWorkFlowId IS NULL OR Id <> @BoardTypeWorkFlowId))

		IF(@BoardTypeId IS NULL)
		BEGIN
		
		RAISERROR(50011,16, 2, 'BoardTypeId')
		
		END
		ELSE IF(@WorkFlowId IS NULL)
		BEGIN
		
		RAISERROR(50011,16, 2, 'WorkflowId')
		
		END
		ELSE IF(@BoardTypeWorkFlowIdCount = 0 AND @BoardTypeWorkFlowId IS NOT NULL)
		BEGIN
		
			RAISERROR(50002,16, 1,'BoardTypeWorkflow')
		
		END
		ELSE IF(@BoardTypeIdCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'BoardTypeWorkFlow')

		END
		ELSE
		BEGIN

        DECLARE @IsLatest BIT = (CASE WHEN @BoardTypeWorkFlowId IS NULL THEN 1 ELSE 
		                         CASE WHEN (SELECT [TimeStamp] FROM BoardTypeWorkFlow WHERE Id = @BoardTypeWorkFlowId) = @TimeStamp THEN 1 ELSE 0 END END)

		IF (@IsLatest = 1)
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@BoardTypeWorkFlowId IS NOT NULL)
		BEGIN

			UPDATE [dbo].[BoardTypeWorkFlow]
		    SET BoardTypeId = @BoardTypeId,
			    WorkFlowId = @WorkFlowId,
			    UpdatedDateTime = @Currentdate,
			    UpdatedByUserId = @OperationsPerformedBy,
				InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		    WHERE Id = @BoardTypeWorkFlowId 

		END
		ELSE
		BEGIN

			SELECT @BoardTypeWorkFlowId = NEWID()

			INSERT INTO [dbo].[BoardTypeWorkFlow](
			            [Id],
			            [BoardTypeId],
			            [WorkFlowId],
			            [CreatedDateTime],
			            [CreatedByUserId],
						[InActiveDateTime])
			     SELECT @BoardTypeWorkFlowId,
			            @BoardTypeId,
			            @WorkFlowId,
			            @Currentdate,
			            @OperationsPerformedBy,
						CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

		END

		SELECT Id FROM [dbo].[BoardTypeWorkFlow] WHERE Id = @BoardTypeWorkFlowId

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