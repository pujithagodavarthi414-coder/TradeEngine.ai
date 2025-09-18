-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Education Levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetEducationLevels] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEducationLevels]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @EducationLevelId UNIQUEIDENTIFIER = NULL,
	 @EducationLevel NVARCHAR(50) = NULL,    
     @SearchText NVARCHAR(250) = NULL,
	 @IsArchived BIT = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            IF(@SearchText = '') SET @SearchText = NULL
            
            SET @SearchText = '%'+ @SearchText +'%'
 
            IF(@EducationLevelId = '00000000-0000-0000-0000-000000000000') SET @EducationLevelId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            SELECT  EL.Id AS EducationLevelId,
                      EL.EducationLevel EducationLevelName,
                      EL.CreatedDateTime,
                      EL.CreatedByUserId,
                      EL.[TimeStamp],
					  CASE WHEN EL.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM EducationLevel EL WHERE EL.CompanyId = @CompanyId
                AND (@SearchText IS NULL OR (EL.EducationLevel LIKE '%' + @SearchText + '%'))
				AND (@EducationLevelId IS NULL OR EL.Id = @EducationLevelId)
				AND (@EducationLevel IS NULL OR EL.EducationLevel = @EducationLevel)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EL.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EL.InactiveDateTime IS NULL))
            ORDER BY EL.EducationLevel ASC
 
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