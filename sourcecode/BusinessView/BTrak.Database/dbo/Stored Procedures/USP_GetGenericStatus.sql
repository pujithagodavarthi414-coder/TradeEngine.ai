CREATE PROCEDURE [dbo].[USP_GetGenericStatus]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @WorkFlowId UNIQUEIDENTIFIER = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
  @GenericStatusId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
 	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  IF (@HavePermission = '1')
          BEGIN
						SELECT Id AS GenericStatusId,
								  WorkFlowId,
								  ReferenceTypeId,
								  ReferenceId,
								  [Status]
								  FROM GenericStatus WHERE CreatedByUserId = @OperationsPerformedBy AND CompanyId = @CompanyId 
														   AND (@ReferenceId IS NULL OR ReferenceId = @ReferenceId)
														   AND (@ReferenceTypeId IS NULL OR ReferenceTypeId = @ReferenceTypeId)
														   AND (@GenericStatusId IS NULL OR Id = @GenericStatusId)
														  AND (IsArchived IS NULL OR IsArchived = 0)
		  END
		  ELSE
                 
		   RAISERROR (@HavePermission,11, 1)
                   
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO