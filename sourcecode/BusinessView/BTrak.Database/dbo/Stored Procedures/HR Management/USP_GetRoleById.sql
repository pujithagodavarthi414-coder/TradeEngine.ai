-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the Role By Applying RoleId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetRoleById]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@RoleId='DE9B5D9A-B852-458C-BF76-06AAAA8E42DD'

CREATE PROCEDURE [dbo].[USP_GetRoleById]
(
  @RoleId UNIQUEIDENTIFIER = NULL, 
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

	     DECLARE @CompanyId UNIQUEIDENTIFIER  = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	     
	     IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL

	     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	          SELECT R.Id,
	  	  	         R.RoleName,
	  	  		     R.CompanyId,
	  	  		     R.CreatedDateTime, 
	  	  		     R.CreatedByUserId,
	  	  		     R.UpdatedDateTime,
	  	  		     R.UpdatedByUserId,
					 (SELECT (SELECT F.Id,F.FeatureName,F.IsActive 
					  FROM Feature AS F	WITH (NOLOCK)	
	  	  			       JOIN [RoleFeature] RF ON RF.FeatureId = F.Id WHERE RF.RoleId = @RoleId
                      FOR XML PATH('FeatureModel'), TYPE)FOR XML PATH('Features'), TYPE) AS Features
	  	             FROM  [dbo].[Role] AS R WITH (NOLOCK)	
	  	      WHERE (@RoleId IS NULL OR R.Id = @RoleId)  
	  	             AND (R.CompanyId = @CompanyId)

	 END

	 END TRY  
	 BEGIN CATCH 
		
		EXEC [dbo].[USP_GetErrorInformation]

	END CATCH
END
