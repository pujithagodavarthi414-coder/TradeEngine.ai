 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-14 00:00:00.000'
-- Purpose      To Get Reporting Methods
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetMemberShipDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetMemberShipDetails]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @MemberShipType NVARCHAR(50) = NULL,
     @MemberShipId UNIQUEIDENTIFIER = NULL,    
     @SearchText NVARCHAR(250) = NULL,
	 @IsArchived BIT = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @HavePeMission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePeMission = '1')
         BEGIN
 
            IF(@SearchText = '') SET @SearchText = NULL
            
            SET @SearchText = '%'+ @SearchText +'%'
 
            IF(@MemberShipId = '00000000-0000-0000-0000-000000000000') SET @MemberShipId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            SELECT  M.Id AS MemberShipId,
                    M.MemberShipType AS MemberShipName,
                    M.CreatedDateTime,
                    M.CreatedByUserId,
                    M.[TimeStamp],
					CASE WHEN M.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                    TotalCount = COUNT(1) OVER()
            FROM MemberShip M              
            WHERE M.CompanyId = @CompanyId 
                AND (@SearchText IS NULL OR (M.MemberShipType LIKE '%' + @SearchText + '%'))
				AND (@MemberShipId IS NULL OR M.Id = @MemberShipId)
				AND (@MemberShipType IS NULL OR M.MemberShipType = @MemberShipType)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND M.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND M.InactiveDateTime IS NULL))
            ORDER BY M.MemberShipType ASC
 
         END
         ELSE
         BEGIN
         
                 RAISERROR (@HavePeMission,11, 1)
                 
         END
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
 Go