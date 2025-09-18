---------------------------------------------------------------------------
-- Author       Siva Kumar Garadappagari
-- Created      '2021-01-18'
-- Purpose      To get all integration types 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetIntegrationTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetIntegrationTypes]
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
		   SELECT 
			I.Id AS IntegrationId,
			I.TypeName AS IntegrationType,
			I.CreatedByUserId,
			I.CreatedDateTime,
			I.UpdatedByUserId,
			I.UpdatedDateTime,
			(CASE WHEN I.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
			TotalCount = COUNT(*) OVER()
			FROM [Integrations] I WHERE I.InactiveDateTime IS NULL

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