CREATE PROCEDURE [dbo].[USP_GetCustomApplicationWorkflowTypes]
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

			SELECT  Id AS CustomApplicationWorkflowTypeId
					,WorkFlowTypeName AS CustomApplicationWorkflowTypeName
					,CreatedDateTime
			FROM WorkFlowType

			WHERE InActiveDateTime IS NULL
			ORDER BY CreatedDateTime ASC

		END
		ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END

	END TRY
	BEGIN CATCH
       
       THROW

	END CATCH
END
