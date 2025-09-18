-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-09 00:00:00.000'
-- Purpose      To Save or Update WorkflowEligibleStatusTransition
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertWorkflowEligibleStatusTransition] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkflowEligibleStatusTransitionId='dd9db945-a190-43cb-ad43-0d01d0776884',@RoleGuids=N'<?xml version="1.0" encoding="utf-16"?><GenericListOfGuid xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><ListItems><guid>5a678ce2-f096-4da0-bacb-fcfdca40f573</guid><guid>d83da6a1-1ccb-4eb9-b636-9b0b87d90213</guid><guid>4d5adf0f-88df-462c-a987-38ac05aeab0c</guid></ListItems></GenericListOfGuid>',
--@FromWorkflowUserStoryStatusId ='e1418ce8-a51b-4de5-aff3-42f8a588e3ae', @ToWorkflowUserStoryStatusId='7503dace-d75a-4df1-b687-64334263b908',@WorkflowId='e36ca831-a26e-414d-80cf-8c340cc3b395'
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertWorkflowEligibleStatusTransition]
(
  @WorkflowEligibleStatusTransitionId UNIQUEIDENTIFIER = NULL,
  @FromWorkflowUserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @ToWorkflowUserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @WorkflowId UNIQUEIDENTIFIER = NULL,
  --@TransitionDeadlineId UNIQUEIDENTIFIER = NULL,
  --@DisplayName NVARCHAR(100) = NULL,
  @RoleGuids XML = NULL,
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
        
			IF @IsArchived IS NULL SET @IsArchived = 0

			IF (@WorkflowId IS NULL) 
			BEGIN
				
				RAISERROR(50011,11,1,'WorkFlow')

			END
			ELSE IF (@ToWorkflowUserStoryStatusId IS NULL)
			BEGIN

				RAISERROR(50011,11,1,'ToWorkFlowUserStoryStatus')

			END
			ELSE IF (@FromWorkflowUserStoryStatusId IS NULL)
			BEGIN

				RAISERROR(50011,11,1,'FromWorkFlowUserStoryStatus')

			END
			ELSE IF (@FromWorkflowUserStoryStatusId  = @ToWorkflowUserStoryStatusId)
			BEGIN

				RAISERROR('PleaseSelectDifferentTransitions',11,1)

			END
			ELSE
			BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @WorkFlowEligibleTransistionIdCount INT = (SELECT COUNT(1) FROM WorkflowEligibleStatusTransition 
				                                                   WHERE Id = @WorkflowEligibleStatusTransitionId AND CompanyId = @CompanyId)

				DECLARE @FromToWorkflowUserStoryStatusIdCount INT = (SELECT COUNT(1) FROM WorkflowEligibleStatusTransition 
				                                                     WHERE ToWorkflowUserStoryStatusId = @ToWorkflowUserStoryStatusId 
																	 AND CompanyId = @CompanyId 
																	 AND FromWorkflowUserStoryStatusId = @FromWorkflowUserStoryStatusId 
																	 AND WorkFlowId = @WorkflowId 
																	 AND (@WorkflowEligibleStatusTransitionId IS NULL 
																	      OR Id <> @WorkflowEligibleStatusTransitionId) 
																	 AND InActiveDateTime IS NULL)

				IF (@WorkFlowEligibleTransistionIdCount = 0 AND @WorkflowEligibleStatusTransitionId IS NOT NULL)
				BEGIN

					RAISERROR(50002,11,1,'WorkFlowEligibleTransition')
				  
				END
				ELSE IF (@FromToWorkflowUserStoryStatusIdCount > 0 AND @IsArchived = 0)
				BEGIN

					RAISERROR('WorkFlowEligibleTransitionAlreadyExists',11,1)

				END		
				ELSE
				BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @WorkflowEligibleStatusTransitionId IS NULL THEN 1 
				                              ELSE CASE WHEN (SELECT [TimeStamp] FROM WorkflowEligibleStatusTransition 
											                  WHERE Id = @WorkflowEligibleStatusTransitionId) = @TimeStamp THEN 1 ELSE 0 END END)
				
				IF (@IsLatest = 1)
				BEGIN
				   
				DECLARE @Currentdate DATETIME = GETDATE()

				IF(@WorkflowEligibleStatusTransitionId IS NOT NULL AND @IsArchived = 1)
				BEGIN
					
						UPDATE [dbo].[WorkflowEligibleStatusTransition]
							SET  InActiveDateTime  =  @Currentdate,
							     [UpdatedDateTime] = @Currentdate,
								 [UpdatedByUserId] = @OperationsPerformedBy
							WHERE Id = @WorkflowEligibleStatusTransitionId

				END

				DECLARE @FromToWorkflowUserStoryStatusIdCountNew INT = (SELECT COUNT(1) FROM WorkflowEligibleStatusTransition 
				                                                        WHERE ToWorkflowUserStoryStatusId = @ToWorkflowUserStoryStatusId 
																		AND CompanyId = @CompanyId 
																		AND FromWorkflowUserStoryStatusId = @FromWorkflowUserStoryStatusId 
																		AND WorkFlowId = @WorkflowId  AND InActiveDateTime IS NULL)

				IF(@FromToWorkflowUserStoryStatusIdCountNew > 0 AND @IsArchived = 1)
				BEGIN
					
					DECLARE @StatusId UNIQUEIDENTIFIER = (SELECT Id FROM WorkflowEligibleStatusTransition WHERE 
																		ToWorkflowUserStoryStatusId = @ToWorkflowUserStoryStatusId 
																		AND CompanyId = @CompanyId 
																		AND FromWorkflowUserStoryStatusId = @FromWorkflowUserStoryStatusId 
																		AND WorkFlowId = @WorkflowId 
																		AND InActiveDateTime IS NULL)
					
					UPDATE UserStoryWorkflowStatusTransition SET WorkflowEligibleStatusTransitionId = @StatusId WHERE WorkflowEligibleStatusTransitionId = @WorkflowEligibleStatusTransitionId AND InActiveDateTime IS NULL

				END
				ELSE
				BEGIN
					
					SET @WorkflowEligibleStatusTransitionId = NEWID()

				    INSERT INTO [dbo].[WorkflowEligibleStatusTransition](
				               Id,
				               FromWorkflowUserStoryStatusId,
				               ToWorkflowUserStoryStatusId,
				               WorkflowId,
				               CreatedDateTime,
				               CreatedByUserId,
				  			   CompanyId
				               )
				        SELECT @WorkflowEligibleStatusTransitionId,
				               @FromWorkflowUserStoryStatusId,
				               @ToWorkflowUserStoryStatusId,
				               @WorkFlowId,
				               @Currentdate,
				               @OperationsPerformedBy,
				  			   @CompanyId

				END

				IF(@IsArchived = 1)
				BEGIN

					UPDATE UserStoryWorkflowStatusTransition SET WorkflowEligibleStatusTransitionId = @WorkflowEligibleStatusTransitionId 
					       WHERE WorkflowEligibleStatusTransitionId = @WorkflowEligibleStatusTransitionId AND InActiveDateTime IS NULL

				END		

				SELECT Id FROM [dbo].[WorkflowEligibleStatusTransition] WHERE Id = @WorkflowEligibleStatusTransitionId
				
				END 

				ELSE
					RAISERROR(50008,11,1)

		   END
		END
	END
    ELSE

          RAISERROR(@HavePermission,11,1) 

   END TRY
   BEGIN CATCH
         THROW
   END CATCH
 END
 GO