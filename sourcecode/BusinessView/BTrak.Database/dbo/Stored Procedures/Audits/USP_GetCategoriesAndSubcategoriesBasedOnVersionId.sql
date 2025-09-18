-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCategoriesAndSubcategoriesBasedOnVersionId] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCategoriesAndSubcategoriesBasedOnVersionId]
(
	@AuditId UNIQUEIDENTIFIER = NULL,
    @AuditComplianceVersionId UNIQUEIDENTIFIER = NULL,
	@operationsPerformedBy UNIQUEIDENTIFIER
)
AS 
SET NOCOUNT ON
BEGIN
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditId)
     
	 IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditComplianceVersions WHERE Id = @AuditComplianceVersionId)

	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN

			IF(@AuditId = '00000000-0000-0000-0000-000000000000') SET @AuditId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT TSSInner.Id,
			       TSSInner.CategoryName AS [Value],
				   TSSInner.ParentAuditCategoryId,
				   TSSInner.OriginalName,
				   NULL AS [TimeStamp],
				   TSSInner.CategoryDescription,
				   TSSInner.AuditComplianceId,
				   (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchive
			FROM AuditCategoryVersions AC WITH (NOLOCK)
			     CROSS APPLY [dbo].[Ufn_GetCategoriesAndSubcategoriesByVersionId](AC.Id,@AuditComplianceVersionId) TSSInner
				 INNER JOIN AuditComplianceVersions ACC WITH (NOLOCK) ON ACC.AuditId = AC.AuditComplianceId 
				            AND ACC.InActiveDateTime IS NULL 
							AND ACC.Id = @AuditComplianceVersionId
							AND AC.AuditComplianceVersionId = @AuditComplianceVersionId
			WHERE AC.ParentAuditCategoryId IS NULL 
			      AND (@AuditId IS NULL OR AC.AuditComplianceId = @AuditId)
				  AND AC.InActiveDateTime IS NULL
				  AND ACC.CompanyId = @CompanyId
				  AND ACC.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                        WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
			ORDER BY AC.CreatedDateTime,TSSInner.Path2
			OPTION (MAXRECURSION 0)

		END
        ELSE
        BEGIN
        
               RAISERROR (@HavePermission,11, 1)
               
        END	  
	END TRY
	BEGIN CATCH
		
		EXEC USP_GetErrorInformation

	END CATCH
END
GO
