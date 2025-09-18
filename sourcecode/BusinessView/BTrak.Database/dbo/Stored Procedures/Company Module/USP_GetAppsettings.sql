-------------------------------------------------------------------------------
-- Author       Sai Kumar Kailasam
-- Created      '2019-09-17 00:00:00.000'
-- Purpose      To Get App Settings
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAppsettings] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAppsettings]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@AppsettingsId UNIQUEIDENTIFIER = NULL,	 
	@SearchText NVARCHAR(250) = NULL,
	@AppSettingsName NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@AppsettingsId = '00000000-0000-0000-0000-000000000000') SET @AppsettingsId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT A.Id AS AppsettingsId,
		   	      A.AppsettingsName,
				  A.AppSettingsValue,
		   	      A.InActiveDateTime,
		   	      A.CreatedDateTime,
		   	      A.CreatedByUserId,
		   	      A.[TimeStamp],
				  A.IsSystemLevel,
				  CASE WHEN A.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM Appsettings AS A		        
           WHERE (@SearchText IS NULL OR (A.AppSettingsName LIKE @SearchText))
		   	   AND (@AppsettingsId IS NULL OR A.Id = @AppsettingsId)
			   AND (@AppSettingsName IS NULL OR A.AppSettingsName = @AppSettingsName)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND A.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND A.InActiveDateTime IS NULL))
           ORDER BY A.AppSettingsName ASC

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