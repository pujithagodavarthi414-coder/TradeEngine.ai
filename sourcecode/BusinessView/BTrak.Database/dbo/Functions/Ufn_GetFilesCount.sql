 CREATE FUNCTION Ufn_GetFilesCount
(
	@ProjectId UNIQUEIDENTIFIER
)
RETURNS INT
AS 
BEGIN

  DECLARE @Count INT

  ;WITH Tree AS
    (
        SELECT P_Parent.Id, P_Parent.ParentFolderId
        FROM Folder P_Parent
        WHERE (P_Parent.Id = @ProjectId OR P_Parent.FolderReferenceId = @ProjectId) AND P_Parent.InActiveDateTime IS NULL
        UNION ALL
        SELECT P_Child.Id, P_Child.ParentFolderId
        FROM Folder P_Child INNER JOIN Tree ON Tree.Id = P_Child.ParentFolderId
        WHERE P_Child.InActiveDateTime IS NULL 
    )
    SELECT  @Count = COUNT(1) FROM UploadFile WHERE FolderId IN (SELECT Id FROM Tree) AND InActiveDateTime IS NULL

RETURN @Count

END
GO