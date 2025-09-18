---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-21 00:00:00.000'
-- Purpose      To Get the EntityTypeRoleFeature by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEntityRoleFeatures] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEntityRoleFeatures]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER , 
    @EntityRoleFeatureId UNIQUEIDENTIFIER = NULL,
    @EntityFeatureId  UNIQUEIDENTIFIER = NULL,
    @EntityRoleId  UNIQUEIDENTIFIER = NULL,
    @EntityRoleName NVARCHAR(250) = NULL,
    @EntityFeatureName NVARCHAR(250) = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN
   SET NOCOUNT ON
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
                  (CASE WHEN ETRF.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
                  ETRF.CreatedDateTime,
                  ETRF.CreatedByUserId,
				  ETRF.[TimeStamp],
                  TotalCount = COUNT(1) OVER()
           FROM [dbo].[EntityRoleFeature] AS ETRF 
                INNER JOIN [EntityFeature] ETF ON ETF.Id = ETRF.EntityFeatureId AND ETF.InActiveDateTime IS NULL
                INNER JOIN [EntityRole] ER ON ER.Id = ETRF.EntityRoleId AND ER.InActiveDateTime IS NULL      
           WHERE ER.CompanyId = @CompanyId AND ETRF.InActiveDateTime IS NULL --TODO
                AND (@EntityRoleFeatureId IS NULL OR ETRF.Id = @EntityRoleFeatureId)
                AND (@EntityFeatureId IS NULL OR ETRF.EntityFeatureId = @EntityFeatureId)
                AND (@EntityRoleId IS NULL OR ETRF.EntityRoleId = @EntityRoleId)
                AND (@EntityRoleName IS NULL OR ER.EntityRoleName = @EntityRoleName)
				AND (@ProjectId IS NULL OR (ETRF.EntityRoleId IN (SELECT EntityRoleId FROM UserProject WHERE ProjectId = @ProjectId AND UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)))
                AND (@EntityFeatureName IS NULL OR ETF.EntityFeatureName = @EntityFeatureName)
                AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ETRF.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ETRF.InActiveDateTime IS NULL))
           GROUP BY ETRF.Id,ETRF.EntityFeatureId,ETF.EntityFeatureName,ER.EntityRoleName,ETRF.EntityRoleId,ETRF.InActiveDateTime,ETRF.CreatedDateTime ,ETRF.CreatedByUserId,ETRF.[TimeStamp]
           ORDER BY ETRF.CreatedDateTime ASC
                             
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