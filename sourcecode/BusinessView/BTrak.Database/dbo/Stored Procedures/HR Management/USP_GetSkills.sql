 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Skills
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetSkills] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSkills]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @SkillId UNIQUEIDENTIFIER = NULL,    
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
 
            IF(@SkillId = '00000000-0000-0000-0000-000000000000') SET @SkillId = NULL
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT S.Id AS SkillId,
                      S.SkillName,
                      S.CreatedDateTime,
                      S.CreatedByUserId,
                      S.[TimeStamp],
					  CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM Skill S              
            WHERE S.CompanyId = @CompanyId
			     AND (@SearchText IS NULL OR (S.SkillName LIKE @SearchText))
				 AND (@SkillId IS NULL OR S.Id = @SkillId)
				 AND (@IsArchived IS NULL 
				      OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) 
					  OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
            ORDER BY S.SkillName ASC
 
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
 Go