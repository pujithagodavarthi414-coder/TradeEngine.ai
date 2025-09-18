-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetCategoriesAndSubcategoriesByVersionId]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION [dbo].[Ufn_GetCategoriesAndSubcategoriesByVersionId]
(
    @CategoryId UNIQUEIDENTIFIER
    ,@AuditComplianceVersionId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
    WITH Tree AS
    (
        SELECT TS_Parent.Id, TS_Parent.ParentAuditCategoryId, TS_Parent.AuditCategoryName
               , [level] = 1, Path = CAST('' AS NVARCHAR(MAX))
               ,Path2 = CAST(CreatedDateTime AS VARBINARY(max))
        FROM AuditCategoryVersions TS_Parent
        WHERE TS_Parent.Id = @CategoryId 
              AND InActiveDateTime IS NULL 
              AND TS_Parent.AuditComplianceVersionId = @AuditComplianceVersionId
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentAuditCategoryId, TS_Child.AuditCategoryName, [level] = Tree.[level] + 1
        , Path = Cast(Tree.Path+'/'+cast(Tree.AuditCategoryName AS NVARCHAR(250)) AS NVARCHAR(MAX))
		,Path2 = Path2 + CAST(TS_Child.CreatedDateTime AS VARBINARY(max))
        FROM AuditCategoryVersions TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentAuditCategoryId
        WHERE TS_Child.InActiveDateTime IS NULL 
              AND TS_Child.AuditComplianceVersionId = @AuditComplianceVersionId
    )
    SELECT AC.Id, Tree.ParentAuditCategoryId
           , REPLICATE('  ', Tree.level - 1) + Tree.AuditCategoryName as CategoryName
           ,AC.AuditCategoryDescription AS CategoryDescription
           ,AC.AuditCategoryName AS OriginalName
           ,AC.AuditComplianceId,AC.CreatedDateTime,Path2
    FROM Tree INNER JOIN AuditCategoryVersions AC ON AC.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL AND AC.AuditComplianceVersionId = @AuditComplianceVersionId
)
GO
