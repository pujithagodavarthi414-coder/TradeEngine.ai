CREATE FUNCTION [Ufn_GetMultiCategoryLevel]
(
    @CategoryId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
  WITH Tree AS
    (
        SELECT ACC_Parent.Id, ACC_Parent.ParentAuditCategoryId,[level] = 0
        FROM AuditCategory ACC_Parent
        WHERE ACC_Parent.Id = @CategoryId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT ACC_Child.Id, ACC_Child.ParentAuditCategoryId, [level] = Tree.[level] + 1
        FROM AuditCategory ACC_Child INNER JOIN Tree ON Tree.ParentAuditCategoryId = ACC_Child.Id
        WHERE ACC_Child.InActiveDateTime IS NULL 
    )
    SELECT  [level],Tree.Id AS AuditCategoryId
    FROM Tree INNER JOIN AuditCategory ACC ON ACC.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL  --AND Tree.ParentSectionId IS NULL
)
GO
