-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-09 00:00:00.000'
-- Purpose      To Save or Update GoalWorkFlow
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertGoalWorkFlow] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalId='E4B3A452-B63A-4943-BA51-00E1F102BBBE',@WorkFlowId='29728349-6950-4CD8-822C-138C2ABDBF9A'

CREATE PROCEDURE [dbo].[USP_UpsertGoalWorkFlow]
(
  @GoalWorkFlowId UNIQUEIDENTIFIER = NULL,
  @GoalId UNIQUEIDENTIFIER = NULL,
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

	    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
        BEGIN

			DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

			DECLARE @IsLatest BIT = (CASE WHEN @GoalWorkFlowId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [GoalWorkFlow] WHERE Id = @GoalWorkFlowId) = @TimeStamp
																THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
			BEGIN

				IF(@GoalWorkFlowId IS NULL)
				BEGIN

					SET @GoalWorkFlowId = NEWID()
			       INSERT INTO [dbo].[GoalWorkFlow](
				            [Id],
				            [GoalId],
				            [WorkflowId],
				            [CreatedDateTime],
				            [CreatedByUserId],
							[InActiveDateTime]
							)
				     SELECT @GoalWorkFlowId,
				            @GoalId,
				            @WorkflowId,
				            @Currentdate,
				            @OperationsPerformedBy,
			                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
			     
				 END
				 ELSE
				 BEGIN

					UPDATE [dbo].[GoalWorkFlow]
						SET  [GoalId]			   =  		@GoalId,
				            [WorkflowId]		   =  		@WorkflowId,
				            [UpdatedDateTime]	   =  		@Currentdate,
				            [UpdatedByUserId]	   =  		@OperationsPerformedBy,
							[InActiveDateTime]	   =  		CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @GoalWorkFlowId

				 END
				  SELECT Id FROM [dbo].[GoalWorkFlow] WHERE Id = @GoalWorkFlowId

			END	

			ELSE

			  RAISERROR (50008,11, 1)

		END

		--ELSE 
  --      BEGIN
        
  --         RAISERROR (@HavePermission,11, 1)
        
  --      END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO