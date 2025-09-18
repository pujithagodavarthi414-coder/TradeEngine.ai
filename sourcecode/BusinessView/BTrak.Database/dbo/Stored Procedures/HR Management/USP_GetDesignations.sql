-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get Designations
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetDesignations] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetDesignations]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@DesignationId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
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

		   IF(@DesignationId = '00000000-0000-0000-0000-000000000000') SET @DesignationId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT D.Id AS DesignationId,
		   	      D.CompanyId,
		   	      D.DesignationName,
		   	      D.InActiveDateTime,
		   	      D.CreatedDateTime,
		   	      D.CreatedByUserId,
		   	      D.[TimeStamp],	
				  CASE WHEN D.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM Designation AS D		        
           WHERE D.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (D.DesignationName LIKE @SearchText))
		   	   AND (@DesignationId IS NULL OR D.Id = @DesignationId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND D.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND D.InActiveDateTime IS NULL))
           ORDER BY D.DesignationName ASC

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