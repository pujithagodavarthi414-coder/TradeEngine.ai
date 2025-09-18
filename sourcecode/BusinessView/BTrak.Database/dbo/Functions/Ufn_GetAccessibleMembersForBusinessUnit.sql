--IF OBJECT_ID('Ufn_GetAccessibleMembersForBusinessUnit') IS NOT NULL
--DROP FUNCTION Ufn_GetAccessibleMembersForBusinessUnit
--GO

CREATE FUNCTION [dbo].[Ufn_GetAccessibleMembersForBusinessUnit]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL
	,@BusinessUnitIds NVARCHAR(MAX) = NULL
	,@CompanyId UNIQUEIDENTIFIER = NULL
)
RETURNS @BusinessUnit TABLE
(
	BusinessUnitId UNIQUEIDENTIFIER
	,EmployeeId UNIQUEIDENTIFIER
)
BEGIN

	IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL

	DECLARE @BusinessUnits TABLE(
	BusinessUnitId UNIQUEIDENTIFIER
	)


IF(@BusinessUnitIds IS NOT NULL)
 BEGIN

  ;WITH Tree AS
  		  (
  		      SELECT B_Parent.Id AS BusinessUnitId
  		      FROM BusinessUnit B_Parent
  			     --  INNER JOIN BusinessUnitEmployeeConfiguration BUEC ON BUEC.BusinessUnitId = B_Parent.Id
  						  --AND (BUEC.ActiveFrom < GETDATE() AND (BUEC.ActiveTo IS NULL OR BUEC.ActiveTo > GETDATE()))
  						  --AND BUEC.EmployeeId = @EmployeeId
  		      WHERE B_Parent.CompanyId = @CompanyId
  					 AND B_Parent.InActiveDateTime IS NULL
  					 AND (@BusinessUnitIds IS NULL OR B_Parent.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@BusinessUnitIds)))
  		      UNION ALL
  		      SELECT B_Child.Id AS BusinessUnitId
  		      FROM BusinessUnit B_Child INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
  		      WHERE B_Child.InActiveDateTime IS NULL 
  					AND B_Child.CompanyId = @CompanyId
  		  )
	INSERT INTO @BusinessUnits
	SELECT T.BusinessUnitId --,EBU.EmployeeId --,BU.BusinessUnitName,BU.ParentBusinessUnitId
  	FROM Tree T 
  	
 END
	
  ;WITH Tree AS
			  (
			      SELECT B_Parent.Id AS BusinessUnitId
			      FROM BusinessUnit B_Parent
				       INNER JOIN BusinessUnitEmployeeConfiguration BUEC ON BUEC.BusinessUnitId = B_Parent.Id
							  AND (BUEC.ActiveFrom < GETDATE() AND (BUEC.ActiveTo IS NULL OR BUEC.ActiveTo > GETDATE()))
							  AND BUEC.EmployeeId = @EmployeeId
			      WHERE B_Parent.CompanyId = @CompanyId
						 AND B_Parent.InActiveDateTime IS NULL
						 --AND (@BusinessUnitIds IS NULL OR B_Parent.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@BusinessUnitIds)))
			      UNION ALL
			      SELECT B_Child.Id AS BusinessUnitId
			      FROM BusinessUnit B_Child INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
			      WHERE B_Child.InActiveDateTime IS NULL 
						AND B_Child.CompanyId = @CompanyId
			  )
		INSERT INTO @BusinessUnit
		SELECT T.BusinessUnitId,EBU.EmployeeId --,BU.BusinessUnitName,BU.ParentBusinessUnitId
		FROM Tree T 
		      LEFT JOIN @BusinessUnits BU ON BU.BusinessUnitId = T.BusinessUnitId
		      INNER JOIN EmployeeBusinessUnit EBU ON EBU.BusinessUnitId = T.BusinessUnitId
						 AND (EBU.ActiveFrom <= GETDATE() AND (EBU.ActiveTo IS NULL OR EBU.ActiveTo >= GETDATE()))
			WHERE (@BusinessUnitIds IS NULL OR BU.BusinessUnitId IS NOT NULL)

RETURN
END
GO