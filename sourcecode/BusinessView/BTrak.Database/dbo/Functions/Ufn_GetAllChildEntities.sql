--SELECT * FROM [dbo].[Ufn_GetAllChildEntities](NULL,0)
CREATE FUNCTION [dbo].[Ufn_GetAllChildEntities]
(
	@EntityId UNIQUEIDENTIFIER = NULL
    ,@IsIncludeArchive BIT = 0
)
RETURNS TABLE AS
RETURN
(
  WITH Tree AS
    (
        SELECT E_Parent.Id AS EntityId
        FROM Entity E_Parent
        WHERE (@EntityId IS NULL OR E_Parent.Id = @EntityId) 
              AND (@IsIncludeArchive = 1 OR E_Parent.InActiveDateTime IS NULL) 
        UNION ALL
        SELECT E_Child.Id AS EntityChildId
        FROM Entity E_Child INNER JOIN Tree ON Tree.EntityId = E_Child.ParentEntityId
        WHERE (@IsIncludeArchive = 1 OR E_Child.InActiveDateTime IS NULL)
    )
    SELECT  T.EntityId,E.EntityName,E.[IsBranch]
	       ,COUNT(IIF(E.[IsGroup] = 1,1,NULL)) OVER() AS GroupsCount
	       ,COUNT(IIF(E.[IsEntity] = 1,1,NULL)) OVER() AS EntitiesCount
	       ,COUNT(IIF(E.[IsCountry] = 1,1,NULL)) OVER() AS CountriesCount
	       ,COUNT(IIF(E.[IsBranch] = 1,1,NULL)) OVER() AS BranchesCount
		   ,COUNT(1) OVER() TotalCount
    FROM Tree T
	     INNER JOIN Entity E ON E.Id = T.EntityId
)
GO