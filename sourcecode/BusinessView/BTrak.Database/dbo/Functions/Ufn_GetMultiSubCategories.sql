
-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Categories And Subcategories upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetMultiSubCategories]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION Ufn_GetMultiSubCategories
(
    @AuditCategoryId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
    WITH Tree AS
    (
        SELECT ACC_Parent.Id, ACC_Parent.ParentAuditCategoryId, ACC_Parent.AuditCategoryName, [level] = 1, Path = CAST('' AS NVARCHAR(MAX)),Path2 = CAST(CreatedDateTime AS varbinary(max))
        FROM AuditCategory ACC_Parent
        WHERE ACC_Parent.Id = @AuditCategoryId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentAuditCategoryId, TS_Child.AuditCategoryName, [level] = Tree.[level] + 1, Path = Cast(Tree.Path+'/'+cast(Tree.AuditCategoryName AS NVARCHAR(250)) AS NVARCHAR(MAX))
		,Path2 = Path2 + CAST(TS_Child.CreatedDateTime AS varbinary(max))
        FROM AuditCategory TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentAuditCategoryId
        WHERE TS_Child.InActiveDateTime IS NULL 
    )
    SELECT Tree.Path, ACC.Id, Tree.ParentAuditCategoryId,[level], REPLICATE('  ', Tree.level - 1) + Tree.AuditCategoryName as AuditCategoryName,ACC.[AuditCategoryDescription],ACC.[TimeStamp],ACC.InActiveDateTime,ACC.AuditCategoryName AS OriginalName,ACC.AuditComplianceId,ACC.CreatedDateTime,Path2
    FROM Tree INNER JOIN AuditCategory ACC ON ACC.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL  
)
GO
