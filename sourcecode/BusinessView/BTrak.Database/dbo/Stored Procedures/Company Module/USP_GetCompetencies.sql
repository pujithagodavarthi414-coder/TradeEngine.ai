 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-17 00:00:00.000'
-- Purpose      To Get Competencies
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCompetencies] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCompetencies]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER ,
     @CompetencyId UNIQUEIDENTIFIER = NULL,    
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
 
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            IF(@SearchText = '') SET @SearchText = NULL
            
            SET @SearchText = '%'+ @SearchText +'%'
 
            IF(@CompetencyId = '00000000-0000-0000-0000-000000000000') SET @CompetencyId = NULL
            
            SELECT C.Id AS CompetencyId,
                      C.CompetencyName,
                      C.CreatedDateTime,
                      C.CreatedByUserId,
                      C.[TimeStamp],
                      TotalCount = COUNT(1) OVER()
            FROM Competency C           
            WHERE (@SearchText IS NULL OR (C.CompetencyName LIKE @SearchText))
			    AND (@CompanyId = C.CompanyId)
				AND (@CompetencyId IS NULL OR C.Id = @CompetencyId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
            ORDER BY C.CompetencyName ASC
 
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