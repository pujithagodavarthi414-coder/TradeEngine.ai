CREATE PROCEDURE [dbo].[USP_EnsureUserCanHaveAccess]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
	BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @UserId)
        DECLARE @Value BIT = 0
		
		IF(not exists(SELECT CM.ModuleId FROM CompanyModule CM INNER JOIN FeatureModule FM ON FM.ModuleId = CM.ModuleId AND CM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL WHERE FM.FeatureId = @FeatureId AND CM.CompanyId = @CompanyId) )
			SET @Value = 0
		ELSE 
		BEGIN

		    WHILE @@FETCH_STATUS = 0 
            BEGIN
       	    
       	     SELECT @Value =  CASE WHEN not exists(SELECT Id FROM RoleFeature WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId)) AND FeatureId = @FeatureId)  THEN 0 ELSE 1 END
       	    
              IF (@Value = 0) 
       	    		BREAK
		    
       	      ELSE
       	      BEGIN
       	    	
       	    	SET @FeatureId = (SELECT ParentFeatureId FROM Feature WHERE Id = @FeatureId)
       	    
       	    	IF(@FeatureId IS NULL)
       	    	BEGIN
       	    		
       	    		SET @Value = 1
       	    		BREAK
       	    
       	    	END
		    
       	      END
		       
		    END

	  END

	  SELECT @Value

	END TRY
	BEGIN CATCH
		
		EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO
