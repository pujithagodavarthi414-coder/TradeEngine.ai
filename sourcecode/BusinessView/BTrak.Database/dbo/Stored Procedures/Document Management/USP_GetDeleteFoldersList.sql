--CREATE PROCEDURE [dbo].[USP_GetDeleteFoldersList]
--	@FolderId UNIQUEIDENTIFIER = NULL
--AS
--BEGIN
--    SET NOCOUNT ON
--    BEGIN TRY
--       ;WITH Tree as
--                        (
--                         SELECT F.Id AS FolderId
--                         FROM Folder F
--                         WHERE F.Id = @FolderId AND F.InActiveDateTime IS NULL
  
--                         UNION ALL
  
--                         SELECT F1.Id AS FolderId
--                         FROM Folder F1
--                         INNER JOIN Tree T
--                         ON T.Id = F1.ParentFolderId AND F1.InActiveDateTime IS NULL
--                         WHERE T.Id IS NOT NULL
--                        )
--                    SELECT * FROM Tree
--      END TRY
--   BEGIN CATCH
       
--       THROW

--   END CATCH
--END
--GO