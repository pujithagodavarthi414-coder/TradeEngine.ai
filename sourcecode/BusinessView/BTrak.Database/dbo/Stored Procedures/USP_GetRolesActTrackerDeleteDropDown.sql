-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRolesActTrackerDeleteDropDown]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRolesActTrackerDeleteDropDown]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
	 IF (@HavePermission = '1')
	 BEGIN

	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL


	      SELECT R.Id RoleId,
				 R.RoleName
		  FROM  [dbo].[Role] AS R WITH (NOLOCK)
		  WHERE R.InactiveDateTime IS NULL
		        AND (R.CompanyId = @CompanyId)
				AND (R.IsHidden IS NULL OR R.IsHidden = 0)
				AND R.Id NOT IN (SELECT RoleId FROM ActivityTrackerRolePermission WHERE InActiveDateTime IS NULL)
		  ORDER BY RoleName ASC 

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END