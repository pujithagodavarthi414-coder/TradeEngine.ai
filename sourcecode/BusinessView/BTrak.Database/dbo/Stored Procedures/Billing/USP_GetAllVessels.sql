-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllVessels] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllVessels]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@VesselId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@VesselId = '00000000-0000-0000-0000-000000000000') SET @VesselId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT G.Id AS VesselId,
		   	      G.VesselName,
		   	      G.InActiveDateTime,
		   	      G.CreatedDateTime,
		   	      G.CreatedByUserId,
		   	      G.[TimeStamp],
				  CASE WHEN G.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM Vessel AS G
           WHERE G.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (G.VesselName LIKE @SearchText))
		   	   AND (@VesselId IS NULL OR G.Id = @VesselId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND G.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND G.InActiveDateTime IS NULL))
           ORDER BY G.VesselName ASC

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