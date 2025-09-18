----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-12-05 00:00:00.000'
-- Purpose      To Upsert Folder And Store Size By FolderId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertFolderAndStoreSizeByFolderId] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@FolderId = '17497D10-05C3-46AD-AB68-915446FA1F13'
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFolderAndStoreSizeByFolderId]
(
  @FolderId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
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
                        
                    CREATE TABLE #FolderIds(
                                            Id UNIQUEIDENTIFIER,
											Lvl INT
                                           )
                       
                    ;WITH Tree as
                    (
                     SELECT F.Id,1 AS Lvl
                     FROM Folder F
                     WHERE F.Id = @FolderId AND F.InActiveDateTime IS NULL
  
                     UNION ALL
  
                     SELECT F1.Id,T.Lvl + 1
                     FROM Folder F1
                     INNER JOIN Tree T
                     ON T.Id = F1.ParentFolderId AND F1.InActiveDateTime IS NULL
                     WHERE T.Id IS NOT NULL
                    )
                    
					INSERT INTO #FolderIds SELECT Id,Lvl FROM Tree
                    
					DECLARE @MaxLevel INT = (SELECT MAX(Lvl) FROM #FolderIds)
					
					DECLARE @OldSize BIGINT = (SELECT ISNULL(FolderSize,0) FROM Folder WHERE Id = @FolderId)

					WHILE(@MaxLevel > 0)
					BEGIN

					UPDATE Folder SET FolderSize = (SELECT SUM(T.Size) 
					                                       FROM (
																SELECT ISNULL(SUM(FolderSize),0) as Size from Folder where ParentFolderId = F.Id AND InActiveDateTime IS NULL
																UNION
																SELECT ISNULL(SUM(FileSize),0) as Size from UploadFile where FolderId = F.Id AND InActiveDateTime IS NULL) T) 
						   FROM Folder F JOIN #FolderIds FI ON FI.Id = F.Id AND FI.Lvl = @MaxLevel

					SET @MaxLevel = @MaxLevel - 1
					END
					
					DECLARE @NewSize BIGINT = (SELECT ISNULL(FolderSize,0) FROM Folder WHERE Id = @FolderId)
					
					CREATE TABLE #ParentFolder(
												FolderId UNIQUEIDENTIFIER,
					                          )

				    ;WITH ParentFolders as
                    (
                     SELECT F.Id,F.ParentFolderId
                     FROM Folder F
                     WHERE F.Id = @FolderId AND F.InActiveDateTime IS NULL
  
                     UNION ALL
  
                     SELECT F1.Id,F1.ParentFolderId
                     FROM Folder F1
                     INNER JOIN ParentFolders T
                     ON T.ParentFolderId = F1.Id AND F1.InActiveDateTime IS NULL
                     WHERE T.Id IS NOT NULL
                    )

					INSERT INTO #ParentFolder
					SELECT ParentFolderId FROM ParentFolders

					UPDATE Folder SET FolderSize = (ISNULL(FolderSize,0) + @NewSize - @OldSize) FROM Folder F JOIN #ParentFolder PF ON PF.FolderId = F.Id

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
