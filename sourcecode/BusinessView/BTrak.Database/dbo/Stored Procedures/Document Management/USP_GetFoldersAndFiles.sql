-- Author       Sai Praneeth Mamidi
-- Created      '2019-10-25 00:00:00.000'
-- Purpose      To get all folders and files by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved

--EXEC  [dbo].[USP_GetFoldersAndFiles] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetFoldersAndFiles]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @ParentFolderId UNIQUEIDENTIFIER = NULL,
	@StoreId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT= NULL    
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')

        BEGIN

			IF(@SearchText   = '') SET @SearchText   = NULL
           
			IF(@ParentFolderId = '00000000-0000-0000-0000-000000000000') SET @ParentFolderId = NULL    
           
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))               
              
			SELECT	(SELECT F.Id folderId,
							F.FolderName folderName,
							isArchived = CASE WHEN F.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
							F.ParentFolderId parentFolderId,
							F.FolderSize,
							F.StoreId storeId,
							F.CreatedDateTime createdDateTime, 
							F.CreatedByUserId createdByUserId,
							F.[TimeStamp] [timeStamp],
							(SELECT COUNT(1) FROM Folder FC WHERE FC.ParentFolderId = F.Id) + (SELECT COUNT(1) FROM UploadFile UFC WHERE UFC.FolderId = F.Id) AS folderCount
					FROM Folder AS F        
					WHERE(@SearchText IS NULL OR (F.FolderName LIKE  '%'+ @SearchText +'%'))                
					     AND ((F.ParentFolderId IS NULL AND @ParentFolderId IS NULL) OR F.ParentFolderId = @ParentFolderId)
					     AND (@IsArchived IS NULL OR (@IsArchived = 1 AND F.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND F.InActiveDateTime IS NULL))
					     AND (@StoreId IS NULL OR F.StoreId = @StoreId)
					ORDER BY F.FolderName ASC
					FOR JSON PATH) AS Folders,
					(SELECT UF.Id AS fileId,
							UF.[FileName] AS [fileName],
							UF.FileExtension fileExtension,
							UF.FilePath filePath,
							UF.FileSize fileSize,  
							UF.FolderId folderId,
							UF.StoreId storeId,
							CASE WHEN UF.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS isArchived,
							UF.CreatedDateTime createdDateTime,
							UF.CreatedByUserId createdByUserId,
							UF.[TimeStamp] [timeStamp]
					FROM UploadFile AS UF        
					WHERE   (@SearchText   IS NULL OR (UF.FileName LIKE  '%'+ @SearchText +'%'  ))
							AND (@StoreId IS NULL OR UF.StoreId = @StoreId)  
							AND (@ParentFolderId IS NULL OR UF.FolderId = @ParentFolderId)
							AND (@IsArchived IS NULL OR (@IsArchived = 1 AND UF.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND UF.InActiveDateTime IS NULL))
					ORDER BY UF.[FileName] ASC
					FOR JSON PATH) AS Files,
					S.IsDefault
					FROM Store AS S
					WHERE   (@StoreId IS NULL OR S.Id = @StoreId)
							AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
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