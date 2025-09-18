CREATE PROCEDURE [dbo].[USP_GetRolesActTrackerScreenShotFrequencyUsers]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
	 IF (@HavePermission = '1')
	 BEGIN

	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL


	     select DISTINCT--ATSF.Id ActTrackerToleConfigId,
				UserId,
				ScreenShotFrequency,
				FrequencyIndex,
				Multiplier,
				SelectAll AS IsUserSelectAll
		 from [ActivityTrackerScreenShotFrequencyUser] ATSF JOIN [User] R ON R.Id = ATSF.UserId AND R.InactiveDateTime IS NULL
							 AND ATSF.InActiveDateTime IS NULL AND R.InActiveDateTime IS NULL
		 WHERE @CompanyId = ATSF.ComapnyId 
		 --ORDER BY RoleName

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END