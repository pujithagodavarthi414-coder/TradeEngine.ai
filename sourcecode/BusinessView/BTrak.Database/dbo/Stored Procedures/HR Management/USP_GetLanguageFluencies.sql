 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-16 00:00:00.000'
-- Purpose      To Get Languages
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetLanguageFluencies] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLanguageFluencies]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @LanguageFluencyId UNIQUEIDENTIFIER = NULL,    
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
 
            IF(@LanguageFluencyId = '00000000-0000-0000-0000-000000000000') SET @LanguageFluencyId = NULL

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
               SELECT F.Id AS LanguageFluencyId,
                      F.FluencyName AS  LanguageFluencyName,
                      F.CreatedDateTime,
                      F.CreatedByUserId,
				      CASE WHEN F.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                      F.[TimeStamp],
                      TotalCount = COUNT(1) OVER()
            FROM Fluency F            
            WHERE F.CompanyId = @CompanyId
			AND (@SearchText IS NULL OR (F.FluencyName LIKE @SearchText))
			AND (@LanguageFluencyId IS NULL OR F.Id = @LanguageFluencyId)
			AND (@IsArchived IS NULL OR (@IsArchived = 1 AND F.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND F.InActiveDateTime IS NULL))

            ORDER BY F.FluencyName ASC
 
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