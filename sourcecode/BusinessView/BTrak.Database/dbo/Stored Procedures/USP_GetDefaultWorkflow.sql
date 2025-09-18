CREATE PROCEDURE [dbo].[USP_GetDefaultWorkflow]
(
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
					SELECT
						AuditDefaultWorkflowId,   
						ConductDefaultWorkflowId,
						QuestionDefaultWorkflowId
						FROM DefaultWorkFlowForReferenceTypes 
						WHERE CompanyId = @CompanyId
			END
			ELSE
					RAISERROR (@HavePermission,11, 1)
		END TRY
	BEGIN CATCH
											       
		THROW
											
	END CATCH 
END







