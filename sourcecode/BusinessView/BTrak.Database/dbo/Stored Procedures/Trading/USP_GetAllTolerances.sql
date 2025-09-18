-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllTolerances] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllTolerances]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@ToleranceId UNIQUEIDENTIFIER = NULL,	
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

		   IF(@ToleranceId = '00000000-0000-0000-0000-000000000000') SET @ToleranceId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT TL.Id AS ToleranceId,
		   	      TL.ToleranceName,
		   	      TL.InActiveDateTime,
		   	      TL.CreatedDateTime,
		   	      TL.CreatedByUserId,
		   	      TL.[TimeStamp],
				  CASE WHEN TL.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM Tolerance AS TL
           WHERE TL.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (TL.ToleranceName LIKE @SearchText))
		   	   AND (@ToleranceId IS NULL OR TL.Id = @ToleranceId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND TL.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TL.InActiveDateTime IS NULL))
           ORDER BY TL.ToleranceName ASC

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