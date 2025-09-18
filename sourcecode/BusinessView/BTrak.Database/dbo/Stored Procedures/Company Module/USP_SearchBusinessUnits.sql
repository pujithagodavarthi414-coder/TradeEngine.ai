CREATE PROCEDURE [dbo].[USP_SearchBusinessUnits]
(
	@BusinessUnitId UNIQUEIDENTIFIER = NULL
	,@BusinessUnitName NVARCHAR(250) = NULL
	,@ParentBusinessUnitId UNIQUEIDENTIFIER = NULL
	,@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		 DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,OBJECT_NAME(@@PROCID)))

		 IF(@HavePermission = '1')
		 BEGIN
			
			IF(@BusinessUnitId = '00000000-0000-0000-0000-000000000000') SET @BusinessUnitId = NULL

			IF(@ParentBusinessUnitId = '00000000-0000-0000-0000-000000000000') SET @ParentBusinessUnitId = NULL

			IF(@BusinessUnitName = '') SET @BusinessUnitName = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			;WITH Tree AS
			  (
			      SELECT B_Parent.Id AS BusinessUnitId
			      FROM BusinessUnit B_Parent
			      WHERE (@BusinessUnitId IS NULL OR B_Parent.Id = @BusinessUnitId) 
			            AND (@BusinessUnitName IS NULL OR B_Parent.[BusinessUnitName] = @BusinessUnitName) 
			            AND (@ParentBusinessUnitId IS NULL OR B_Parent.[ParentBusinessUnitId] = @ParentBusinessUnitId) 
				        AND B_Parent.InActiveDateTime IS NULL 
						AND B_Parent.CompanyId = @CompanyId
						AND B_Parent.ParentBusinessUnitId IS NULL
			      UNION ALL
			      SELECT B_Child.Id AS BusinessUnitId
			      FROM BusinessUnit B_Child INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
			      WHERE B_Child.InActiveDateTime IS NULL 
						AND B_Child.CompanyId = @CompanyId
			  )
			  SELECT  T.BusinessUnitId
			          ,B.BusinessUnitName
					  ,B.[ParentBusinessUnitId]
					  ,B.[TimeStamp]
					  ,(SELECT EB.EmployeeId AS EmployeeId 
					    FROM EmployeeBusinessUnit EB  
						WHERE EB.BusinessUnitId = T.BusinessUnitId 
							  AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE()))
						      FOR JSON PATH) AS EmployeeIdsJson
					  ,STUFF((SELECT ', ' + U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName
					    FROM Employee E
							 INNER JOIN [User] U ON U.Id = E.UserId
							 INNER JOIN EmployeeBusinessUnit EB ON EB.EmployeeId = E.Id
							 AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE()))
						WHERE EB.BusinessUnitId = T.BusinessUnitId
						      AND E.InActiveDateTime IS NULL FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,'') AS EmployeeNames
					  ,CASE WHEN EXISTS(SELECT 1 FROM BusinessUnit WHERE InActiveDateTime IS NULL AND ParentBusinessUnitId = T.BusinessUnitId) THEN 0 ELSE 1 END AS CanAddEmployee
			  FROM Tree T
			       INNER JOIN BusinessUnit B ON B.Id = T.BusinessUnitId AND B.InActiveDateTime IS NULL
						      AND B.CompanyId = @CompanyId
								
		 END
		 ELSE
		 	RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO