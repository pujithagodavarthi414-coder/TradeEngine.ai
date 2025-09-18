--EXEC [dbo].[GetActTrackerRolePermissionRoles] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@IsRecordActivity = 1
CREATE PROCEDURE [dbo].[USP_GetActTrackerRolePermissionRoles](
@IsDeletedScreenShots BIT = NULL,
@IsRecordActivity BIT = NULL,
@IsIdleTime BIT = NULL,
@IsManualEntry BIT = NULL,
@IsOffileTracking BIT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
 SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
		   SELECT 	R.Id RoleId,
					R.RoleName,
					A.IsDeleteScreenShots,
					A.IsRecordActivity,
					A.IsIdleTime,
					A.IdleAlertTime  ,
					A.IdleScreenShotCaptureTime,
					A.IsManualEntryTime,
					A.MinimumIdelTime,
					A.IsOfflineTracking,
					A.IsMouseTracking
				  FROM ActivityTrackerRolePermission A
				  JOIN [Role] R ON A.RoleId = R.Id AND A.InActiveDateTime IS NULL 
				  WHERE @CompanyId=R.CompanyId 
				      
				  ORDER BY R.RoleName	  
			
		 END
	    ELSE
	    BEGIN
	    
	    	RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
  
       THROW

   END CATCH 
END
