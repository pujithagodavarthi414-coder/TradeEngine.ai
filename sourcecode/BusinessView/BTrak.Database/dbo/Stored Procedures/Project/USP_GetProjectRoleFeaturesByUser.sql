---------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2019-08-16 00:00:00.000'
-- Purpose      To Get the EntityTypeRoleFeature by applying Project and user filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProjectRoleFeaturesByUser] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProjectRoleFeaturesByUser]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER , 
    @EntityRoleId  UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
          
           IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
           SELECT ETRF.Id AS EntityRoleFeatureId,
                  ETRF.EntityFeatureId,
                  ETF.EntityFeatureName,
                  ER.EntityRoleName,
                  ETRF.EntityRoleId,
				  UP.ProjectId,
                  TotalCount = COUNT(1) OVER()
                FROM [dbo].[EntityRoleFeature] AS ETRF 
                INNER JOIN [EntityFeature] ETF ON ETF.Id = ETRF.EntityFeatureId AND ETF.InActiveDateTime IS NULL
                INNER JOIN [EntityRole] ER ON ER.Id = ETRF.EntityRoleId AND ER.InActiveDateTime IS NULL
				INNER JOIN (SELECT EntityRoleId,ProjectId 
				            FROM UserProject 
							WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL ) UP ON UP.EntityRoleId = ER.Id      
           WHERE ETRF.InActiveDateTime IS NULL
                AND ER.CompanyId = @CompanyId
                AND (@EntityRoleId IS NULL OR ETRF.EntityRoleId = @EntityRoleId)
				AND (@ProjectId IS NULL OR UP.ProjectId = @ProjectId)
           GROUP BY ETRF.Id,ETRF.EntityFeatureId,ETF.EntityFeatureName,ER.EntityRoleName,ETRF.EntityRoleId,UP.ProjectId
		   ORDER BY ETF.EntityFeatureName ASC
                             
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
GO