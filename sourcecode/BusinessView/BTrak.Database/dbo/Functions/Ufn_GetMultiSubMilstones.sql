-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-30 00:00:00.000'
-- Purpose      To Get Milestones and SubMilestones
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetMultiSubMilstones]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION Ufn_GetMultiSubMilstones
(
    @MilestoneId UNIQUEIDENTIFIER
)
RETURNS table AS
RETURN
(
    WITH Tree AS
    (
        SELECT M_Parent.Id, M_Parent.ParentMilestoneId, M_Parent.[Title], [level] = 1, Path = CAST(M_Parent.Title AS NVARCHAR(MAX))
        FROM Milestone M_Parent
        WHERE M_Parent.Id = @MilestoneId AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT M_Child.Id, M_Child.ParentMilestoneId, M_Child.[Title], [level] = Tree.[level] + 1, Path = Cast(Tree.Path+'/'+cast(M_Child.Title AS NVARCHAR(250)) AS NVARCHAR(MAX))
        FROM Milestone M_Child INNER JOIN Tree ON Tree.Id = M_Child.ParentMilestoneId
        WHERE M_Child.InActiveDateTime IS NULL 
    )
    SELECT Tree.Path, M.Id, Tree.ParentMilestoneId, REPLICATE('  ', Tree.level - 1) + Tree.[Title] as Tittle
    FROM Tree INNER JOIN Milestone M ON M.Id = Tree.Id 
    WHERE InActiveDateTime IS NULL 
)
GO