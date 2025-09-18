CREATE PROCEDURE [dbo].[USP_UpsertDefaultWorkflow]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @AuditDefaultWorkflowId UNIQUEIDENTIFIER,
   @ConductDefaultWorkflowId UNIQUEIDENTIFIER,
   @QuestionDefaultWorkflowId UNIQUEIDENTIFIER
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
				DECLARE @Count INT = (SELECT COUNT(1) FROM DefaultWorkFlowForReferenceTypes WHERE CompanyId = @CompanyId)
				IF(@Count > 0) 
				BEGIN
					UPDATE DefaultWorkFlowForReferenceTypes SET 
																AuditDefaultWorkflowId    = @AuditDefaultWorkflowId,
																ConductDefaultWorkflowId  = @ConductDefaultWorkflowId,
																QuestionDefaultWorkflowId = @QuestionDefaultWorkflowId,
																UpdatedByUserId			  = @OperationsPerformedBy,
																UpdatedDateTime			  = GETDATE()
																WHERE CompanyId = @CompanyId
				END
				ELSE 
				BEGIN
					INSERT INTO DefaultWorkFlowForReferenceTypes (	Id,
																	AuditDefaultWorkflowId,
										 							ConductDefaultWorkflowId,
																	QuestionDefaultWorkflowId,
																	CreatedByUserId,
																	CreatedDateTime,
																	CompanyId
																 )
																SELECT  NEWID(),
																		@AuditDefaultWorkflowId,
																		@ConductDefaultWorkflowId,
																		@QuestionDefaultWorkflowId,
																		@OperationsPerformedBy,
																		GETDATE(),
																		@CompanyId
																	
				END

			END
			ELSE
					RAISERROR (@HavePermission,11, 1)
		END TRY
	BEGIN CATCH
											       
		THROW
											
	END CATCH 
END







