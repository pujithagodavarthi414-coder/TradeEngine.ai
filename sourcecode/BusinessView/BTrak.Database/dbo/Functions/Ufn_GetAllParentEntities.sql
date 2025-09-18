--TODO
CREATE FUNCTION [dbo].[Ufn_GetAllParentEntities]
(
	@EntityId UNIQUEIDENTIFIER = NULL
)
RETURNS TABLE AS
RETURN
(
  WITH Tree AS
    (
        SELECT E_Parent.Id,E_Parent.ParentEntityId AS EntityId
        FROM Entity E_Parent
        WHERE (E_Parent.Id = @EntityId) AND InActiveDateTime IS NULL 
        UNION ALL
        SELECT E_Child.Id, E_Child.ParentEntityId AS EntityChildId
        FROM Entity E_Child 
		INNER JOIN Tree ON Tree.EntityId = E_Child.Id
        WHERE E_Child.InActiveDateTime IS NULL
    )
	SELECT T.EntityId,E.EntityName
    FROM Tree T
	     INNER JOIN Entity E ON E.Id = T.EntityId
)
GO