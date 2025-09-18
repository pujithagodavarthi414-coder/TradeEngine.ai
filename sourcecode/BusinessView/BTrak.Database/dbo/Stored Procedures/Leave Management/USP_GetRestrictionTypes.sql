----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-07 00:00:00.000'
-- Purpose      To get restriction type by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetRestrictionTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @RestrictionTypeId = 'C7BE2D45-9926-4B8A-8CA6-C68E348EA5F6'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRestrictionTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @RestrictionTypeId UNIQUEIDENTIFIER = NULL,  
    @SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@SearchText   = '') SET @SearchText   = NULL

		   SET @SearchText = '%'+ @SearchText +'%';              
           IF(@RestrictionTypeId = '00000000-0000-0000-0000-000000000000') SET @RestrictionTypeId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT RT.Id AS RestrictionTypeId,
                  RT.Restriction AS RestrictionType,  
				  RT.LeavesCount,    
                  RT.IsWeekly,
                  RT.IsMonthly,
				  RT.IsQuarterly,
				  RT.IsHalfYearly,
				  RT.IsYearly,
				  RT.CompanyId,
				  CASE WHEN RT.IsWeekly = 1 THEN 'Weekly' 
				       WHEN RT.IsMonthly = 1 THEN 'Monthly'
				       WHEN RT.IsQuarterly = 1 THEN 'Quarterly'
				       WHEN RT.IsHalfYearly = 1 THEN 'Half yearly'
				       WHEN RT.IsYearly = 1 THEN 'Yearly'
				 END AS [Type],
				  CASE WHEN RT.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
                  RT.[TimeStamp],   
                  TotalCount = COUNT(1) OVER()
           FROM RestrictionType AS RT
           WHERE RT.CompanyId = @CompanyId
                AND (@SearchText IS NULL OR (RT.Restriction LIKE @SearchText ))                
                AND (@RestrictionTypeId IS NULL OR RT.Id = @RestrictionTypeId)
				AND (@IsArchived IS NULL OR (@IsArchived = 0 AND RT.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND RT.InActiveDateTime IS NOT NULL))
                                
           ORDER BY RT.Restriction ASC
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