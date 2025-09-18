-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Sections And Subsections upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT [dbo].[Ufn_GetSectionsCountBySuiteId]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION Ufn_GetSectionsCountBySuiteId
(
	@TestSuiteId UNIQUEIDENTIFIER
)
RETURNS INT
AS 
BEGIN

  DECLARE @Count INT

 ;WITH Tree AS
    (
        SELECT TS_Parent.Id, TS_Parent.ParentSectionId
        FROM TestSuiteSection TS_Parent
        WHERE TS_Parent.Id IN (SELECT Id FROM TestSuiteSection WHERE TestSuiteId = @TestSuiteId AND InActiveDateTime IS NULL
        )AND InActiveDateTime IS NULL AND TS_Parent.ParentSectionId IS NULL
        UNION ALL
        SELECT TS_Child.Id, TS_Child.ParentSectionId
        FROM TestSuiteSection TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentSectionId
        WHERE TS_Child.InActiveDateTime IS NULL 
    )
    SELECT @Count = COUNT(TSS.Id)
    FROM Tree INNER JOIN TestSuiteSection TSS ON TSS.Id = Tree.Id WHERE  TSS.InActiveDateTime IS NULL

RETURN @Count

END
GO