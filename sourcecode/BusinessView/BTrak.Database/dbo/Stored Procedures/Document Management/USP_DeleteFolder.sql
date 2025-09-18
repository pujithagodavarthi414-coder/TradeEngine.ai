----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-12-05 00:00:00.000'
-- Purpose      To Delete Folder
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_DeleteFolder] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@FolderId = '256D773B-ABCD-4315-A7EF-C4A30F0AE093',@TimeStamp = 0x0000000000003A7F
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteFolder]
(
  @FolderId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL,
  @IsToReturn BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
        IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL
        
        IF(@FolderId IS NULL)
        
        BEGIN
                         
            RAISERROR(50011,16, 2, 'FolderId')
          
        END
        ELSE
        BEGIN
            DECLARE @FolderIdCount INT = (SELECT COUNT(1) FROM [Folder] WHERE Id = @FolderId AND InActiveDateTime IS NULL)
            
            IF(@FolderIdCount = 0 AND @FolderId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'FolderId')
            
            END
            ELSE
            BEGIN
                DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
                IF (@HavePermission = '1')
                BEGIN
                
                    DECLARE @Currentdate DATETIME = GETDATE()
                        
                    DECLARE @IsLatest BIT = 1--(CASE WHEN (SELECT F.[TimeStamp] FROM Folder F INNER JOIN Store S ON F.StoreId = S.Id  WHERE F.Id = @FolderId AND S.CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END)
                    
                    CREATE TABLE #FolderIds(
                                            Id UNIQUEIDENTIFIER
                                           )
                       
                    IF(@IsLatest = 1)
                    BEGIN                                                 
                     
                        ;WITH Tree as
                        (
                         SELECT F.Id
                         FROM Folder F
                         WHERE F.Id = @FolderId AND F.InActiveDateTime IS NULL
  
                         UNION ALL
  
                         SELECT F1.Id
                         FROM Folder F1
                         INNER JOIN Tree T
                         ON T.Id = F1.ParentFolderId AND F1.InActiveDateTime IS NULL
                         WHERE T.Id IS NOT NULL
                        )
                       
                        INSERT INTO #FolderIds SELECT Id FROM Tree
                        UPDATE [dbo].[Folder] SET   [InActiveDateTime] = @Currentdate,
                                                    [UpdatedDateTime]  = @Currentdate,
                                                    [UpdatedByUserId]  = @OperationsPerformedBy 
                                                    WHERE Id IN (SELECT Id FROM #FolderIds)
                         
                        UPDATE [dbo].[UploadFile] SET  [InActiveDateTime] = @Currentdate,
                                                       [UpdatedDateTime]  = @Currentdate,
                                                       [UpdatedByUserId]  = @OperationsPerformedBy 
                                                       WHERE FolderId IN (SELECT Id FROM #FolderIds)
                               
                        IF (@IsToReturn IS NULL OR @IsToReturn = 0)
                        BEGIN
                            SELECT Id AS FolderId,StoreId,FolderSize FROM [dbo].[Folder] where Id = @FolderId
                        END
						ELSE
						BEGIN

							DECLARE @StoreId UNIQUEIDENTIFIER, @FileSize BIGINT

							SELECT @FileSize = FolderSize,@StoreId = StoreId FROM [dbo].[Folder] where Id = @FolderId

                            EXEC [USP_UpsertFolderAndStoreSize] @FolderId = @FolderId
							                                   ,@StoreId = @StoreId
															   ,@FilesSize = @FileSize
															   ,@IsDeletion = 1
															   ,@OperationsPerformedBy = @OperationsPerformedBy
                        END
            
                    END
                    ELSE 
            
                        RAISERROR (50015,11, 1)
            
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