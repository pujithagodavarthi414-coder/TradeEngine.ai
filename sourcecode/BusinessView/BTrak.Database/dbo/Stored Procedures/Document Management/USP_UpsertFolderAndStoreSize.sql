----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-12-05 00:00:00.000'
-- Purpose      To Upsert Folder And Store Size
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertFolderAndStoreSize] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@FolderId = '256D773B-ABCD-4315-A7EF-C4A30F0AE093',@StoreId = '3DF8829D-5527-4348-A239-191A72484ADA',@FilesSize=23891321
----------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertFolderAndStoreSize]
(
  @FolderId UNIQUEIDENTIFIER = NULL,
  @StoreId UNIQUEIDENTIFIER = NULL,
  @FilesSize BIGINT = NULL,
  @IsDeletion BIT = NULL, 
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
		IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL

		IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL

		IF(@FilesSize = '' ) SET @FilesSize = NULL

		IF(@FilesSize IS NULL) SET @FilesSize = 0
        
		IF(@StoreId IS NULL)
        
		BEGIN
                         
            RAISERROR(50011,16, 2, 'StoreId')
          
        END
        ELSE
        BEGIN

            DECLARE @FolderIdCount INT = (SELECT COUNT(1) FROM [Folder] WHERE Id = @FolderId AND (@IsDeletion = 1 OR (ISNULL(@IsDeletion,0) = 0 AND InActiveDateTime IS NULL)))
            
            DECLARE @StoreIdCount INT = (SELECT COUNT(1) FROM [Store] WHERE Id = @StoreId AND InActiveDateTime IS NULL)

			IF(@FolderIdCount = 0 AND @FolderId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'FolderId')
            
            END
			ELSE IF(@StoreIdCount = 0 AND @StoreId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'StoreId')
            
            END
            ELSE
            BEGIN

                DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
                IF (@HavePermission = '1')
                BEGIN
                
					DECLARE @Currentdate DATETIME = GETDATE()
                    
                    ;WITH Tree as
                    (
                     SELECT F.ParentFolderId AS Id
                     FROM Folder F
                     WHERE F.Id = @FolderId
  
                     UNION ALL
  
                     SELECT F1.ParentFolderId
                     FROM Folder F1
                     INNER JOIN Tree T
                     ON T.Id = F1.Id AND F1.InActiveDateTime IS NULL
                     WHERE T.Id IS NOT NULL
                    )

					UPDATE [dbo].[Folder] SET FolderSize = IIF(@IsDeletion = 0,(ISNULL(FolderSize,0) + @FilesSize),(FolderSize - @FilesSize))
														   WHERE Id IN (SELECT Id FROM Tree)

					UPDATE [dbo].[Folder] SET FolderSize = IIF(@IsDeletion = 0,(ISNULL(FolderSize,0) + @FilesSize),(FolderSize - @FilesSize))
														   WHERE Id = @FolderId
                    
					UPDATE [dbo].[Store] SET StoreSize = IIF(@IsDeletion = 0,(ISNULL(StoreSize,0) + @FilesSize),(StoreSize - @FilesSize))
														 WHERE Id = @StoreId
            
				END
                ELSE
            
                    RAISERROR (@HavePermission,11, 1)

            END
        END
    END TRY  
    BEGIN CATCH 
        
           THROW
    END CATCH
END
GO