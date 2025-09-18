CREATE PROCEDURE [dbo].[USP_ArchiveGenericStatusOfAuditQuestions]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @AuditId UNIQUEIDENTIFIER
)
AS
BEGIN
 	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	      DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  IF (@HavePermission = '1')
          BEGIN
						UPDATE GenericStatus 
						SET IsArchived = 1
						WHERE ReferenceId IN (
						Select AQ.Id from AuditCompliance A 
						JOIN AuditCategory AC ON A.Id = AC.AuditComplianceId AND A.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
						JOIN AuditQuestions AQ ON AQ.AuditCategoryId = AC.Id AND AQ.InActiveDateTime IS NULL WHERE A.Id = @AuditId)
		  END
		  ELSE
                 
		   RAISERROR (@HavePermission,11, 1)
                   
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO