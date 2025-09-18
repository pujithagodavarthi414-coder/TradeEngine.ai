-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Sections And Subsections upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetMultiSubSections]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION Ufn_GetMultiSubSections
(
    @SectionId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
    WITH Tree AS
    (
        SELECT TS_Parent.Id, TS_Parent.ParentSectionId, TS_Parent.[SectionName], [level] = 1, Path = CAST('' AS NVARCHAR(MAX)),Path2 = CAST(CreatedDateTime AS varbinary(max))
        FROM TestSuiteSection TS_Parent
        WHERE TS_Parent.Id = @SectionId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentSectionId, TS_Child.[SectionName], [level] = Tree.[level] + 1, Path = Cast(Tree.Path+'/'+cast(Tree.SectionName AS NVARCHAR(250)) AS NVARCHAR(MAX))
		,Path2 = Path2 + CAST(TS_Child.CreatedDateTime AS varbinary(max))
        FROM TestSuiteSection TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentSectionId
        WHERE TS_Child.InActiveDateTime IS NULL 
    )
    SELECT Tree.Path, TSS.Id, Tree.ParentSectionId,[level], REPLICATE('  ', Tree.level - 1) + Tree.[SectionName] as SectionName,TSS.[Description],TSS.[TimeStamp],TSS.InActiveDateTime,TSS.SectionName AS OriginalName,TSS.TestSuiteId,TSS.CreatedDateTime,Path2
    FROM Tree INNER JOIN TestSuiteSection TSS ON TSS.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL  
)
GO