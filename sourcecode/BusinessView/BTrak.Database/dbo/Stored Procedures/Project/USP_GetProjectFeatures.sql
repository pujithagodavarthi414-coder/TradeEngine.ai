-----------------------------------------------------------------------------------------
-- Author       Pujitha Godavarthi
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the ProjectFeatures By Applying Different Features
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProjectFeatures] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived = 0
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProjectFeatures]
(
  @ProjectFeatureId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @ProjectFeatureName NVARCHAR(250) = NULL,
  @ProjectFeatureResponsiblePersonId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @IsDelete BIT = NULL,
  @IsArchived BIT = NULL,
  @PageNo INT = 1,
  @PageSize INT = 10
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

		  IF (@IsArchived IS NULL) SET @IsArchived = 0

		  IF (@IsDelete IS NULL) SET @IsDelete = 0
          
          IF(@ProjectFeatureId = '00000000-0000-0000-0000-000000000000') SET @ProjectFeatureId = NULL

          IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
          
          IF(@ProjectFeatureResponsiblePersonId = '00000000-0000-0000-0000-000000000000') SET @ProjectFeatureResponsiblePersonId = NULL
          
          IF(@ProjectFeatureName = '') SET @ProjectFeatureName = NULL
          SELECT PF.Id AS ProjectFeatureId,
                 PF.ProjectFeatureName,
                 PF.ProjectId,
                 PF.IsDelete,
                 PF.CreatedByUserId,
                 PF.CreatedDateTime,
                 P.ProjectName,
                 PFR.UserId AS ProjectFeatureResponsiblePersonId,
                 U.FirstName +' '+ISNULL(U.SurName,'') AS ProjectFeatureResponsiblePersonName,
                 U.ProfileImage,
                 PF.[TimeStamp],
				 PF.CreatedDateTime,
                 TotalCount = COUNT(1)OVER()
            FROM [dbo].[ProjectFeature] PF WITH (NOLOCK)
			     INNER JOIN [dbo].[Project] P ON P.Id = PF.ProjectId AND P.InActiveDateTime IS NULL AND (@ProjectId IS NULL OR PF.ProjectId = @ProjectId)
                 LEFT JOIN [dbo].[ProjectFeatureResponsiblePerson] PFR ON PF.Id = PFR.ProjectFeatureId  
                 LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON U.Id = PFR.UserId
            WHERE P.CompanyId = @CompanyId
			      AND  P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
                  AND (@ProjectFeatureId IS NULL OR PF.Id = @ProjectFeatureId)
                  AND (@ProjectFeatureName IS NULL OR PF.ProjectFeatureName = @ProjectFeatureName)
                  AND (@ProjectFeatureResponsiblePersonId IS NULL OR PFR.UserId = @ProjectFeatureResponsiblePersonId)
                  AND (@IsDelete IS NULL 
                       OR (@IsDelete = 0 AND (PF.IsDelete = @IsDelete OR PF.IsDelete IS NULL))
                       OR (@IsDelete = 1 AND PF.IsDelete = @IsDelete))
                  AND (@IsArchived IS NULL 
                       OR (@IsArchived = 1 AND PF.InActiveDateTime IS NOT NULL) 
                       OR (@IsArchived = 0 AND PF.InActiveDateTime IS NULL))
            ORDER BY ProjectFeatureName ASC 
       
            OFFSET ((@PageNo - 1) * @PageSize) ROWS
            
            FETCH NEXT @PageSize ROWS ONLY
         
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
  