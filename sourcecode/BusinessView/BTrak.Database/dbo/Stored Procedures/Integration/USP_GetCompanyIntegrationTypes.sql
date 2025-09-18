---------------------------------------------------------------------------
-- Author       Siva Kumar Garadappagari
-- Created      '2021-01-21'
-- Purpose      To get all company integration types 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetCompanyIntegrationTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCompanyIntegrationTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF (@HavePermission = '1')
	    BEGIN
			SELECT
				CLI.IntegrationTypeId AS IntegrationId,
				I.TypeName AS IntegrationType
				FROM [CompanyLevelIntegrations] CLI
				JOIN [Integrations] I ON CLI.IntegrationTypeId = I.Id AND I.InactiveDateTime IS NULL
				WHERE CLI.InactiveDateTime IS NULL AND CLI.CompanyId = @CompanyId GROUP BY CLI.IntegrationTypeId, I.TypeName
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