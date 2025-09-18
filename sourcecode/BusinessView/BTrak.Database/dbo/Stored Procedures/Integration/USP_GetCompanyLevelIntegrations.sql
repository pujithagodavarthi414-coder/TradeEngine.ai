---------------------------------------------------------------------------
-- Author       Siva Kumar Garadappagari
-- Created      '2021-01-20'
-- Purpose      To get Company integration
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetCompanyLevelIntegrations] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCompanyLevelIntegrations]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL
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
			CLI.Id AS Id,
			CLI.IntegrationTypeId AS IntegrationTypeId,
			CLI.IntegrationUrl,
			CLI.UserName,
			CLI.CreatedByUserId,
			CLI.CreatedDateTime,
			CLI.UpdatedByUserId,
			CLI.UpdatedDateTime,
			I.TypeName AS IntegrationType
			FROM [CompanyLevelIntegrations] CLI
			JOIN [Integrations] I ON CLI.IntegrationTypeId = I.Id AND I.InactiveDateTime IS NULL
			WHERE CLI.CompanyId = @CompanyId 
					AND ((@IsArchived = 1 AND CLI.InActiveDateTime IS NOT NULL) OR ((@IsArchived = 0 OR @IsArchived IS NULL) AND CLI.InActiveDateTime IS NULL))

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