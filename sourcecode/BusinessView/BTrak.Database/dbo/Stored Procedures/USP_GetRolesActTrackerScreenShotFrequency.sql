-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRolesActTrackerScreenShotFrequency]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRolesActTrackerScreenShotFrequency]
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


	     select DISTINCT--ATSF.Id ActTrackerToleConfigId,
				RoleId,
				R.RoleName,
				ScreenShotFrequency,
				FrequencyIndex,
				Multiplier,
				SelectAll,
				RandomScreenshot
		 from [ActivityTrackerScreenShotFrequency] ATSF JOIN [Role] R ON R.Id = ATSF.RoleId AND R.InactiveDateTime IS NULL
							 AND ATSF.InActiveDateTime IS NULL AND R.InActiveDateTime IS NULL
		 WHERE @CompanyId = ATSF.ComapnyId 
		 ORDER BY FrequencyIndex ASC

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END