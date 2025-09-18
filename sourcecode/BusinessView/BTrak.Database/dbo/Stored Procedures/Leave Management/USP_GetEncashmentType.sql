----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-07 00:00:00.000'
-- Purpose      To get encashment types by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetEncashmentType] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @EncashmentTypeId = '805306A8-D55D-40A5-9597-CE9B5DEC1252'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEncashmentType]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @EncashmentTypeId UNIQUEIDENTIFIER = NULL,  
    @SearchText NVARCHAR(250) = NULL
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
           IF(@EncashmentTypeId = '00000000-0000-0000-0000-000000000000') SET @EncashmentTypeId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT ET.Id AS EncashmentTypeId,
                  ET.EncashmentType,  
				  ET.CompanyId,    
                  CASE WHEN ET.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                  ET.CreatedDateTime ,
                  ET.CreatedByUserId,
                  TotalCount = COUNT(1) OVER()
           FROM EncashmentType AS ET
           WHERE (@SearchText   IS NULL OR (ET.EncashmentType LIKE @SearchText ))                
                AND (@EncashmentTypeId IS NULL OR ET.Id = @EncashmentTypeId)
                AND ET.CompanyId = @CompanyId
                                
           ORDER BY ET.EncashmentType ASC
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


