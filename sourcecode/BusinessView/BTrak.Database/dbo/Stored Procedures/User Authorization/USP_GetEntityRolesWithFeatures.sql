---------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-09-08 00:00:00.000'
-- Purpose      To Get the Entity Roles and Entity Features by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEntityRolesWithFeatures] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEntityRolesWithFeatures]
( 
   @EntityRoleId UNIQUEIDENTIFIER = NULL, 
   @EntityRoleName NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @IsArchived BIT = NULL	
)
AS
BEGIN
    
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    BEGIN TRY
        
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
	     IF (@HavePermission = '1')
         BEGIN

	        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	        IF(@EntityRoleId = '00000000-0000-0000-0000-000000000000') SET @EntityRoleId = NULL

	        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	        IF(@EntityRoleName = '') SET @EntityRoleName = NULL

            SELECT ER.Id AS EntityRoleId
                   ,ER.EntityRoleName
                   ,ER.CreatedByUserId
                   ,ER.CreatedDateTime
                   ,ER.[TimeStamp]
				   ,CASE WHEN ER.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived
                   ,(SELECT EF.Id AS EntityFeatureId,EF.EntityFeatureName,CONVERT(BIT,1) AS IsActive
					         FROM EntityFeature AS EF
                                  INNER JOIN EntityRoleFeature ERF ON ERF.EntityFeatureId = EF.Id
						     WHERE ERF.EntityRoleId = ER.Id 
                                   AND EF.InActiveDateTime IS NULL
                                   AND ERF.InActiveDateTime IS NULL
					  FOR JSON PATH) AS Features
            FROM EntityRole ER
            WHERE ER.CompanyId = @CompanyId
                  AND (@EntityRoleId IS NULL OR ER.Id = @EntityRoleId)
                  AND (@EntityRoleName IS NULL OR ER.EntityRoleName = @EntityRoleName)
				  AND (@SearchText IS NULL OR ER.EntityRoleName LIKE '%'+ @SearchText+'%')
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ER.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ER.InActiveDateTime IS NULL))
         
         END
	     ELSE
	        RAISERROR(@HavePermission,11,1)

    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH

END 
GO
