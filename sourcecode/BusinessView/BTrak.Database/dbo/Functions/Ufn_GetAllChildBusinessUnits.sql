--SELECT * FROM [dbo].[Ufn_GetAllChildBusinessUnits](NULL)
CREATE FUNCTION [dbo].[Ufn_GetAllChildBusinessUnits]
(
	@BusinessUnitId UNIQUEIDENTIFIER = NULL
	,@CompanyId UNIQUEIDENTIFIER = NULL
)
RETURNS TABLE AS
RETURN
(
  WITH Tree AS
			  (
			      SELECT B_Parent.Id AS BusinessUnitId
			      FROM BusinessUnit B_Parent
			      WHERE (@BusinessUnitId IS NULL OR B_Parent.Id = @BusinessUnitId) 
				        AND (@BusinessUnitId IS NOT NULL OR B_Parent.ParentBusinessUnitId IS NULL)
						AND B_Parent.CompanyId = @CompanyId
						 AND B_Parent.InActiveDateTime IS NULL
			      UNION ALL
			      SELECT B_Child.Id AS BusinessUnitId
			      FROM BusinessUnit B_Child INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
			      WHERE B_Child.InActiveDateTime IS NULL 
						AND B_Child.CompanyId = @CompanyId
			  )
		SELECT T.BusinessUnitId,BU.BusinessUnitName,BU.ParentBusinessUnitId
		FROM Tree T INNER JOIN BusinessUnit BU ON BU.Id = T.BusinessUnitId
)
GO