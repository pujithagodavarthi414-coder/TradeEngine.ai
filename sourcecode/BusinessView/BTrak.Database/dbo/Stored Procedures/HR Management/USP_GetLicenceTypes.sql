-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get Get Licence Types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetLicenceTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLicenceTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@LicenceTypeId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@LicenceTypeName NVARCHAR(250) = NULL,
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

		   IF(@LicenceTypeId = '00000000-0000-0000-0000-000000000000') SET @LicenceTypeId = NULL

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
           SELECT LT.Id AS LicenceTypeId,
		   	      LT.LicenceTypeName,
		   	      LT.CreatedDateTime,
		   	      LT.CreatedByUserId,
		   	      LT.[TimeStamp],
				  CASE WHEN LT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(*) OVER()
           FROM LicenceType LT       
           WHERE CompanyId = @CompanyId
		       AND (@LicenceTypeName IS NULL OR LT.LicenceTypeName = @LicenceTypeName)
		       AND (@SearchText IS NULL OR (LT.LicenceTypeName LIKE @SearchText))
			   AND (@LicenceTypeId IS NULL OR LT.Id = @LicenceTypeId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND LT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND LT.InActiveDateTime IS NULL))
           ORDER BY LT.LicenceTypeName ASC

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