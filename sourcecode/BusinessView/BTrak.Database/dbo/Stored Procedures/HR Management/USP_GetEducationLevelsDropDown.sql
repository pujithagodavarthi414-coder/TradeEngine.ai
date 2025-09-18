-------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-09-05 00:00:00.000'
-- Purpose      To Get Education Levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEducationLevelsDropDown] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'B.Tech'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEducationLevelsDropDown]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @SearchText NVARCHAR(250) = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
          IF(@SearchText = '') SET @SearchText = NULL
          
          SET @SearchText = '%'+ @SearchText +'%'
 
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
          SELECT EL.Id AS EducationLevelId,
                 EL.EducationLevel EducationLevelName
          FROM EducationLevel EL
		  WHERE EL.CompanyId = @CompanyId
                AND (@SearchText IS NULL OR (EL.EducationLevel LIKE '%' + @SearchText + '%'))
			    AND (EL.InactiveDateTime IS NULL)
           ORDER BY EL.EducationLevel ASC
         
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO