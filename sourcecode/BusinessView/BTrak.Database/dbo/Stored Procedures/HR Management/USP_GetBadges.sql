-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Badges
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetBadges] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBadges]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @BadgeId UNIQUEIDENTIFIER = NULL,
	 @BadgeName NVARCHAR(50) = NULL,    
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
 
            IF(@BadgeId = '00000000-0000-0000-0000-000000000000') SET @BadgeId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  B.Id AS BadgeId,
                      B.BadgeName,
					  B.ImageUrl,
					  B.[Description],
                      B.CreatedDateTime,
                      B.CreatedByUserId,
                      B.[TimeStamp],
					  CASE WHEN B.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM Badge B WHERE B.CompanyId = @CompanyId
                AND (@SearchText IS NULL OR (B.BadgeName LIKE '%' + @SearchText + '%'))
				AND (@BadgeId IS NULL OR B.Id = @BadgeId)
				AND (@BadgeName IS NULL OR B.BadgeName = @BadgeName)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND B.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND B.InactiveDateTime IS NULL))
            ORDER BY B.BadgeName ASC
 
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
