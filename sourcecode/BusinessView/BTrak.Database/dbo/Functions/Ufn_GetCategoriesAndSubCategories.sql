-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Categories And SubCategories upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_CategoriesAndSubcategories]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION Ufn_GetCategoriesAndSubcategories
(
    @CategoryId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
    WITH Tree AS
    (
        SELECT TS_Parent.Id, TS_Parent.ParentAuditCategoryId, TS_Parent.AuditCategoryName, [level] = 1, Path = CAST('' AS NVARCHAR(MAX)),Path2 = CAST(CreatedDateTime AS varbinary(max))
        FROM AuditCategory TS_Parent
        WHERE TS_Parent.Id = @CategoryId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentAuditCategoryId, TS_Child.AuditCategoryName, [level] = Tree.[level] + 1, Path = Cast(Tree.Path+'/'+cast(Tree.AuditCategoryName AS NVARCHAR(250)) AS NVARCHAR(MAX))
		,Path2 = Path2 + CAST(TS_Child.CreatedDateTime AS varbinary(max))
        FROM AuditCategory TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentAuditCategoryId
        WHERE TS_Child.InActiveDateTime IS NULL 
    )
    SELECT Tree.Path, AC.Id, Tree.ParentAuditCategoryId,[level], REPLICATE('  ', Tree.level - 1) + Tree.AuditCategoryName as CategoryName,AC.AuditCategoryDescription AS CategoryDescription,AC.[TimeStamp],AC.InActiveDateTime,AC.AuditCategoryName AS OriginalName,AC.AuditComplianceId,AC.CreatedDateTime,Path2
    FROM Tree INNER JOIN AuditCategory AC ON AC.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL  
)
GO