---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-09-10 00:00:00.000'
-- Purpose      To get the companysettings by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCompanySettings] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCompanySettings]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @Key NVARCHAR(500) = NULL,
	@Value NVARCHAR(500) = NULL,
	@Description NVARCHAR(500) = NULL,
	@SearchText   NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@CompanySettingsId UNIQUEIDENTIFIER = NULL,
	@IsFromExport BIT = NULL,
	@IsSystemApp BIT = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@IsSystemApp IS NULL)
		BEGIN
		   SET @HavePermission = 1
		END
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL

		   IF(@IsFromExport IS NULL)SET @IsFromExport = 0
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@CompanySettingsId = '00000000-0000-0000-0000-000000000000') SET @CompanySettingsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT C.Id AS CompanySettingsId,
		   	      C.CompanyId,
				  C.[Key],
		   	      C.[Value],
				  C.[Description],			
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime ,
		   	      C.CreatedByUserId,
		   	      C.[TimeStamp],
				  (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				  C.[IsVisible] As IsVisible,
		   	      TotalCount = COUNT(1) OVER()
           FROM CompanySettings AS C		        
           WHERE C.CompanyId = @CompanyId
				AND (@Key IS NULL OR C.[Key] = @Key)
				AND (@Value IS NULL OR C.[Value] = @Value)
				AND (@Description IS NULL OR C.[Description] = @Description)
		        AND (@SearchText  IS NULL OR (C.[Description] LIKE  @SearchText )  OR (C.[Key] LIKE  @SearchText ) OR (C.[Value] LIKE  @SearchText ))
		   	    AND (@CompanySettingsId IS NULL OR C.Id = @CompanySettingsId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))	   	    
				AND ((C.IsVisible <> 0 OR C.IsVisible IS NULL) OR @IsFromExport = 1)
           ORDER BY C.[Key] ASC

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
GO