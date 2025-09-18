---------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetProductsList]@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProductsList]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@ProductName NVARCHAR(250) = NULL,
	@ProductId UNIQUEIDENTIFIER = NULL,	
	@SearchText    NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText   = '') SET @SearchText   = NULL

		   SET @SearchText = '%'+ @SearchText +'%'
		   
		   IF(@ProductId = '00000000-0000-0000-0000-000000000000') SET @ProductId = NULL		  
		   
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT P.Id AS ProductId,
		   	      P.CompanyId,
				  P.[Name] AS ProductName,
		   	      P.InActiveDateTime,
		   	      P.CreatedDateTime ,
		   	      P.CreatedByUserId,
		   	      P.[TimeStamp],	
		   	      TotalCount = COUNT(1) OVER()
           FROM [MasterProduct] AS P		        
           WHERE P.CompanyId = @CompanyId
		        AND (@SearchText   IS NULL OR P.[Name] LIKE  @SearchText 
				     )				
		   	    AND (@ProductId IS NULL OR P.Id = @ProductId)
				AND (@ProductName IS NULL OR P.[Name] = @ProductName)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND P.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND P.InActiveDateTime IS NULL))
		   	    
           ORDER BY P.[Name] ASC

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