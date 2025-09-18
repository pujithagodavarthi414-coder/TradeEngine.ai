CREATE PROCEDURE [dbo].[USP_SearchAuditFolders]
(
   @AuditFolderId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
    DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditFolder WHERE Id = @AuditFolderId)

    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

      IF(@HavePermission = '1')
      BEGIN
            
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
           SELECT AF.Id AuditId,
                  AF.AuditFolderName AuditName,
                  AF.ParentAuditFolderId ParentAuditId,
                  PAF.AuditFolderName ParentAuditName,
                  AF.[TimeStamp],
                  AF.CreatedDateTime,
                  AF.CreatedByUserId
           FROM AuditFolder AF
                LEFT JOIN AuditFolder PAF ON PAF.Id = AF.ParentAuditFolderId
           WHERE (@AuditFolderId IS NULL OR AF.Id = @AuditFolderId)
                 AND AF.CompanyId = @CompanyId
               
	  END
      ELSE
      BEGIN
      
           RAISERROR (@HavePermission,10, 1)
      
      END
    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
