-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Categories And SubCategories upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCategoriesAndSubcategories] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCategoriesAndSubcategories]
(
	@AuditId UNIQUEIDENTIFIER = NULL,
	@operationsPerformedBy UNIQUEIDENTIFIER
)
AS 
SET NOCOUNT ON
BEGIN
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditId)

	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN

			IF(@AuditId = '00000000-0000-0000-0000-000000000000') SET @AuditId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT TSSInner.Id,
			       TSSInner.CategoryName AS [Value],
				   TSSInner.ParentAuditCategoryId,
				   TSSInner.OriginalName,
				   TSSInner.[TimeStamp],
				   TSSInner.CategoryDescription,
				   TSSInner.AuditComplianceId,
				   (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchive
			FROM AuditCategory AC WITH (NOLOCK)
			     CROSS APPLY [dbo].[Ufn_GetCategoriesAndSubcategories](AC.Id) TSSInner
				 INNER JOIN AuditCompliance ACC WITH (NOLOCK) ON ACC.Id = AC.AuditComplianceId AND ACC.InActiveDateTime IS NULL 
			WHERE AC.ParentAuditCategoryId IS NULL 
			      AND (@AuditId IS NULL OR AC.AuditComplianceId = @AuditId)
				  AND AC.InActiveDateTime IS NULL
				  AND ACC.CompanyId = @CompanyId
				  AND ACC.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
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