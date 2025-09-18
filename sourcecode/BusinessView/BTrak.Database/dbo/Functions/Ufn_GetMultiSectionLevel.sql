CREATE FUNCTION Ufn_GetMultiSectionLevel
(
    @SectionId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
  WITH Tree AS
    (
        SELECT TS_Parent.Id, TS_Parent.ParentSectionId,  [level] = 0
        FROM TestSuiteSection TS_Parent
        WHERE TS_Parent.Id = @SectionId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentSectionId, [level] = Tree.[level] + 1
        FROM TestSuiteSection TS_Child INNER JOIN Tree ON Tree.ParentSectionId = TS_Child.Id
        WHERE TS_Child.InActiveDateTime IS NULL 
    )
    SELECT  [level],Tree.Id AS SectionId
    FROM Tree INNER JOIN TestSuiteSection TSS ON TSS.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL  --AND Tree.ParentSectionId IS NULL
)
GO