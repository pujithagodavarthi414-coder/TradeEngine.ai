---------------------------------------------------------------------------
-- Author       Vikkiendhar Reddy BasireddyGari
-- Created      '2021-01-20'
-- Purpose      To get configured user integrations
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetUserProjectIntegration] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @TypeId = 'F56EB369-3719-4A68-85F8-22CE255B7399' 

CREATE PROCEDURE [dbo].[USP_GetUserProjectIntegration]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TypeId UNIQUEIDENTIFIER
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

		   SELECT 
		    I.TypeName AS IntegrationType,
			ULI.IntegrationUrl,
			ULI.UserName,
			ULI.ApiToken AS Password
			FROM [UserLevelIntegrations] ULI
			INNER JOIN [Integrations] I ON ULI.IntegrationTypeId = I.Id 
					AND I.InactiveDateTime Is NULL 
					AND ULI.InactiveDateTime IS NULL
					AND ULI.CompanyId = @CompanyId
					AND ULI.UserId = @OperationsPerformedBy
					AND ULI.IntegrationTypeId = @TypeId
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
