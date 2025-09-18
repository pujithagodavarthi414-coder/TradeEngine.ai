---------------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To get the FileHistory by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetFileHistory] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetFileHistory]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @FileId UNIQUEIDENTIFIER = NULL,    
    @SearchText NVARCHAR(250) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')

        BEGIN

           IF(@SearchText   = '') SET @SearchText   = NULL
                          
           IF(@FileId = '00000000-0000-0000-0000-000000000000') SET @FileId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))          
                                 
           SELECT FH.Id AS FileHistoryId,
                  UF.[FileName],
                  FH.FileId,
                  FH.CreatedDateTime,
                  FH.CreatedByUserId,
                  TotalCount = COUNT(1) OVER() 
           FROM FileHistory AS FH
           LEFT JOIN UploadFile AS UF ON FH.FileId = UF.Id
           LEFT JOIN FileHistory ON FH.FileId = UF.Id
           LEFT JOIN ReferenceType AS RT ON RT.Id = UF.ReferenceTypeId
           WHERE (@FileId IS NULL OR FH.FileId = @FileId)
		         AND (@SearchText IS NULL 
				 OR (UF.[FileName] LIKE '%'+ @SearchText +'%'  ))  
                                   
           ORDER BY UF.FileName ASC

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