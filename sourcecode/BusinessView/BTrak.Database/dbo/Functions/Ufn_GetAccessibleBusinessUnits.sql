CREATE FUNCTION [dbo].[Ufn_GetAccessibleBusinessUnits]
(
   @UserId UNIQUEIDENTIFIER = NULL, 
   @CompanyId UNIQUEIDENTIFIER,
   @BusinessUnitIds NVARCHAR(MAX) = NULL
)
RETURNS @BusinessUnit TABLE
(
	BusinessUnitId UNIQUEIDENTIFIER
	,BusinessUnitName NVARCHAR(250)
)
BEGIN

	DECLARE @BusinessUnits TABLE(
		BusinessUnitId UNIQUEIDENTIFIER
	)

	IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL
 
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
			 			  AND (BUEC.ActiveFrom IS NOT NULL AND BUEC.ActiveFrom <= GETDATE() 
			 			        AND (BUEC.ActiveTo IS NULL OR BUEC.ActiveTo >= GETDATE()))
						  AND BUEC.EmployeeId = (SELECT Id FROM Employee WHERE UserId = @UserId AND InActiveDateTime IS NULL)
			     WHERE B_Parent.InActiveDateTime IS NULL 
			 		AND B_Parent.CompanyId = @CompanyId
					--AND (@BusinessUnitIds IS NULL OR @BusinessUnitIds = ''
					--      OR B_Parent.Id IN (SELECT CAST(Id AS UNIQUEIDENTIFIER) FROM UfnSplit(@BusinessUnitIds)))
			 		--AND B_Parent.ParentBusinessUnitId IS NULL
			     UNION ALL
			     SELECT B_Child.Id AS BusinessUnitId
			     FROM BusinessUnit B_Child 
				      INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
			     WHERE B_Child.InActiveDateTime IS NULL 
			 		AND B_Child.CompanyId = @CompanyId
			 )
			 INSERT INTO @BusinessUnit
			 SELECT  T.BusinessUnitId
			         ,B.BusinessUnitName
			 	 FROM Tree T
				  LEFT JOIN @BusinessUnits BU ON BU.BusinessUnitId = T.BusinessUnitId
			      INNER JOIN BusinessUnit B ON B.Id = T.BusinessUnitId AND B.InActiveDateTime IS NULL
			 		      AND B.CompanyId = @CompanyId
			WHERE (@BusinessUnitIds IS NULL OR BU.BusinessUnitId IS NOT NULL)
			GROUP BY T.BusinessUnitId,B.BusinessUnitName

RETURN
END
GO