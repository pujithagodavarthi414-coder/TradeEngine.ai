--SELECT * FROM [Ufn_GetEntitiesHierarchy]('127133F1-4427-4149-9DD6-B02E0E036971',NULL)
CREATE FUNCTION [dbo].[Ufn_GetEntitiesHierarchy]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@EntityId UNIQUEIDENTIFIER = NULL
)
RETURNS TABLE AS RETURN
WITH Entity_CTE 
AS 
(
	SELECT Id FROM Entity E
	WHERE (@EntityId IS NULL OR E.Id IN (@EntityId))
		  AND (@EmployeeId IS NULL OR E.Id IN (SELECT EntityId FROM EmployeeEntity WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId))
		  AND E.InactiveDateTime IS NULL
	UNION ALL
	SELECT EInner.Id 
	FROM Entity EInner
	INNER JOIN Entity_CTE EC ON EInner.ParentEntityId = EC.Id AND EInner.InactiveDateTime IS NULL
)
SELECT Id AS EntityId FROM Entity_CTE
GROUP BY Id
GO
