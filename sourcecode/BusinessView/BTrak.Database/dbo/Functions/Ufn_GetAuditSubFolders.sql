CREATE FUNCTION [dbo].[Ufn_GetAuditSubFolders]
(
	@AuditFolderId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
    WITH Tree AS
    (
        SELECT ACC_Parent.Id, ACC_Parent.ParentAuditFolderId, ACC_Parent.AuditFolderName, [level] = 1, Path = CAST('' AS NVARCHAR(MAX)),Path2 = CAST(CreatedDateTime AS varbinary(max))
        FROM AuditFolder ACC_Parent
        WHERE ACC_Parent.Id = @AuditFolderId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentAuditFolderId, TS_Child.AuditFolderName, [level] = Tree.[level] + 1, Path = Cast(Tree.Path+'/'+cast(Tree.AuditFolderName AS NVARCHAR(250)) AS NVARCHAR(MAX))
		,Path2 = Path2 + CAST(TS_Child.CreatedDateTime AS varbinary(max))
        FROM AuditFolder TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentAuditFolderId
        WHERE TS_Child.InActiveDateTime IS NULL 
    )
    SELECT Tree.Path, ACC.Id, Tree.ParentAuditFolderId,[level], REPLICATE('  ', Tree.level - 1) + Tree.AuditFolderName as AuditFolderName,ACC.[Description],ACC.[TimeStamp],ACC.InActiveDateTime,ACC.AuditFolderName AS OriginalName,ACC.CreatedDateTime,Path2
    FROM Tree INNER JOIN AuditFolder ACC ON ACC.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL  
)
GO
