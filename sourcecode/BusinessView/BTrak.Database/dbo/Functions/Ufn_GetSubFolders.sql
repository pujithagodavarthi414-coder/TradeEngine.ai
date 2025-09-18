CREATE FUNCTION Ufn_GetSubFolders
(
	@FolderId UNIQUEIDENTIFIER
)
RETURNS TABLE AS
RETURN


       WITH Tree as
       (
        SELECT P.ParentFolderId,P.FolderName,P.Id ,1 AS lvl
        FROM Folder P
        WHERE P.Id = @FolderId AND InActiveDateTime IS NULL
        
        UNION ALL
        
        SELECT P1.ParentFolderId,P1.FolderName,P1.Id,lvl + 1
        FROM Folder P1  
        INNER JOIN Tree M
        ON M.Id = P1.ParentFolderId
        WHERE M.ParentFolderId IS NOT NULL AND InActiveDateTime IS NULL
       )
	   SELECT * FROM Tree
