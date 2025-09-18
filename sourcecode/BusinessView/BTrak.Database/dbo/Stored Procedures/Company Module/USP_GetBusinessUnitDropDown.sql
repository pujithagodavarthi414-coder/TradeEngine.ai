CREATE PROCEDURE [dbo].[USP_GetBusinessUnitDropDown]
(
	@BusinessUnitId UNIQUEIDENTIFIER = NULL
	,@BusinessUnitName NVARCHAR(250) = NULL
	,@IsFromHR BIT = NULL
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
			
			IF(@IsFromHR IS NULL) SET @IsFromHR = 0
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @AddOrEditFeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                                 FROM CompanyModule CM 
                                                                      INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                                      INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '83D2EE67-0359-44DF-A1D3-9B9CE3F4F4EC' --Ability to chat
                                                                                 AND CM.CompanyId = @CompanyId
                                                                 GROUP BY FeatureId)
			
		   DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)

           DECLARE @HaveFeaturePermission INT = (SELECT COUNT(1)
												 FROM RoleFeature 
												 WHERE RoleId IN (SELECT RoleId FROM UserRole WHERE UserId = @OperationsPerformedBy)
												       AND FeatureId = @AddOrEditFeatureId
												 	   AND InActiveDateTime IS NULL
												 )

			;WITH Tree AS
			  (
			      SELECT B_Parent.Id AS BusinessUnitId
			      FROM BusinessUnit B_Parent
				       LEFT JOIN BusinessUnitEmployeeConfiguration BUEC ON BUEC.BusinessUnitId = B_Parent.Id
							  AND (BUEC.ActiveFrom IS NOT NULL AND BUEC.ActiveFrom <= GETDATE() 
							        AND (BUEC.ActiveTo IS NULL OR BUEC.ActiveTo >= GETDATE()))
							  AND BUEC.EmployeeId = @EmployeeId
			      WHERE ((@IsFromHR = 1 AND (@HaveFeaturePermission > 0 OR BUEC.Id IS NOT NULL)) 
				          OR (@IsFromHR = 0 AND BUEC.Id IS NOT NULL))
				        AND (@BusinessUnitId IS NULL OR B_Parent.Id = @BusinessUnitId) 
			            AND (@BusinessUnitName IS NULL OR B_Parent.[BusinessUnitName] = @BusinessUnitName) 
				        AND B_Parent.InActiveDateTime IS NULL 
						AND B_Parent.CompanyId = @CompanyId
						--AND B_Parent.ParentBusinessUnitId IS NULL
			      UNION ALL
			      SELECT B_Child.Id AS BusinessUnitId
			      FROM BusinessUnit B_Child INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
			      WHERE B_Child.InActiveDateTime IS NULL 
						AND B_Child.CompanyId = @CompanyId
			  )
			  SELECT  T.BusinessUnitId
			          ,B.BusinessUnitName
					  ,B.[ParentBusinessUnitId]
					 FROM Tree T
			       INNER JOIN BusinessUnit B ON B.Id = T.BusinessUnitId AND B.InActiveDateTime IS NULL
						      AND B.CompanyId = @CompanyId
			GROUP BY T.BusinessUnitId,B.BusinessUnitName,B.[ParentBusinessUnitId]

		 END
		 ELSE
		 	RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO