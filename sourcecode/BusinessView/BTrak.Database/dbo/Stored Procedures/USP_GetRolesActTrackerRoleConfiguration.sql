-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRolesActTrackerRoleConfiguration]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRolesActTrackerRoleConfiguration]
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


	    select ATRC.Id ActTrackerRoleConfigId,
			  RoleId,
			  R.RoleName,
			  FrequencyIndex,
			  ActivityTrackerAppUrlTypeId AS AppUrlId,
			  ConsiderPunchCard,
	          ATAT.AppURL,
			  SelectAll
		 from [ActivityTrackerRoleConfiguration] ATRC JOIN [Role] R ON R.Id = ATRC.RoleId AND R.InactiveDateTime IS NULL 
						 AND ATRC.InActiveDateTime IS NULL AND R.InActiveDateTime IS NULL
				JOIN [ActivityTrackerAppUrlType] ATAT ON ATAT.Id = ATRC.ActivityTrackerAppUrlTypeId  
		WHERE @CompanyId= ATRC.ComapnyId
		 --ORDER BY RoleName ASC
		 ORDER BY FrequencyIndex ASC

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
GO